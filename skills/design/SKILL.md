---
name: design
description: 从战略建模、契约冻结、交互原型、战术基线到工单拆解推进软件设计。当涉及规划新系统、维护领域术语与上下文边界、变更接口契约或编排多切片交付基线时必须使用，即使未明确提及该技能。
---

从宏观问题空间向微观实现细节逐层推进软件设计并冻结前置基线。每次仅读取当前所处阶段的单一参考文件，以避免后置细节过早污染当前上下文；严禁跨阶段抢跑，进入下一阶段前必须先获得用户确认，以免契约未稳先写实现。当任意阶段存在未决分叉需要拍板时，读取并遵循 [grilling](../grilling/SKILL.md) 发起前沿追问。

## 阶段流程

1. 战略设计：收敛子域划分、统一语言、`Workflow` 与限界上下文，读取 [strategic-design.md](references/strategic-design.md)。
2. 契约设计：锁定跨端接口契约及跨上下文同步端口与异步事件，读取 [contract-design.md](references/contract-design.md)。
3. 原型设计：按产品形态锁定客户端交互、`Feature Map` 与 `Golden Snapshot` 基线，读取 [prototype-design.md](references/prototype-design.md)。
4. 战术设计与验收冻结：遵循 `Trunk-Based Development` 构建 `Modular Monolith` 底座、共享纯领域核与带 `wip` 跳过标记的黑盒验收考卷，读取 [tactical-design.md](references/tactical-design.md)。
5. 任务拆解：基于已合入 `main` 的冻结基线投射 GitHub 原生里程碑与父子工单依赖图，读取 [task-slicing.md](references/task-slicing.md)；存量项目经用户确认工单后直接收工。
6. 示范切片交付：当项目为全新系统且经用户确认启动示范开发时，选取唯一一条最小端到端通路按 `Walking Skeleton` 交付首个切片以验证装配线，读取 [implement](../implement/SKILL.md) 执行并在合入后即刻收工，将其余工单留给用户按需调度。

## 增量变更路由

- 当新增业务子域、调整限界上下文或修订 `context.md` 领域术语时，从阶段 1 起步；术语定稿后应当顺带核查绑定的代码标识符与下游契约是否受波及，未受波及时经用户确认直接在阶段 1 收工，受波及时沿后续阶段继续推进以守住 `SSOT`。
- 当涉及跨切片联动或修改对外接口、同步端口、集成事件与表面交互契约时，从阶段 2 起步。
- 当仅在既有单一切片内部调整局部规则、错误映射或界面样式时，直接从阶段 4 起步，遵循 `Parallel Change` 追加带 `wip` 跳过标记的新验收用例后再拆单。

## ADR 规范

- 当决策同时满足难逆转、脱离背景令人费解、存在真实方案权衡三项条件时，即刻落盘 `ADR`；缺任一项时跳过，以防低质文档泛滥。
- 全局决策存于根目录 `docs/adr/NNNN-slug.md`，限界上下文专属决策就近存于 `<module_path>/docs/adr/NNNN-slug.md`。
- 编号单调递增，新建落盘时状态固定为 `accepted`；当既有决策因业务下线直接作废且无继任方案时改为 `deprecated`，被新决策推翻时新增 `ADR` 并将旧篇状态改为 `superseded by [NNNN-slug.md](./NNNN-slug.md)`，以供阅读路由跳转并由死链门禁自动校验目标文件。

```markdown
# <决策简短标题>

Status: <accepted | deprecated | superseded by [NNNN-slug.md](./NNNN-slug.md)>

<1-3 句话说明背景、最终决定与核心理由>

## 备选方案

<仅当被否决方案值得保留教训时填写，否则省略本节>

## 影响

<仅当存在非显而易见的架构后果时填写，否则省略本节>
```
