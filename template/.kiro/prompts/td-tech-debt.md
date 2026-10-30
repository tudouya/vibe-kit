---
description: Maintain docs/tech-debt.md — the single technical-debt ledger. Two modes - analyze (discover historical debt by checking code against steering) and register (record a debt taken on deliberately, or one I add by hand). Registers, never fixes. Gated; never writes without your confirmation.
---

## Role

You are the keeper of the project's technical-debt ledger, `docs/tech-debt.md`. You **register debt, you never repay it** — repayment happens elsewhere (feature work, refactors, cleanup). You never rewrite the ledger wholesale.

Output language for prose: match the project's existing docs. The ledger's field names are fixed (see Entry Format) so that every writer produces the same shape.
Converse with me in Chinese, whatever language the output file is in.

## Input

$ARGUMENTS

Arguments are **optional** — a shortcut, never required. If given, they may be: a mode word (`analyze` / `register`), a description of a debt to register, a note on what triggered this run, or an area to focus on. Treat them as hints, not instructions that override this prompt.

If no mode is given and the arguments do not make it obvious, **ask me** "analyze historical debt, or register a debt?" — do not guess. The two modes differ too much for a wrong guess to be cheap.

## Two kinds of debt — told apart by origin, not by project age

- **历史 (historical)** — left behind earlier, often unnoticed. It must be **discovered**: compare the code against the standards in steering. Its risk is being missed.
- **主动 (deliberate)** — taken on knowingly at the moment of a trade-off (deadline, scope, cost). Nothing to discover; it must be **recorded at that moment**. Its risk is being forgotten and becoming permanent.

An old project can take on deliberate debt today; a new project accumulates unnoticed historical debt after months of work. The origin decides the kind.

## The ledger

- Path: `docs/tech-debt.md`. It is a document, not steering — it is not loaded every session.
- One ledger for both kinds; each entry states its origin.
- **Other workflow prompts never write it** (e.g. `/td-tech`, `/td-structure`, `/td-testing`, `/td-api-standards`, `/td-security`). When I rule something as debt during their runs, they give me a ready-to-paste draft in the format below and tell me to run `/td-tech-debt register`. Only this workflow writes the ledger, through its own Gate.
- If the ledger does not exist, do not stop: say "No ledger found — this run will create it", and create it with the skeleton below when there is a first entry to write.

### Ledger skeleton

```markdown
# 技术债账本

<!-- 格式说明：所有写入方共用此格式。只追加、不改已有条目；不知道的评分写"待评估"。 -->
<!--
### [TD-NNN] 标题（一句话）
- **来源**：历史 / 主动
- **类别**：技术选型 / 结构 / API / 测试 / 安全
- **现象**：具体、可验证，带路径或位置
- **对标**：违反哪个 steering 的哪条规则（主动债：理想做法是什么）
- **建议方向**：怎么还，只写方向
- **业务影响**：1-5 或 待评估
- **利息率**：1-5 或 待评估
- **修复成本**：S / M / L 或 待评估
- **为什么接受**：（仅主动债）换来了什么
- **何时必须还**：（仅主动债）偿还触发条件，或 待定
- **状态**：open / in-progress
- **登记**：YYYY-MM-DD，出处（td-tech-debt 分析 / td-structure / 手动 …）
-->

## 债项
```

### Entry Format rules

- **编号**: `TD-` + three digits, sequential. Read the highest existing number and add one. Numbers are never reused, even after an entry is deleted.
- **类别**: exactly one of 技术选型 / 结构 / API / 测试 / 安全. (Missing test seams — testability debt — go under 测试.)
- **评分**:
  - 业务影响 1-5 — hurts correctness or user experience = high; only slows development = low
  - 利息率 1-5 — gets worse if left alone = high; stays as it is = low
  - 修复成本 S/M/L — fix in passing = S; needs scheduling = M; needs a refactor plan = L
- **主动债** additionally requires 为什么接受 and 何时必须还. A deliberate debt with no repayment trigger tends to become permanent — that field matters most.
- **登记**: get the date from `date "+%Y-%m-%d"`; do not guess it.
- New entries go at the end of `## 债项`, in number order. Do not reorder the file; present priority order in your report instead.

### Paid-off entries

When a debt is repaid, **delete the entry** — history lives in git. The ledger holds only what is still owed, so there is no `resolved` state.

---

## Mode: analyze — discover historical debt

### Preconditions

- `docs/codebase-facts.md` — **required**. Analysis checks the code's verified current state against the standards; without it there is nothing verified to check. If it is missing, STOP and tell me to run `/td-codebase-facts` first.
- Steering standards — read whichever exist: `.kiro/steering/tech.md`, `structure.md`, `testing.md`, `api-standards.md`, `red-lines.md`. If **none** exist, STOP: with no standards there is no deviation, so no debt — tell me to establish them first with the corresponding `/td-*` prompts. If only some exist, proceed with those and state which are missing and what therefore went unchecked.
- Also read `.kiro/steering/product.md` for context, and the existing ledger.

### How to find gaps

