# Skill 编写规范

## Skill 结构

```text
skill-name/
|-- SKILL.md
|   |-- YAML frontmatter     # name、description 和调用策略
|   `-- Markdown body        # 正文
|-- agents/                  # UI 元信息与调用策略
|   `-- openai.yaml          # OpenAI
|-- scripts/                 # 可选，可执行脚本
|-- references/              # 可选，按需查看的文档
`-- assets/                  # 可选，直接输出资产文件
```

## SKILL.md

Skill 信息分三个阶段披露：

1. `name` 与 `description`：常驻上下文，供 Agent 判断是否调用。
2. Skill 正文：被调用时加载。
3. 支撑资源：按需读取或执行。

- 正文省去一级标题与触发说明，将所有触发条件收拢在 `description`，写成 `<动作或描述>；当 <触发场景> 时必须使用`。
- `description` 中的触发词应当精准且无同义重复；若存在误触场景，优先调整触发词，仅在仍需兜底时追加 `若是 <排除场景> 则无需使用`。

### 渐进式披露

`SKILL.md` 遵循 YAGNI 原则，确保加载的都是本次任务所需内容；若存在非必要内容，应当拆分以避免分散注意力：

- 当 Skill 呈阶段执行且内容或周期较长时，将分支拆分，`SKILL.md` 编排执行顺序，以避免抢跑。
- 当 Skill 为多模式执行时，将模式拆分，`SKILL.md` 做路由，以避免上下文污染。

有两种拆分策略：

- 当内容绑定当前 Skill 时，拆分至 `references/` 就近放置。
- 当内容具备独立执行场景时，拆分至独立 Skill；`references/` 内部也可引用其他 Skill。

> [!TIP]
> 引用其他资源时：文档使用 Markdown 相对链接；脚本使用相对路径命令并附用法示例；Skill 使用 `skill-name` Skill 格式引用。

## Scripts

- 当相同逻辑需要重复编写，或确定性执行能够显著提高可靠性时，编写脚本供 Agent 复用。
- 引用脚本时，在 `SKILL.md` 中写明调用方式；当参数或子命令较多时，应当引导 Agent 使用 `--help` 获取用法。
- 严禁 Agent 阅读脚本源码，应当直接按调用说明或 `--help` 输出执行，仅当需要修改逻辑时读取。

## 元信息与调用策略

`SKILL.md` 的 YAML frontmatter 与 `agents/openai.yaml` 皆可关闭 Agent 调用，默认均启用；为保持兼容性，两者配置必须保持一致。

当 Skill 不应由 Agent 根据语义主动触发时，禁用 Agent 调用仅允许用户触发，配置如下：

```yaml
# SKILL.md
disable-model-invocation: true

# agents/openai.yaml
policy:
  allow_implicit_invocation: false
```

- 当禁用 Agent 调用时，上下文将隐藏该 Skill 信息，且不可被其他 Skill 引用（若存在其他 Skill 的引用，必须删除）；当从禁用转为开启时，删除上述配置字段以保持缺省。

### openai.yaml

仅作 UI 元信息，不注入上下文，按以下规则配置：

```yaml
interface:
  display_name: <Skill 英文名称首字母大写，例如 domain-modeling 写作 Domain Modeling>
  short_description: <短描述>
```
