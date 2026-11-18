# 战略设计

遵循 Domain Modeling Made Functional 与 DMMF 范式梳理问题空间，围绕 `Big Picture Event Storming`、`Shared-Nothing` 与 `SSOT` 收敛业务边界与领域语义。严禁在本阶段输出数据库表结构、HTTP 路由或代码实现细节，必须把问题空间严格隔离在战略层，以避免技术选型过早污染领域模型。

## 执行流程

1. 切分子域并锁定核心域：
   - 全新项目基于行业先验推演业务全貌；增量或变更需求先读取既有 `context.md` 与 `context-map.md` 评估影响范围。
   - 聚焦决定竞争壁垒的核心域发起追问；将支撑域与通用域打包为单行行业默认摘要供用户默认采纳，从而把有限注意力集中于核心域分叉。
2. 对齐统一语言：
   - 围绕核心域收敛业务术语，每项术语必须显式绑定代码 `等价` 标识符以建立全仓 `SSOT`，同时列明 `避免` 混用的近义旧词。
   - 当发现术语含糊、一词多义或与既有代码标识符冲突时，立即通过具体边缘场景检验概念边界。
3. 梳理流水线与收敛 `Hotspots`：
   - 沿时间轴拉出核心 `Command -> Workflow -> DomainEvent` 主干链条，针对状态锁定、并发竞争与失败补偿识别 `Hotspots` 并逐轮收敛业务分叉。
   - 在全新项目中同时划定首期 `Walking Skeleton` 的最小端到端闭环范围。
4. 划定限界上下文与落盘产物：
   - 遵循 `Shared-Nothing` 原则，依据同一概念在不同阶段的语义分裂点切分自治的限界上下文，并按 DDD 上下文映射策略标注关系角色，例如 `OHS`、`PL`、`ACL` 与 `SK`。
   - 新项目先从根目录单一 `context.md` 起步；当出现一词多义或术语明显成簇时，拆分为根目录 `context-map.md` 与各上下文目录内的 `context.md`，并按需落盘战略 `ADR`。

## 产物模板

根目录或上下文目录 `<module_path>/context.md`：

```markdown
# <上下文名称>

<1-2 句话说明该限界上下文定位与所纳入的支撑域默认摘要>

## 术语

**<术语名称>**: <1-2 句话定义它是什么，而非做什么>
- 等价：`<CodeIdentifier>`
- 避免：<易混词 1>, <易混词 2>

## Workflow

- `<WorkflowName>`: `<Command>` -> `<DomainEvent>`
```

根目录 `context-map.md`：

```markdown
# 上下文地图

## 限界上下文

- [<上下文名称>](./<module_path>/context.md) — <职责与子域分类>

## 关系模式

- <上游上下文> [<关系角色如 OHS、PL>] -> <下游上下文> [<关系角色如 ACL>]
  - 事件：发布 `<DomainEvent>`，下游订阅触发 `<WorkflowName>`
  - 同步端口：调用 `<PortTrait>` 完成即时校验或预占
```
