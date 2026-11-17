# 任务拆解与工单编排

基于已经合入主干并冻结成功的基线契约与验收测试，在 GitHub 上编排声明业务意图与真值坐标的 Milestone 与原生父子工单。

工单只描述业务目标、规则边界与代码库坐标；将工作树命令、格式检查、门禁规避防线留给开发规范与自动化流水线，保持工单信噪比最大化。

## 编排规则

1. 核对主干已合并本次设计涉及的迁移脚本、领域模型、切片入口骨架及带标记的验收考卷，确认当前基线全绿。
2. 创建或复用代表本次迭代版本的 GitHub Milestone，统一关联本批所有工单。
3. 多切片协同交付时，先创建 1 个 Parent Issue 描述整体商业与架构闭环，随后依次创建各并行切片 Sub-issue（按受限并发边界分组）与 1 个位于末尾的跨上下文整体验收 Sub-issue，并通过 GitHub 原生子工单接口将其全部挂载至 Parent Issue 下。

## 工单模板

Parent Issue:

```markdown
# <需求交付名称>

<1-3 句话概括本次交付覆盖的业务链路与整体完成定义>

## 上下文与契约

- 领域上下文：<context-map.md 与相关 context.md 路径>
- 契约基线：<contracts/ 与 migrations/ 坐标>
```

垂直切片 Sub-issue：

```markdown
# <业务动作与领域对象名称>

<1-3 句话描述业务规则与异常拒止边界>

## 指向坐标

- 接口与端口契约：<contracts/ 或切片 command.rs / query.rs 路径>
- 迁移与共享领域：<migrations/*.sql 与 domain/ 相关类型路径>
- 切片目录：<crates/contexts/<ctx>/slices/src/<slice>/>

## 验收场景

- <tests/acceptance/<slice>.rs :: scenario_fn_1>
- <tests/acceptance/<slice>.rs :: scenario_fn_2>
```

末尾整体验收 Sub-issue：

```markdown
# <Parent Issue 名称> 端到端整体验收

<1-2 句话说明激活跨上下文集成旅程测试、导出 OpenAPI 契约与释放版本的合龙目标>

## 验收与合龙坐标

- 端到端旅程测试：<crates/e2e-journeys/tests/acceptance/*.rs>
- 契约导出：<contracts/openapi.json>
```
