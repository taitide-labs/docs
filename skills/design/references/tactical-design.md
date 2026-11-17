# 战术设计与黑盒验收冻结

遵循领域驱动建模与垂直切片融合规范，在工作区主干上同时冻结共享基础层、纯领域核、切片入参出参契约以及代码原生黑盒验收测试，同时保证主干随时全绿可编译、可审计。

严禁在本阶段提前编写切片内部实现 `workflow.rs`、`handler.rs` 及私有单元测试，必须将这些实现文件留给后续并行切片开发者自治，以避免多切片开发期修改同一组文件造成冲突并保留内部重构自由。

## 工作区物理拓扑

```text
workspace-root/
├── context-map.md
├── docs/adr/                         # 全局架构决策记录
├── contracts/openapi.json            # 聚合契约导出产物
├── migrations/                       # 全局递增 SQL 迁移脚本
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

- 解析而非校验：`primitives` 中的 `Money`、`Quantity`、`Sku`、`CouponCode` 及各强类型标识全部采用私有内部字段加 `try_new`，让非法状态在编译期不可表示；切片 `command.rs` 通过 `TryFrom` 将输入转换成受限原语。
- 枚举演进纪律：跨越上下文与切片边界的开放状态和集成事件枚举必须标注 `#[non_exhaustive]`；领域失败原因与端口错误枚举严禁标注 `#[non_exhaustive]`，强迫每个切片显式穷尽映射全部失败分支。
- 非叶声明与叶实现分离：遵循现代 Rust 模块组织，全仓禁用 `mod.rs`；`lib.rs`、`<slice>.rs`、`tests.rs` 与 `tests/acceptance.rs` 仅写 `mod` 与 `pub use` 声明，叶子源码严禁内联 `#[test]` 与 `mod tests { ... }` 块。
- 静态隔离门禁：读路径切片前缀 `qry_*` 严禁引用写侧领域包，直接查询数据库投影；写路径切片 `domain/` 与 `workflow.rs` 严禁引入 `sqlx`、`axum` 或 `tokio`；同上下文严禁跨切片直接导入符号。

## 冻结顺序与主干恒绿原则

1. 先落盘 `migrations/*.sql` 与根配置，并将所有新增工作区包加入 `Cargo.toml` 与 `release-please-config.json`。
2. 实现并通过 `primitives`、`contracts`、`infra` 以及各上下文共享 `domain/` 的 1 对 1 单元测试，放置于 `src/tests/<module>.rs`。
3. 为每个垂直切片冻结 `command.rs` 或 `query.rs` 结构体、状态设为 `SliceStatus::Planned` 的路由注册占位 `endpoint.rs`（通过 `inventory::submit!` 自动注册，生产环境自动过滤未完工路由），并在 `tests/acceptance/<slice>.rs` 编写覆盖正常流与边界拒止流的黑盒 `#[sqlx::test]` 验收考卷，暂挂固定属性 `#[ignore = "wip"]` 以确保主干默认全绿编译通过。
4. 先合并本冻结基线至 `main` 并通过完整静态与测试门禁，再进入工单编排与并发开发。
