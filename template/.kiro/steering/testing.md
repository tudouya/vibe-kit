# 测试策略与覆盖要求

steering-id: TS-7d96

## 测试分层

| 类型 | 状态 | 工具 | 覆盖范围 |
|------|------|------|----------|
| 单元测试 | {{STATUS}} | {{TOOL}} | {{SCOPE}} |
| 集成测试 | {{STATUS}} | {{TOOL}} | {{SCOPE}} |
| 端到端测试 | {{STATUS}} | {{TOOL}} | {{SCOPE}} |
| 契约测试 | {{STATUS}} | {{TOOL}} | {{SCOPE}} |
| 回归测试 | {{STATUS}} | {{TOOL}} | {{SCOPE}} |
| 快照测试 | {{STATUS}} | {{TOOL}} | {{SCOPE}} |
| characterization 测试 | {{STATUS}} | {{TOOL}} | {{SCOPE}} |
| 性能测试 | {{STATUS}} | {{TOOL}} | {{SCOPE}} |
| 安全测试 | {{STATUS}} | {{TOOL}} | {{SCOPE}} |
| 可访问性测试 | {{STATUS}} | {{TOOL}} | {{SCOPE}} |

## 关键配置（影响测试写法的约定）
- [K1] {{TEST_CONFIG_1}}
- [K2] {{TEST_CONFIG_2}}

## 覆盖率目标（数值，非描述）
{{COVERAGE_TARGETS}}

## 何时必须补测试（什么改动 → 补什么测试）
- [W1] {{TEST_TRIGGER_1}}
- [W2] {{TEST_TRIGGER_2}}
- [W3] {{TEST_TRIGGER_3}}

## Mock 策略（外部依赖的替代方式）
- [M1] {{MOCK_1}}
- [M2] {{MOCK_2}}

## 测试命令
- 运行全部：`{{TEST_COMMAND}}`
- 运行单个：`{{TEST_SINGLE_COMMAND}}`
