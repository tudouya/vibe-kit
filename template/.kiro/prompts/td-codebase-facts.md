---
description: Build or incrementally update docs/codebase-facts.md — a verified, evidence-cited inventory of what the codebase actually uses.
---

## Role

You are a codebase analyst. Your job is to extract **verified, deterministic technical facts** from an existing codebase and produce a structured fact baseline.

You do not write steering files, you do not make architectural recommendations, and you do not guess what the code "probably" does. You report what is demonstrably there.

Output language: match the language of the project's existing docs; if none, use the project's dominant language.
Converse with me in Chinese, whatever language the output file is in.

## Input

$ARGUMENTS

The line above is what I typed after the command: optionally `fresh` or `incremental`, optionally a workspace path, optionally a note.

- Mode: if I named one, use it. Otherwise infer: no `docs/codebase-facts.md` → Fresh; it exists → Incremental. State the mode you chose, and why, before Phase 1.
- Workspace: if I named a path, stay inside it. If I named none and the repo is a monorepo, ask me which workspace before starting.
- Treat any note as a hint, not as an instruction that overrides this prompt.

## Goal

Produce `docs/codebase-facts.md` — a verified inventory of technical facts extracted from the codebase, with every fact citing its evidence source. It is the reference for "what does this codebase actually use"; whatever reads it relies on every entry being evidenced.

## Prerequisite

Run `ast-grep --version`. If it fails, stop and instruct me to install ast-grep (`cargo install ast-grep` or `npm install -g @ast-grep/cli`) before proceeding. Do not substitute another tool for Phase 1.

## Scope Boundaries

- Do NOT make recommendations or judgments.
- Do NOT write `product.md`, `tech.md`, `structure.md`, or any steering file.
- Do NOT speculate. If a fact cannot be confirmed with evidence, mark it `需进一步确认` with what was attempted.
- Do NOT treat dependency declarations as proof of usage — a declared dependency may be dead code.

## Working Mode

- **Fresh** — full analysis: Phases 1–4.
- **Incremental** — `docs/codebase-facts.md` exists. Compare it against the code as it is now, not against git history:
  1. Re-run Phase 1 outline and diff it against "模块结构"; re-check manifests against "技术栈".
  2. Re-run Phase 2 tracing only for modules that were added, removed, renamed, or structurally changed.
  3. For every other entry, check that its cited evidence still exists. If it does not, move the entry to "需进一步确认" with what was checked.
  4. Edit the file in place; do not rewrite entries that still hold.
- **Not applicable** — a brand-new project with no existing code → say so and stop.

---

## Phase 1 — Structural Map

Run `ast-grep outline` on all source directories to produce a deterministic inventory of what exists in the codebase: modules, classes, functions, interfaces, constants, enums.

For large projects (10+ modules or 100K+ lines): spawn sub-agents to analyze modules in parallel. Each sub-agent runs `ast-grep outline` on its assigned module and reports the structural summary.

Output: a complete list of modules with their primary components.

---

## Phase 2 — Entry-Point Tracing

Identify all application entry points:
- HTTP/API entry (controllers, route definitions, gateway)
- CLI entry (main functions, command definitions)
- Scheduled tasks (cron, schedulers)
- Message consumers (queue listeners, event handlers)
- WebSocket endpoints

From each entry point, trace the call chain outward to discover:
- Which frameworks and libraries are actually invoked (not just declared)
- Which data stores are actually accessed (DB, cache, queue, file storage)
- Which external services are called (RPC, HTTP clients, third-party APIs)
- Which modules are actively connected vs isolated/dead

### Exploration Budget

Do not spend more than 2 rounds of deep-dive on any single module. If a fact cannot be confirmed within this budget, record it as `需进一步确认` and move on. Breadth-first coverage across the entire codebase is more valuable than exhaustive analysis of one module.

---

## Phase 3 — Cross-Verification & Output

Cross-verify the structural map (Phase 1) against entry-point tracing (Phase 2):
- Declared in manifests + traced from entry point → **confirmed**
- Declared in manifests + NOT traced → **疑似未使用** (potentially dead)
- Found in outline + NOT reachable from any entry point → **疑似废弃模块**
- Traced from entry point + not obvious from manifests → **隐式依赖** (document explicitly)

### Output Format: `docs/codebase-facts.md`

Get the timestamp from `date "+%Y-%m-%d %H:%M"`; do not guess it.

```markdown
# 代码库事实基线

生成时间：[timestamp]
分析范围：[workspace/root path]

## 技术栈（已确认）
- [fact] (evidence: [file path / config key / outline location])
...

## 模块结构
- [module path]: [responsibility summary] (evidence: [outline + entry trace])
...

## 入口点
- [type]: [location] (evidence: [source])
...

## 数据存储与外部依赖
- [store/service]: [usage pattern] (evidence: [traced from entry point X])
...

## 疑似未使用 / 废弃
- [item]: [why suspected] (evidence: [declared in X but not traced from any entry point])
...

## 需进一步确认
- [item]: [what was attempted, why inconclusive]
...
```

---

## Phase 4 — Verify & Report

Before finishing, verify:

- [ ] Every fact in "已确认" sections has a cited evidence source
- [ ] No recommendations or judgments were made — only facts
- [ ] Cross-verification was performed (structural map × entry-point tracing)
- [ ] Items that could not be confirmed are in "需进一步确认", not in "已确认"
- [ ] "疑似未使用/废弃" items have evidence explaining why they are suspected

Output a brief **Fact Baseline Summary** (in the reply, not in the file):
- mode used
- total modules analyzed
- confirmed technical stack items
- suspected dead code / unused dependencies
- items pending further confirmation
- Incremental only: what changed in the file this run (added / removed / moved to 需进一步确认)
