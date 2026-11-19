---
name: writing
description: 写作手册；当需要编写技术文档、Agent 规则（如 AGENTS.md、SKILL.md）、subAgent Prompt 或对外发布文字时必须使用。
---

不同写作任务的读者与目标完全不同：给 Agent 看的规则追求边界清晰、执行准确，给工程师看的文档追求高信噪比与可复现性，给大众看的传播文案则追求真实感与可读性。

- 当需要编写 Agent 规则（如 `SYSTEM.md`、`AGENTS.md`）时，遵循 [agents-rules.md](./references/agents-rules.md)；若编写 `SKILL.md` 及其参考文档，必须额外遵循 [skill-rules.md](./references/skill-rules.md)；若编写 subAgent Prompt，必须额外遵循 [subAgent-prompt.md](./references/subAgent-prompt.md)。
- 当需要编写技术文档、技术博客或向外部项目提交 Issue/PR 时，遵循 [tech-docs.md](./references/tech-docs.md)。
- 当需要在社交平台发帖、评论，或撰写产品宣发、公共传播文案时，按照平台受众选择策略，核心是拟人化，发布前必须呈现给用户确认。

当写作任务不属于以上类别时，无需读取参考文件，自行根据对应领域风格或方法论呈现内容；若内容较长，先示例一小段，待用户确认后再继续。

> [!TIP]
> 用户仓库几乎全部接入了 `mise(hk)` 格式化工具链，提交代码时会自动格式化文档，无需手动处理，仅当发生错误时再排查；严禁阅读工具链代码，应当直接依赖自动化校验与报错信息，仅当需要修改配置时读取。
> 当项目未接入工具链或文档不在仓库内时，必须执行 `./scripts/format-doc.sh <file>...` 格式化文档；严禁阅读脚本源码，应当直接调用脚本完成格式化，仅当需要修改逻辑时读取。
