---
name: design
description: 从宏观问题空间向微观实现逐阶段推进软件设计并冻结交付基线。当涉及规划新系统、维护领域术语与上下文边界、变更接口契约或拆解开发工单时必须使用。
---

从宏观问题空间向微观实现逐层收敛设计并冻结前置基线：

- 全新项目从阶段 1 依序推进至阶段 6；存量变更从受波及的最上游阶段切入，仅推进受影响的阶段（上限至阶段 5），当下游阶段未受波及时经用户确认直接收工。
- 每次仅读取当前阶段的单一参考文件，防止后置细节污染当前上下文；严禁跨阶段抢跑，必须经用户确认当前阶段完成后再进入下一阶段；若执行中需要修订上游事实源，从受波及的最上游阶段重新切入。
- 当任意阶段存在未决分叉时，使用 `grilling` Skill 发起前沿追问。

## 阶段流程

1. 战略设计：划分业务子域、限界上下文与统一语言，读取 [strategic-design.md](references/strategic-design.md)。
2. 契约设计：定义跨端接口契约及跨上下文同步端口与集成事件（无对外或跨上下文契约时确认后跳过），读取 [contract-design.md](references/contract-design.md)。
3. 交互设计：确认客户端界面或命令行交互体验（纯后端服务确认后跳过），客户端读取 [client-design.md](references/client-design.md)，命令行读取 [cli-design.md](references/cli-design.md)。
4. 战术设计：冻结共享领域模型、数据库迁移、切片契约入口与黑盒验收测试，读取 [tactical-design.md](references/tactical-design.md)。
5. 任务拆解：将冻结基线拆解为 GitHub 工单与阻塞依赖图，读取 [task-slicing.md](references/task-slicing.md)。
6. 示范交付：仅限全新项目，经用户确认后使用 `implement` Skill 交付首个 Walking Skeleton 切片验证装配线，合入后收工。

## ADR 规范

- 当决策同时满足难逆转、脱离背景令人费解、存在真实方案权衡三项条件时，即刻落盘 ADR；缺任一项时跳过。
- 全局决策存于 `docs/adr/NNNN-slug.md`，限界上下文专属决策存于 `<module_path>/docs/adr/NNNN-slug.md`。
- 编号单调递增，新建状态固定为 `accepted`；当既有决策因业务下线直接作废且无继任方案时改为 `deprecated`，被新决策推翻时新增 ADR 并将旧篇状态改为 `superseded by [NNNN-slug.md](./NNNN-slug.md)`。

```markdown
# <决策简短标题>

Status: <accepted | deprecated | superseded by [NNNN-slug.md](./NNNN-slug.md)>

<1-3 句话说明背景、最终决定与核心理由>

## 备选方案

<仅当被否决方案值得保留教训时填写，否则省略本节>

## 影响

<仅当存在非显而易见的架构后果时填写，否则省略本节>
```
