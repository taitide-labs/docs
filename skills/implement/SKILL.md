---
name: implement
description: 在隔离工作树或分支内对照冻结契约与黑盒验收考卷交付单个垂直切片。当需要实现已冻结的垂直切片、编写 1 对 1 单元测试并提交 PR 合入主干时必须使用，即使未明确提及该技能
---

在隔离工作树或分支内交付垂直切片，严格遵守冻结边界与静态检查门禁，仅通过工作区任务入口验证并将全部结果交由自动化测试证明。

## 读写边界划分

- 冻结只读区：严禁在切片分支内篡改 `primitives`、`contracts`、`infra`、`migrations/*.sql`、共享 `domain`、切片入参出参公开定义以及 `tests/acceptance/<slice>.rs` 中的既有断言，必须先基于冻结基线完成实现以防并行冲突或破坏验收真值。当确认上游契约存在真实缺陷时，先中止当前切片并在主干单独发起契约变更流程。
- 切片自治区：读写范围限定于目标切片入口声明 `<slice>.rs`、内部管道与适配器模块 `workflow.rs` / `handler.rs` / `port.rs` / `endpoint.rs`、代码单元级测试 `src/<slice>/tests/*`，以及删去 `tests/acceptance/<slice>.rs` 中对应场景的 `#[ignore = "wip"]` 标记。

## 执行流程

1. 对齐目标坐标：先读取对应 GitHub Issue、所属上下文 `context.md`、切片冻结契约 `command.rs` 或 `query.rs` 及 `tests/acceptance/<slice>.rs` 考卷场景，确认依赖数据库服务已通过工作区任务启动。
2. 编写核心逻辑与外壳：
   - 写路径切片遵循输入 `TryFrom` 构造受限原语、零副作用纯函数 `workflow.rs` 计算、命令式外壳 `handler.rs` 编排，以及 `endpoint.rs` 状态码映射与切换 `SliceStatus::Active` 激活路由注册。当涉及跨上下文同步端口与本地落库时，必须在开启本地数据库事务前完成外部端口调用，若本地事务失败则同步补偿释放。
   - 读路径切片省略 `workflow.rs` 与写侧 `domain` 调用，在 `handler.rs` 直接执行只读 SQL 查询投影返回响应结构，并在 `endpoint.rs` 切换 `SliceStatus::Active`。
3. 编写 1 对 1 单元测试：严格遵循非叶声明与叶实现分离规则，通过切片声明 `<slice>.rs` 挂载 `#[cfg(test)] mod tests;`，在 `tests.rs` 声明对应 `<unit>.rs`，并在 `<slice>/tests/<unit>.rs` 覆盖边界计算与 `TryFrom` 解析规则；严禁创建 `mod.rs` 或在叶子源码内直接书写 `#[test]`。
4. 全链路本地验卷与提单合入：严禁裸调底层编译或扫描命令，必须统一使用 `mise run fmt` 修复排版与格式，并使用 `mise run check` 执行包含文档、结构规则、编译器门禁、隔离数据库验收测试与依赖许可审计在内的全套校验；全绿后按 Conventional Commits 规范提交并推送分支创建 PR，关联关闭对应 Issue，等待 `Merge Gate` 通过后合入主干。
