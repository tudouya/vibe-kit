# vibe-kit

一套通用的 vibe coding / ADLC 工程化做法的**基线骨架**，面向各类应用项目的开发者。先建立项目真源和约束，再按任务风险选择流程重量，以可验证证据完成交付。

本仓库只放 `template/`：拷进项目后使用的 steering、`/td-*` 提示词、入口文件和账本目录。它是方法的骨架，不是完整环境——完整的方法、每个部件怎么装、各档流程怎么走，见《匠场 · Fieldcraft》手册（建设中）。

骨架之外，你还需要按手册安装 Kiro CLI、spec-kit、skills 和 ast-grep。本仓库不包含这些。

## 核心思路

- **该生效的约束沉到机制层**：项目事实与硬规则放进 Kiro 原生 steering；跨任务约束常驻，文件或情境相关内容按条件加载，能机器执行的交给 hook、lint 或 CI。
- **AGENTS.md 是入口路由，不是真源**：它只保留每次会话需要且没有被常驻 steering 重复承载的内容，并指向 steering 之外的深文档。
- **steering 先行**：先把产品、技术、结构、测试、风格、API 和红线立清楚，再进入开发流程。
- **提示词按职责拆分**：一份提示词只负责一种产物或动作。`td-` 是本套提示词的命名空间前缀。
- **流程按任务加重**：直接做、轻 spec、完整走 spec-kit 共用意图和验证底线，但产物、质量门和审查强度不同。
- **通用方法，不绑单一项目**：骨架只放对所有项目成立的内容，项目事实由各项目自己确认。

## template 布局

```text
template/
├── AGENTS.md                     ← 入口路由骨架（项目/命令/规模红线/深入了解/决策协议/回复标记）
├── CONTEXT.md                    ← 术语表骨架（由 /td-glossary 播种）
├── .kiro/
│   ├── steering/                 ← steering 基线（10 份）
│   │   ├── product.md            占位符骨架，/td-* 填
│   │   ├── tech.md
│   │   ├── structure.md
│   │   ├── testing.md
│   │   ├── style.md
│   │   ├── api-standards.md
│   │   ├── red-lines.md          红线骨架，安全段由 /td-security 填
│   │   ├── principles.md         方法论信条（通用常驻成品）
│   │   ├── coding-discipline.md  编码执行纪律（通用常驻成品）
│   │   └── lessons-index.md      踩坑索引（空骨架）
│   ├── prompts/                  ← /td-* 工作流提示词（18 个）
│   ├── hooks/                    ← 工作流 hook
│   └── tools/check-steering.sh   ← 检查 steering 标记
└── docs/                         ← 账本骨架
```

`principles.md` 和 `coding-discipline.md` 是通用成品；其余 steering 是由项目填写的骨架。每份 steering 有固定 `steering-id`，需要追踪的规则带稳定编号；`AGENTS.md` 要求 Agent 在回复末尾标出本轮实际依据的规则。

## `/td-*` 提示词一览

| 命令 | 产出 / 职责 |
|---|---|
| `/td-codebase-facts` | `docs/codebase-facts.md`：带证据的代码事实清单（接手已有项目用） |
| `/td-product` | `.kiro/steering/product.md`：产品定位、边界、不做什么 |
| `/td-tech` | `.kiro/steering/tech.md`：技术约束与关键决策 |
| `/td-structure` | `.kiro/steering/structure.md`：目录职责、依赖方向 |
| `/td-testing` | `.kiro/steering/testing.md`：测试分层、命令和测试政策 |
| `/td-api-standards` | `.kiro/steering/api-standards.md`：API 契约（无对外接口时退出） |
| `/td-security` | `.kiro/steering/red-lines.md` 的安全段：可判定、违反即 blocker 的安全硬规则 |
| `/td-glossary` | `CONTEXT.md`：术语基线（新条目标 `待确认`） |
| `/td-agents` | `AGENTS.md`：入口路由，在其他 steering 就位后收口 |
| `/td-steering` | 把一条新约束分诊到正确的 steering，先查重复，再交给对应提示词 |
| `/td-tech-debt` | `docs/tech-debt.md`：`analyze` 找历史债，`register` 登记具体债务 |
| `/td-feature-discovery` | 先判断一坨需求是单个、多个还是过于模糊；多个时切成可独立交付的纵向 feature，选中一项后进入 grill、必要的 assess 和任务分档（单个或过于模糊时不产文件） |
| `/td-handoff` · `/td-resume` | 会话交接 / 接手 |
| `/td-reflect` | 会话复盘：纠正归因、沉淀经验 |
| `/td-research` | 使用 opencli 和 GitHub CLI 调研，记录写入 `docs/research/` |
| `/td-steering-audit` | 在新会话中审计上一段会话的 steering 加载、回复标记、行为合规和机械红线；只读 |
| `/td-convert-docs` | 把办公文档、PDF 和图片转换成忠实的 Markdown，转换产物写入 `docs/` |

生成 steering 和账本的提示词通常先调查和提出改动，等你确认后再写；只读、调研和转换类提示词按各自说明执行。

## 怎么用

### 1. 获取骨架

```bash
git clone https://github.com/tudouya/vibe-kit.git
cp -R /path/to/vibe-kit/template/. /path/to/your-project/
```

目标项目已有 `AGENTS.md`、`CONTEXT.md` 或 `.kiro/` 时，不要覆盖式复制；改用 `cp -Rn` 补入缺失文件，再逐项比较合并。完整安全步骤见《匠场 · Fieldcraft》手册的项目初始化章节。

### 2. 建立项目基线

新项目依次运行 `/td-product`、`/td-tech`、`/td-structure`、`/td-testing`、`/td-api-standards`、`/td-security`、`/td-glossary`，最后用 `/td-agents` 收口入口。

接手已有项目时，先运行 `/td-codebase-facts`；之后按每份 steering 当前是占位、缺失还是已有可信内容，分别选择 establish/fresh 或 audit/revise。历史违规通过 `/td-tech-debt` 登记，不写成项目规则。

### 3. 初始化 spec-kit

```bash
specify init . --integration kiro-cli --force
specify extension add bug
specify extension add assess
```

运行前保证已有改动可恢复，运行后用 `specify extension list` 检查两个扩展。命令和完成判据见《匠场 · Fieldcraft》手册的项目初始化章节。

### 4. 处理变更任务

- 一坨需求先用 `/td-feature-discovery` 判断 single、multi 或 foggy；foggy 先做探索性 grill，multi 切成纵向 feature。
- 选定 feature 后，意图不清时用 `grill-with-docs`；是否投入尚未决定时走 `/speckit.assess.*`。
- 决定要做后，按任务分档选择直接做、轻 spec 或完整 spec-kit 流程。
- Bug 使用 `/speckit.bug.assess`、`fix`、`test`；重构先建立行为基准。
- 完成后按项目选定的 flow-forward、living spec 或 flow-back 模型维护 spec。

## 设计原则

- **短**：常驻入口不手册化。
- **分层**：每份 steering 只负责一种事实或约束。
- **增量优先**：已有内容先核对，再做最小修改。
- **真源优先**：代码、配置、当前 steering 和用户确认优先于猜测。
- **约束优先**：写可判断的规则，不写大而全百科。
- **证据驱动**：完成声明必须有直接验证结果。
- **机制优先**：能由工具稳定执行的规则，不只写成文字提醒。
