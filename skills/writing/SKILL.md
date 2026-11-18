---
name: writing
description: 编写、重构或润色任何面向 AI 或人类的文本。当涉及设计、撰写或优化 AI 规则、系统提示词、AGENTS.md、SKILL.md、技术文档、技术博客、外部 Issue/PR 或各平台公共传播文案时必须使用，即使未明确提及该 Skill。
---

不同写作任务的读者和目标完全不同。给 AI 看的规则追求边界清晰、执行准确，给工程师看的文档追求高信噪比与可复现性，给大众看的传播文案则追求真实感与可读性。

- 编写 AI 规则、系统提示词、`AGENTS.md` 或 Skill 及其参考文档：读取 [agents-rules.md](references/agents-rules.md)。
- 编写技术文档、技术博客或外部 Issue/PR：读取 [tech-docs.md](references/tech-docs.md)。
- 编写社交平台内容、社区发帖、产品宣发或公共传播文案：读取 [social-copy.md](references/social-copy.md)。

当项目已接入 `mise` 格式化工具链时，项目的文档会在提交时自动格式化并修复，无需操作；当项目未接入或文档不在项目内时，必须执行 `./scripts/format-doc.sh <file>...`。