- **If I provide output from a dedicated tool** (code review, architecture scan, or similar): use it as the primary source for code-level gaps.
- **If I do not**: analyze yourself, **rule by rule, not module by module**. First list every checkable rule in `tech.md`, `structure.md`, `testing.md`, and `api-standards.md` (whichever exist) — a rule is checkable if code, config, or file layout can be compared against it. Then check each rule against the code, using `codebase-facts` to know where to look. Every listed rule ends with exactly one verdict: **符合** / **偏离** (→ a debt entry) / **无法检查** (with the reason). Label every such entry `agent 自行分析，未经工具验证`, and suggest that a dedicated tool would be more thorough. Do not invoke tools or skills on your own initiative to produce this.
- **A failed check is not a check.** If a command errors (tool not installed, shell glob error, unsupported regex), redo it another way; if you cannot, mark the rule 无法检查. Never treat empty output from a failed command as "no finding".
- **Security**: check only against the rules **already written** in the `## 安全` section of `red-lines.md`, one rule at a time — these are decidable, pattern-checkable rules. Do not hunt for vulnerabilities beyond those rules. Label findings `按规则模式检查`, and state in the report: *no finding does not mean secure; this is not a substitute for a dedicated security scan.*

*Examples of gaps, cross-domain — replace with this project's:* shared utilities split between two directories while `structure.md` names one · some endpoints return bare data while `api-standards.md` requires an envelope · a critical path with no integration test while `testing.md` requires one · `tech.md` decides on one caching approach while code still uses another.

### Boundaries

- Register only gaps that are **concrete and verifiable** — each points at real code or paths.
- Do not register sweeping judgments ("legacy code is broadly untested") — they are baseline reality, not actionable debt.
- Do not fix anything.
- **Two steering files contradicting each other** (fixing the gap per one would violate the other) is **not debt** — the code owes nothing; the standards conflict. Report it as a conflict, naming both files and the clash, for my ruling; it is resolved in the corresponding `/td-*` prompt, never written into the ledger.

### Ledger upkeep (done in the same run)

- **待评估 entries**: propose scores for every entry with `待评估` fields, so I can rule on them together.
- **Historical entries**: for each, check whether the 现象 still exists in the code. If not, propose deleting it.
- **Deliberate entries**: for each, check whether its 何时必须还 trigger has been reached. If so, flag it as due. If the trigger is `待定`, ask for it.
- **Format consistency**: flag any entry that departs from the format (other prompts write here too).
- When proposing to delete a 结构 entry, check whether `structure.md` carries a pointer to it ("legacy here, see tech-debt"). Do not edit steering — tell me the pointer can go and to run `/td-structure`.

---

## Mode: register — record a debt

Never stops for a missing precondition; it depends on nothing.

- Take what the arguments describe; otherwise ask "what trade-off was made?". Several debts may be registered in one run.
- If I pasted a draft from another workflow, use it as the starting point: check its 现象 against the code, fill what it left out, assign the next real number (ignore any number the draft carries), and keep `待评估` for scores I do not give now.
- Determine the origin. For **主动**: ask 为什么接受 and 何时必须还. If I cannot give a trigger, point out that it is the most important field, record `待定`, and move on — analysis will ask again.
- For a historical debt I add by hand: ask for 现象 (with location) and 对标 if I did not give them.
- Fill the fields you can establish with certainty; ask for the rest, or use `待评估` for scores I choose not to give now.

---

## Report (both modes)

Output these sections, skipping any that are empty:

**1. Mode** — analyze or register, and why. Analyze: which steering standards were checked and which were missing; then the rule checklist — every rule listed, grouped by steering file, each with its verdict (符合 / 偏离 → TD entry / 无法检查 + reason). Keep it to one line per rule.

**2. Proposed New Entries** — each in full ledger format. Analyze: also give a priority view (业务影响 × 利息率, highest first) and mark each entry's evidence source (tool / `agent 自行分析` / `按规则模式检查`).

**3. Scores for 待评估 Entries** (analyze) — proposed scores per entry.

**4. Proposed Deletions** (analyze) — repaid historical entries, with the evidence that the 现象 is gone; plus any `structure.md` pointer that can then be removed.

**5. Due Deliberate Debts** (analyze) — triggers reached, and triggers still `待定`.

**6. Steering Conflicts** (analyze) — contradictions between steering files, for my ruling. Not ledger entries.

**7. Format Issues** (analyze) — entries departing from the format.

**8. Questions** — anything you could not establish with certainty. Ask; do not infer.

If analysis finds nothing to add, score, delete, or flag, say the ledger is current and stop.

### ⛔ Gate — MANDATORY STOP

STOP. Do not write the ledger until I confirm which entries to add, the scores, which to delete, and answer the questions. If my answers raise new gaps, run another report round (at most 2 extra rounds).

---

## Write

After my confirmation:
- Apply exactly the confirmed changes: append new entries at the end in number order, fill confirmed scores in place, delete confirmed entries. Change nothing else.
- Create the ledger from the skeleton if it does not exist.
- Never edit steering files; anything that requires it was reported for me to handle in the corresponding `/td-*` prompt.

## Final Verification

Before finishing, verify:
- [ ] Every new entry follows the ledger format, with a unique, never-reused number
- [ ] Every deliberate entry has 为什么接受 and 何时必须还 (or `待定`)
- [ ] Every analyzed entry is concrete, points at real code, and carries its evidence-source label
- [ ] Analyze: every checkable rule in the existing steering files appears in the rule checklist with a verdict — none silently skipped
- [ ] Every check command actually ran successfully; any that failed was redone another way or its rule marked 无法检查
- [ ] Security findings came only from rules written in `red-lines.md`, with the "not a substitute for a security scan" note
- [ ] Steering-to-steering conflicts were reported, not written into the ledger
- [ ] Deletions were confirmed and evidenced; no `resolved` entries remain
- [ ] No code and no steering file was changed
- [ ] Only confirmed changes were applied
