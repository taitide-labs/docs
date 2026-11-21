# 后端垂直切片实现

对照主干冻结契约与黑盒验收测试，在隔离 `Worktree` 内完成单个后端垂直切片并激活其 `Keystone Interface`。以 Rust 技术栈示例，其他编程语言等义迁移。

## 读写边界划分

- 冻结只读区：`primitives`、`contracts`、`infra`、`migrations/*.sql`、共享 `domain`、切片公开入参出参及 `tests/acceptance/<slice>.rs` 中的既有断言（仅允许移除工单显式授权取代的旧规则场景）。
- 切片自治区：目标切片入口声明 `<slice>.rs`、内部管道与适配器模块 `workflow.rs`、`handler.rs`、`port.rs`、`endpoint.rs`、单元测试 `src/<slice>/tests/*`，以及移除 `tests/acceptance/<slice>.rs` 目标场景上的 `#[ignore = "wip"]` 标记（及工单授权取代的旧场景）。

## 执行步骤

1. 对齐坐标：读取目标 GitHub Issue、所属上下文 `context.md`、切片冻结契约 `command.rs` 或 `query.rs` 及 `tests/acceptance/<slice>.rs` 验收场景，确认本地依赖数据库已通过工作区任务就绪。
2. 编写写路径切片：
   - 遵循 `Parse, Don't Validate` 在 `command.rs` 实现 `TryFrom` 构造受限原语。
   - 依照 `Functional Core, Imperative Shell` 与 `Persistence Ignorance` 在 `workflow.rs` 实现零副作用纯函数计算。
   - 在 `handler.rs` 编排副作用并落地 `Transactional Outbox` 与 `Optimistic Concurrency Control`；当同时涉及跨上下文同步端口与本地落库时，必须在开启本地短事务前完成外部调用并取得凭证，若本地事务失败则执行失败逆向释放。
   - 在 `endpoint.rs` 映射 RFC 9457 错误响应并切换 `SliceStatus::Active` 激活路由注册。
3. 编写读路径切片：
   - 遵循 `CQRS` 省略 `workflow.rs` 且不导入写侧 `domain` 模型，在 `handler.rs` 直接执行无 N+1 退化的只读 SQL 投影返回响应。
   - 在 `endpoint.rs` 切换 `SliceStatus::Active` 激活路由注册。
4. 编写单元测试：
   - 严禁创建 `mod.rs` 或在叶子业务源码内直接书写 `#[test]`，必须通过 `<slice>.rs` 挂载 `#[cfg(test)] mod tests;`，在 `tests.rs` 声明对应 `<unit>.rs`，并在 `<slice>/tests/<unit>.rs` 覆盖边界计算与 `TryFrom` 解析规则。
5. 激活黑盒验收测试与单切片契约导出：
   - 移去 `tests/acceptance/<slice>.rs` 对应验收场景上的 `#[ignore = "wip"]` 标记，确认全部测试通过。
   - 当本次交付属于不设端到端整体验收工单的单切片对外 HTTP 变更时，同步执行集成导出任务重新生成 `contracts/openapi.json`，并通过兼容性工具（如 `oasdiff`）确认符合 `Parallel Change` 向后兼容约束。
