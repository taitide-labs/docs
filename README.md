# docs

Taitide 工程研发方法论与正交 AI 代理技能库。

## 技能体系

整套研发流程收敛为五枚职责正交、按需单跳加载的独立技能：

```mermaid
flowchart LR
  G["grilling：设计树前沿追问"] -. "面临多方案权衡按需唤醒" .-> D["design：软件设计唯一入口"]
  D -->|"冻结契约与工单后"| I["implement：隔离工作树分型交付"]
  I -->|"独立验收或发版巡检"| V["verify：对抗验证与审查摘要"]
  V -->|"抓出共性坏味道"| R["guardrail：静态防线与全仓清扫"]
```

| 技能 | 核心职责 | 单跳参考指南 |
| :--- | :--- | :--- |
| [grilling](skills/grilling/SKILL.md) | 设计树前沿追问、方案推荐与越界阻断 | — |
| [design](skills/design/SKILL.md) | 战略建模、契约设计、交互设计、战术冻结、工单拆解与横切 ADR 唯一总入口 | [战略设计](skills/design/references/strategic-design.md)、[契约设计](skills/design/references/contract-design.md)、[客户端设计](skills/design/references/client-design.md)、[命令行设计](skills/design/references/cli-design.md)、[战术冻结](skills/design/references/tactical-design.md)、[任务拆解](skills/design/references/task-slicing.md) |
| [implement](skills/implement/SKILL.md) | 隔离工作树内对照冻结基线交付后端切片、客户端切片或端到端合龙 | [后端切片](skills/implement/references/backend-slice.md)、[客户端切片](skills/implement/references/client-slice.md)、[端到端合龙](skills/implement/references/e2e-cutover.md) |
| [verify](skills/verify/SKILL.md) | 角色分离对抗验证、防投机核查、语义对齐与沙漏下口审查摘要生成 | — |
| [guardrail](skills/guardrail/SKILL.md) | 按信任倒金字塔将评审缺陷转化为类型、Clippy 与 `ast-grep` 防线 | — |

## 安装与校验

通过 `skills` CLI 一键安装至本机代理目录，或直接软链至 `~/.agents/skills/`：

```sh
bunx skills add taitide-labs/docs
```

本地提交前运行全套文档规范、Mermaid 渲染、离线死链、拼写与工作流安全校验：

```sh
mise install
mise run check
```

## 贡献与安全

请参阅 [贡献指南](CONTRIBUTING.md) 与 [安全政策](SECURITY.md)。

## 许可证

[MIT](LICENSE) © 2026 Taitide Labs
