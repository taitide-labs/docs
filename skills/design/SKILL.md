---
name: design
description: 从宏观问题空间向微观实现逐阶段推进软件设计、客户端实现闭环并冻结交付基线；当涉及规划新系统、新增业务功能、维护领域术语与上下文边界、变更接口契约或界面与命令行交互、冻结战术基线或拆解开发工单时必须使用；若是纯实现缺陷修复且不涉及业务规则或契约变更则无需使用。
---

从宏观问题空间向微观实现逐层收敛设计并冻结前置基线：

- 当启动全新项目时，全栈、后端或命令行项目从阶段 1 依序推进至阶段 6，纯前端项目完成阶段 3 即结束。
- 当处理存量变更时，从受波及的最上游阶段切入，仅推进受影响的阶段（上限至阶段 5）；当下游阶段未受波及时，经用户确认直接结束。
- 每次仅读取当前阶段的单一参考文件，防止后置细节污染当前上下文。
- 严禁跨阶段越序执行，必须经用户确认当前阶段完成后再进入下一阶段；当执行中需要修订上游事实源时，从受波及的最上游阶段重新切入。
- 严禁直接推送 `main`，所有需合入主干的阶段产出必须通过独立分支创建 PR 合并。
- 当任意阶段存在未决分叉时，使用 `grilling` Skill 发起前沿追问。

## 阶段流程

1. 战略设计：划分业务子域、限界上下文与统一语言，读取 [strategic-design.md](references/strategic-design.md)。
2. 契约设计：当存在对外或跨上下文契约时，读取 [contract-design.md](references/contract-design.md) 定义跨端接口契约及跨上下文同步端口与集成事件；否则经确认跳过。
3. 交互设计：当涉及用户交互表面时，客户端读取 [client-design.md](references/client-design.md) 完成客户端设计与实现闭环（纯前端项目或纯前端变更至此结束），命令行读取 [cli-design.md](references/cli-design.md) 确认命令行体验；纯后端服务经确认跳过。
4. 战术设计：读取 [tactical-design.md](references/tactical-design.md)，冻结后端或命令行的共享领域模型、数据库迁移、切片契约入口与黑盒验收测试。
5. 任务拆解：读取 [task-slicing.md](references/task-slicing.md)，编排临时工单拓扑 YAML 并调用 `design` Skill 目录下的 `./scripts/create-issues.ts`（可用 `--help` 查看用法）批量创建 GitHub 工单。
6. 示范交付：仅限全新项目，经用户确认后使用 `implement` Skill 交付首个 Walking Skeleton 切片验证装配线，合入后结束。

## ADR 规范

- 当决策同时满足难逆转、脱离背景令人费解、存在真实方案权衡三项条件时，即刻落盘 ADR；缺任一项时跳过。
- 全局决策存于 `docs/adr/NNNN-slug.md`，限界上下文专属决策存于 `<module_path>/docs/adr/NNNN-slug.md`。
- 编号单调递增，新建状态固定为 `accepted`；当既有决策因业务下线直接作废且无继任方案时改为 `deprecated`；当既有决策被新决策推翻时，新增 ADR 并将旧篇状态改为 `superseded by [NNNN-slug.md](./NNNN-slug.md)`。

```markdown
# <决策简短标题>

Status: <accepted | deprecated | superseded by [NNNN-slug.md](./NNNN-slug.md)>

<1-3 句话说明背景、最终决定与核心理由>

## 备选方案

<仅当被否决方案值得保留教训时填写，否则省略本节>

## 影响

<仅当存在非显而易见的架构后果时填写，否则省略本节>
```
