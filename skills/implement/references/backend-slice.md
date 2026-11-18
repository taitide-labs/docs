# 后端垂直切片实现

对照主干冻结契约与黑盒验收考卷，在独立 `Worktree` 内完成单个后端垂直切片并激活其 `Keystone Interface`。

## 读写边界划分

- 冻结只读区：严禁在切片分支内修改 `primitives`、`contracts`、`infra`、`migrations/*.sql`、共享 `domain`、切片公开入参出参以及 `tests/acceptance/<slice>.rs` 中的既有断言。
- 切片自治区：读写范围限定于目标切片入口声明 `<slice>.rs`、内部管道与适配器模块 `workflow.rs`、`handler.rs`、`port.rs`、`endpoint.rs`、1 对 1 代码单元级单测 `src/<slice>/tests/*`，以及删去 `tests/acceptance/<slice>.rs` 目标场景上的 `#[ignore = "wip"]` 标记。

## 执行步骤

1. 对齐坐标：读取目标 GitHub Issue、所属上下文 `context.md`、切片冻结契约 `command.rs` 或 `query.rs` 与 `tests/acceptance/<slice>.rs` 考卷场景，确认本地依赖数据库已通过工作区任务就绪。
2. 编写核心逻辑与外壳：
   - 写路径切片遵循 `Parse, Don't Validate` 在 `command.rs` 实现 `TryFrom` 构造受限原语、依照 `Functional Core, Imperative Shell` 与 `Persistence Ignorance` 在 `workflow.rs` 实现零副作用纯函数计算、在 `handler.rs` 编排副作用并落地 `Transactional Outbox` 与 `Optimistic Concurrency Control`，以及在 `endpoint.rs` 映射错误状态码并切换 `SliceStatus::Active` 激活路由注册。当同时涉及外部同步端口与本地落库时，必须在开启本地短事务前完成外部调用并取得凭证，若本地事务失败则同步补偿释放。
   - 读路径切片遵循 `CQRS` 省略 `workflow.rs` 与写侧 `domain` 调用，在 `handler.rs` 直接执行无 N+1 退化的只读 SQL 投影返回响应，并在 `endpoint.rs` 切换 `SliceStatus::Active`。
3. 编写 1 对 1 单元测试：严格遵循非叶声明与叶实现分离规则，通过切片声明 `<slice>.rs` 挂载 `#[cfg(test)] mod tests;`，在 `tests.rs` 声明对应 `<unit>.rs`，并在 `<slice>/tests/<unit>.rs` 覆盖边界计算与 `TryFrom` 解析规则；严禁创建 `mod.rs` 或在叶子源码内直接书写 `#[test]`。
4. 解锁黑盒考卷：移去 `tests/acceptance/<slice>.rs` 对应验收场景上的 `#[ignore = "wip"]` 标记并确认全绿。
