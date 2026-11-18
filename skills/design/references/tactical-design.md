# 战术设计与验收冻结

遵循 `Modular Monolith`、`VSA`、`DMMF`、`CQRS` 融合架构与 `Trunk-Based Development`，在主干一次性冻结共享基础层、纯领域核、切片入参出参契约以及挂起 `wip` 跳过标记的代码原生 `ATDD` 黑盒验收考卷。

严禁在本阶段编写切片内部的业务编排、处理器实现及白盒单元测试，必须仅落盘共享内核、切片契约骨架与验收考卷，以消除后续多工作树并行开发时的合并冲突并保留切片内部重构自由。

## 代码放置与架构规则

- 跨界原语与协议分层：当值对象、强类型标识或交互协议跨越多个限界上下文时，归入全局 `primitives`（仅存放私有内部字段配校验构造入口的受限业务原语，避免退化为通用工具杂物间）或 `contracts`（仅存放同步 `Port`、开放 `IntegrationEvent` 与非确定性基础设施抽象）。
- 上下文共享领域核：当纯状态转化与核心不变量在同一限界上下文内被两个及以上写切片共享时，归入该上下文的共享 `domain` 层，遵循 `Making Illegal States Unrepresentable` 与 `Persistence Ignorance` 保持零外部 I/O 依赖。
- 读写垂直切片隔离：当代码服务于具体用例时，归入独立垂直切片目录且避免同上下文跨切片互引。写切片以 `cmd_` 为前缀，遵循 `Parse, Don't Validate` 在入口一次性将原始输入解析为受限命令，按 `Functional Core, Imperative Shell` 将复杂纯计算提炼为无副作用 `workflow` 并由命令式 `handler` 编排外部端口与本地事务；读切片以 `qry_` 为前缀，严禁导入写侧 `domain` 模型，必须按 `CQRS` 直接执行只读视图投影返回响应，以免缴纳冗余的充血对象组装税。
- 枚举开闭纪律：跨越上下文与切片边界分发的生命周期状态和集成事件采用开放枚举，强制下游匹配保留未知变体兜底分支；上下文内部的领域失败原因与同步 `Port` 错误采用封闭枚举，强制每个切片入口显式穷尽映射全部失败分支。

## 冻结顺序

1. 落盘底层骨架：创建全局递增数据库迁移脚本与工作区模块及发版清单配置。
2. 完成共享内核：实现并通过 `primitives`、`contracts`、基础设施层及各上下文共享 `domain` 的 1 对 1 单元测试；当增量改造既有共享模型或表结构时，遵循 `Parallel Change` 按扩展、迁移、收缩保留兼容层。
3. 冻结 `Keystone Interface`：为每个垂直切片冻结入参出参契约及初始标记为未激活（`Planned`）的自注册路由入口，确保生产构建自动屏蔽未完工路由且多切片并行期间零中央路由表合并冲突。
4. 冻结黑盒验收考卷：依据 `Specification by Example` 与 `Given-When-Then` 在切片黑盒测试中基于隔离临时数据库与参数化边界矩阵编写覆盖正常流与异常拒止流的验收考卷；既有绿灯断言保持不动，新用例统一挂起 `wip` 跳过标记，以供需求审阅并防范下游 `Reward Hacking`。
5. 合入冻结基线：通过工作区全量静态检查与测试门禁后，将完整冻结基线先行合入 `main`。

## Rust 栈物理拓扑与编译约束

当目标仓库采用 Rust 技术栈时，按下列物理拓扑与工具链约束落盘：

```text
workspace-root/
├── context-map.md
├── docs/adr/                         # 全局架构决策记录
├── contracts/openapi.json            # 聚合契约导出产物
├── migrations/                       # 全局递增 SQL 迁移脚本
├── rules/                            # ast-grep 架构边界静态规则
└── crates/
    ├── primitives/                   # 受限基础值原语，私有字段与 try_new
    ├── contracts/                    # 跨上下文同步端口与 #[non_exhaustive] 集成事件
    ├── infra/                        # AppState、EventBus、SliceDescriptor 注册表
    ├── contexts/<ctx>/
    │   ├── context.md
    │   ├── domain/                   # 共享纯状态机与封闭错误枚举
    │   └── slices/
    │       ├── tests/
    │       │   ├── acceptance.rs     # 单测试根入口，仅声明 #[path] 子模块
    │       │   └── acceptance/<slice>.rs
    │       └── src/
    │           ├── lib.rs            # 纯切片声明与 link() 链接锚点
    │           └── <slice>.rs        # 纯子模块声明
    ├── server/                       # 宿主组合根与 OpenAPI 导出
    └── e2e-journeys/                 # 跨上下文端到端旅程测试
```

- 包粒度与测试防膨胀：每个限界上下文最多拆分 `domain` 与 `slices` 两个 Crate（纯查询上下文可省略 `domain`），避免每切片独立建包造成运行时重复链接；L2 黑盒考卷统一由单一集成测试目标 `tests/acceptance.rs` 通过 `#[path = "acceptance/<slice>.rs"]` 聚合，使用 `#[sqlx::test]` 与 `#[rstest]` 编写并在未实现场景标注 `#[ignore = "wip"]`。
- 模块树与非叶声明分离：严禁使用 `mod.rs` 或在叶子业务源码中内联 `#[test]` 与 `mod tests` 块，必须将 `lib.rs`、`<slice>.rs`、`tests.rs` 与 `tests/acceptance.rs` 限定为纯 `mod` 与 `pub use` 声明容器，并将单元测试独立落盘于 `src/tests/<unit>.rs` 或 `src/<slice>/tests/<unit>.rs`。
- 零冲突路由自注册：各切片在 `endpoint.rs` 中通过 `inventory::submit!` 提交初始状态为 `SliceStatus::Planned` 的路由描述符，并在 `slices/src/lib.rs` 暴露空函数 `link()` 供 `server` 显式调用一次，防止静态链接阶段消除注册段。
