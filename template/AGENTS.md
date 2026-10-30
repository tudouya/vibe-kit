# {{PROJECT_NAME}}

steering-id: AG-f438

## 项目
{{PROJECT_DESCRIPTION}}
当前重点：{{CURRENT_FOCUS}}
决策优先级：1) {{PRIORITY_1}}  2) {{PRIORITY_2}}  3) {{PRIORITY_3}}

## 命令
- 运行：`{{RUN_COMMAND}}`
- 测试：`{{TEST_COMMAND}}`
- 检查：`{{LINT_COMMAND}}`
- 类型检查：`{{TYPECHECK_COMMAND}}`
- 构建：`{{BUILD_COMMAND}}`
- 部署：`{{DEPLOY_COMMAND}}`
- 迁移：`{{MIGRATE_COMMAND}}`

改完代码后，运行 `{{LINT_COMMAND}}` 和 `{{TEST_COMMAND}}` 验证通过后再报告完成。
{{MANIFEST_POINTER}}

## 规模红线
- [Z1] 单个函数体不超过 {{MAX_FUNCTION_LINES}} 行（不含类型定义和签名）
- [Z2] 单个文件不超过 {{MAX_FILE_LINES}} 行；超过时按职责拆分
- [Z3] 条件/循环嵌套不超过 3 层；超过时提取为独立函数

## 深入了解
- {{TRIGGER_1}} → {{DOC_1}}（{{DOC_1_CONTENT}}）
- 遇到领域术语或命名含义不清时 → `CONTEXT.md`（项目术语表，领域词的权威定义）

## 决策协议
- [P1] 架构变更 / 新增依赖 / 数据模型变更：给出方案对比 + 推荐，等确认后执行
- [P2] 局部实现细节：直接执行，关键取舍写行内注释说明理由
- [P3] 需求存在多种合理解读：给 3 个选项 + 推荐理由，等确认
- [P4] 信息缺失（接口是否存在、字段含义不明）：先在代码中确认事实，确认不了时问

## 沟通准则
严格遵守格赖斯会话准则（量/质/关系/方式）：信息充分不冗余、有据不臆测、紧扣问题、清晰无歧义。

## 回复标记
每次回复的最后一行，列出本轮实际依据的规则：`〔文件ID:规则ID · …〕`。
- 文件 ID 是各 steering 标题下 `steering-id:` 的值；规则 ID 是条目或小标题开头方括号里的编号（如 `[C1]`、`[P02]`），lessons 用 `L0XX`。
- 格式示例（编号是假的，不要照抄）：`〔XX-0000:A1 · YY-1111:P02〕`。本轮没有依据任何规则，写 `〔无〕`。
- 只写真正影响了本轮做法的规则，不罗列看到的全部。
