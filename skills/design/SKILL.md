---
name: design
description: 从战略建模、契约冻结、交互原型、战术基线到工单拆解的软件设计唯一入口。当涉及规划新系统、维护领域术语与上下文边界、变更接口契约或编排多切片并发基线时必须使用，即使未明确提及该技能
---

从宏观问题空间向微观实现细节逐层推进软件设计并冻结前置基线。每次仅读取当前所处阶段的单一参考文件，以避免后续细节过早污染当前上下文；进入下一阶段前必须获得用户确认，严禁跨阶段抢跑以免契约未稳先写实现。当任意阶段存在未决分叉需要拍板时，读取并遵循 [grilling](../grilling/SKILL.md) 发起前沿追问。

## 阶段流程

1. 战略设计：收敛子域划分、统一语言、`Workflow` 与限界上下文，读取 [strategic-design.md](references/strategic-design.md)。
2. 契约设计：锁定跨端接口契约与跨上下文同步端口及异步事件，读取 [contract-design.md](references/contract-design.md)。
3. 原型设计：按产品形态锁定客户端交互、`Feature Map` 与 `Golden Snapshot` 基线，读取 [prototype-design.md](references/prototype-design.md)。
4. 战术设计与验收冻结：构建 Modular Monolith 底座、共享纯领域核与带标记的黑盒验收考卷，读取 [tactical-design.md](references/tactical-design.md)。
5. 任务拆解：基于主干全绿基线投射 GitHub 原生里程碑与父子工单，读取 [task-slicing.md](references/task-slicing.md)。
6. 示范或并行交付：全新项目优先选取一条最小端到端通路按 `Walking Skeleton` 交付首个切片验证装配线，随后并发交付其余工单，执行时读取 [implement](../implement/SKILL.md)。

## 增量变更路由

- 当新增业务子域、调整限界上下文或修订 `context.md` 领域术语时，从阶段 1 起步；术语定稿后必须顺带核查绑定的代码标识符与下游契约是否受波及，未受波及则经用户确认后直接在阶段 1 收工，受波及则沿后续阶段继续推进以守住 `SSOT`。
- 当涉及跨切片联动或修改接口字段、同步端口、集成事件与表面交互契约时，从阶段 2 起步。
- 当仅在既有单一切片内部调整局部规则、错误映射或界面样式时，直接从阶段 4 起步，遵循 `Parallel Change` 追加带 `#[ignore = "wip"]` 的新验收场景后再拆单实现。

## ADR 规范

- 当决策同时满足难逆转、脱离背景令人费解、存在真实方案权衡三项条件时，必须立即落盘 `ADR`；缺任一项即跳过，以防低质文档泛滥。
- 全局决策存于根目录 `docs/adr/NNNN-slug.md`，限界上下文局部决策就近存于 `<module_path>/docs/adr/NNNN-slug.md`。
- 尚未合入主干的草稿可在当前分支修订或移除；一旦合入主干即永久锁定编号，当旧决策失效时通过新文件声明替代关系，严禁重排已合入历史编号以保护提交与工单引用。

```markdown
# <决策简短标题>

<1-3 句话说明背景、最终决定与核心理由>

## 备选方案

<仅当被否决方案值得保留教训时填写，否则省略本节>

## 影响

<仅当存在非显而易见的架构后果时填写，否则省略本节>
```
