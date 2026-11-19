# 技术文档编写规范

技术文档面向工程师、协作者或用户，核心目标是降低理解成本，用最短路径传递准确、可复现的工程事实。

## 通用规范

默认采用中文编写，行文遵循 Google Developer Documentation Style Guide，文档体系分类遵循 Diátaxis 框架，并在此基线上补充：

- 专业术语按中文行业共识强度择一使用中文或英文，保持上下文统一并避免双语并列，仅在生僻缩写首次出现时说明含义。
- 当需要可视化呈现时，优先使用 Mermaid；若节点标签包含圆括号或方括号等特殊字符，必须加引号以防渲染崩溃。

## 体裁标准映射

当撰写具体工程文档时，优先遵循对应仓库内置模板，不存在时自行对应行业标准编写，以下是其中一部分标准：

- `README.md`：遵循 Standard Readme Specification。
- `CONTRIBUTING.md`：遵循 GitHub Contributing Guidelines 与 Conventional Commits。
- `SECURITY.md`：遵循 GitHub Standard Security Policy。
- API：遵循 OpenAPI Specification 编写或生成 JSON。
- RFC：遵循 Google Design Doc。
- 故障复盘：遵循 Google SRE Blameless Postmortem。
- 外部 Issue：遵循目标项目的 `ISSUE_TEMPLATE`，保持同行对话的平实口吻与拟人化，发布前必须呈现给用户确认。
- 外部 PR：遵循目标项目的 `pull_request_template.md`，保持简洁，发布前必须呈现给用户确认。
