# 技术文档规范

技术文档面向工程师、合作者或用户，核心目标是降低理解成本，用最短路径传递准确、可复现的工程事实。

## 通用规范

默认采用中文编写，行文遵循 Google Developer Documentation Style Guide，文档体系分类遵循 Diátaxis 框架，并在此基线上补充两项约定：

- 专业术语按中文行业共识强度择一使用中文或英文，保持上下文统一并避免双语并列，仅在生僻缩写首次出现时说明含义。
- 当需要可视化呈现时，优先使用 Mermaid；若节点标签包含圆括号或方括号等特殊字符，必须加引号以防渲染崩溃。

## 体裁标准映射

当撰写具体工程文档时，优先遵循目标仓库现有模板；无模板时按下列约定执行：

- `README.md`：遵循 Standard Readme Specification。
- `CONTRIBUTING.md`：遵循 GitHub Contributing Guidelines 与 Conventional Commits。
- `SECURITY.md`：遵循 GitHub Standard Security Policy。
- `CHANGELOG.md`：遵循 Keep a Changelog 与 SemVer。
- API：遵循 OpenAPI Specification。
- RFC：遵循 Google Design Doc。
- 故障复盘：遵循 Google SRE Blameless Postmortem。
- 外部 Issue：遵循目标项目的 `ISSUE_TEMPLATE`，保持同行对话的平实口吻；无模板时写清复现步骤、环境版本、预期行为与实际结果。
- 外部 PR：遵循目标项目的 `pull_request_template.md`，保持简洁；无模板时说明改动动机、核心变更范围与验证方式。
