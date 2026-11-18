# 战术设计与验收冻结

遵循 `Modular Monolith`、`VSA`、`DMMF` 与 `CQRS` 融合架构及 `Trunk-Based Development` 规范，在工作区主干同时冻结共享基础层、纯领域核、切片入参出参契约以及代码原生 `ATDD` 黑盒验收考卷，同时确保主干随时全绿可编译、可审计。

严禁在本阶段提前编写切片内部实现 `workflow.rs`、`handler.rs` 及白盒单元测试，必须将这些实现文件留给后续并行切片开发者自治，以避免多切片开发期修改同一组文件造成冲突并保留内部重构自由。

## 工作区物理拓扑

```text
workspace-root/
├── context-map.md
├── docs/adr/                         # 全局架构决策记录
├── contracts/openapi.json            # 聚合契约导出产物
├── migrations/                       # 全局递增 SQL 迁移脚本
├── rules/                            # ast-grep 架构边界静态规则
└── crates/
    ├── primitives/                   # 受限基础值原语，私有构造与 try_new
    ├── contracts/                    # 跨上下文同步端口与集成事件
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
    │           └── <slice>.rs        # 纯子模块声明，无 mod.rs
    ├── server/                       # 宿主组合根与 OpenAPI 导出
    └── e2e-journeys/                 # 跨上下文端到端旅程测试
```

## 类型、模块与门禁规则

- 类型安全防线：依据 `Making Illegal States Unrepresentable` 与 `ADT` 建模原则，将 `primitives` 中的领域值对象与强类型标识设计为私有内部字段配 `try_new` 构造防线，让非法状态在编译期不可表示；遵循 `Parse, Don't Validate`，在写切片 `command.rs` 实现 `TryFrom` 入口一次性解析。
- 内核与外壳隔离：依据 `Functional Core, Imperative Shell` 与 `Persistence Ignorance` 原则，读路径切片前缀 `qry_*` 直接查询数据库视图投影且严禁导入写侧领域包；写路径 `domain/` 与 `workflow.rs` 严禁引入 `sqlx`、`axum` 或 `tokio`，由切片 `handler.rs` 充当命令式外壳编排副作用。
- 枚举演进纪律：跨越上下文与切片边界的开放状态和集成事件枚举必须标注 `#[non_exhaustive]`；领域失败原因与端口错误枚举严禁标注 `#[non_exhaustive]`，强迫每个切片入口显式穷尽映射全部失败分支。
- 非叶声明与叶实现分离：遵循现代 Rust 模块组织，全仓禁用 `mod.rs`；`lib.rs`、`<slice>.rs`、`tests.rs` 与 `tests/acceptance.rs` 仅写 `mod` 与 `pub use` 声明，叶子源码严禁内联 `#[test]` 与 `mod tests` 块；同上下文严禁跨切片直接导入符号。

## 冻结顺序与主干恒绿原则

1. 落盘底层骨架：先创建 `migrations/*.sql` 与根配置，将所有新增工作区包加入 `Cargo.toml` 与发布清单配置。
2. 完成共享内核：实现并通过 `primitives`、`contracts`、`infra` 以及各上下文共享 `domain/` 的 1 对 1 单元测试，放置于 `src/tests/<module>.rs`；增量改造共享模型或表结构时严格遵循 `Parallel Change` 保持存量绿灯。
3. 冻结 `Keystone Interface`：为每个垂直切片冻结 `command.rs` 或 `query.rs` 结构体以及状态设为 `SliceStatus::Planned` 的占位 `endpoint.rs`；借助 `inventory::submit!` 自动收集路由并由 `lib.rs` 暴露空函数 `link()` 防止静态消除，确保生产构建自动屏蔽未完工路由且多切片并行期间零路由表合并冲突。
4. 冻结黑盒验收考卷：依据 `Specification by Example` 与 `Given-When-Then` 思路在单入口聚合的 `tests/acceptance/<slice>.rs` 中使用 `#[sqlx::test]` 与 `#[rstest]` 参数化矩阵编写覆盖正常流与边界拒止流的黑盒考卷，暂挂固定属性 `#[ignore = "wip"]` 以供需求确认并防止下游实现 `Reward Hacking`。
5. 先将完整冻结基线全绿合入 `main` 并通过静态与测试门禁，再进入工单编排与并发开发。
