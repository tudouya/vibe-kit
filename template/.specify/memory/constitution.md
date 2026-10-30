# {{PROJECT_NAME}} Constitution

<!--
本文件是 spec-driven（spec-kit 等）流程在各环节会读取的项目宪章。
template 预置了一条通用纪律「规格写在决策层」；实测 `specify init` 不会覆盖已存在的本文件（会保留）。
项目可在 `## Core Principles` 下继续追加自己的原则（如语言偏好、领域硬约束），不要删掉下面这条通用纪律。
-->

## Core Principles

### I. 规格写在决策层，模糊不往下漏（NON-NEGOTIABLE）

- 规格只命名需要人拍板的**决策**，不写实现或伪代码。判据：「这是要我拍板的决策，还是实现细节？」——是实现就删，交给下游。
- 遇到「需实验、目测或跑一次才能定」的需求（数值、手感、阈值、交互、性能目标），**不硬写具体值**——先立一个定时盒 spike 任务把它试出来再回填规格；在此之前该条标为待定，不进实现。
- 每个 task 必须绑一条**可独立验证的结果**（一条能跑的检查，或一次可核验的产物）。写不出验证方式的 task，说明还没拆到位，继续拆。
- 规格里一旦出现实质歧义（`[NEEDS CLARIFICATION]` 之类、或「大概 / 合适 / 友好 / 高性能」这种无法验收的措辞），**必须先澄清或跑 checklist 把它消掉，再进入 plan / tasks / 实现**——不把模糊条目带着往下走。

> 本原则是**约束文本**，在手动逐步执行 speckit 命令时靠 agent 遵守与人把关生效；它不是引擎级门禁。若项目的 `specify workflow run` 可用，第 4 条可升级为 workflow 的 gate step 做硬拦截。

### II. 视觉决策以 design token 为准（NON-NEGOTIABLE）

本原则仅在项目含前端 UI 时适用。涉及 UI/UX 的 spec，视觉决策（颜色、字体、间距、尺寸、圆角）以 `docs/design-tokens/` 为单一真相源：

- spec 与实现只引用 `docs/design-tokens/` 里定义的 **token 名**，不自造色值/尺寸、不硬编 hex 或 px。
- 需要新视觉值，先在 token 源文件里加 token 再引用，不在 feature 里就地硬编。
- 需目测才能定的视觉参数（具体色相、比例手感），先做视觉 spike 定参再 token 化，不硬写貌似合理的值。
