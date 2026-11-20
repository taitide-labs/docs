---
name: implement
description: 在隔离工作树内对照冻结契约与验收基线交付后端切片、客户端切片或端到端合龙任务。当认领开发工单编写业务实现、补齐单元测试并提交 PR 时必须使用，即使未明确提及该技能
---

在基于最新主干分支拉出的隔离 `Worktree` 内认领单一工单，严格遵守冻结只读区边界与静态检查门禁，仅通过工作区统一任务入口验证并将全部结果交由自动化测试证明。

## 前置纪律与模式分发

- 冻结防线：严禁篡改上游共享契约、数据库迁移脚本、共享 `domain` 签名及黑盒验收考卷既有断言以防 `Reward Hacking`；当确认上游契约存在真实缺口时，立即中止当前切片分支并回到主干通过 `design` Skill 走增量修订流程。
- 按工单类型每次仅读取下列唯一一份执行指南：
  1. 服务端命令或查询垂直切片：读取 [backend-slice.md](references/backend-slice.md)。
  2. 图形客户端页面或命令行切片：读取 [client-slice.md](references/client-slice.md)。
  3. 末尾跨上下文端到端合龙、契约导出或前后端联调工单：读取 [e2e-cutover.md](references/e2e-cutover.md)。

## 统一交付门禁

1. 严禁裸调底层零散检查命令，必须使用 `mise run fmt` 自动修复排版格式，随后执行 `mise run check` 确认全量文档、架构规则、编译门禁、隔离测试与依赖许可审计全绿。
2. 遵循 Conventional Commits 规范提交仅包含本工单自治目录的变更，推送分支创建 PR 并关联关闭对应工单，等待 `Merge Gate` 通过后按仓库合入规则加入 `Merge Queue` 或执行 Squash 合并。
