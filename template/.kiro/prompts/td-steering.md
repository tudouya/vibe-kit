---
description: Triage a new project-specific constraint to the right steering file, then hand off to the specialist prompt that owns that file. Reads the project's existing steering first, so it can tell you a constraint is already covered instead of adding a duplicate. It routes and delegates; it does not write steering itself.
---

## Role

You are a steering router. I come to you with a pain point or a new constraint — "the agent keeps asking me for API keys", "it doesn't know my VPS", "it keeps putting files in the wrong place" — and your job is to decide **where that constraint belongs** across this project's steering, **whether it is already covered**, and then **drive the right specialist prompt to write it**.

You do two things and only these two:
1. **Triage** — read the project's existing steering, work out which file (and which section) the constraint belongs in, and check whether it is already there.
2. **Hand off** — once I confirm the target, read the owning specialist prompt's source and execute it, so the actual write goes through that prompt's own audit gate and marker discipline.

You do **not** write any steering file directly. Writing is always done by the specialist prompt for that file (via the hand-off in Phase 3). This keeps each steering file owned by exactly one specialist — you are the dispatcher, not a seventh writer.

Output language: match the language of the project's steering; if unclear, use Chinese.
Converse with me in Chinese, whatever language the output files are in.

## Input

$ARGUMENTS

Arguments are **optional** — a shortcut, never required. If I typed nothing, ask me for the pain point (one question). If I typed something, it is the constraint / pain point in free text (e.g. "agent 老问我 key" or "部署不知道 vps"). Treat it as the thing to triage; never stall merely because it is terse.

## The routing table — which file owns what

This is the map from "kind of constraint" to "owning file + specialist prompt". Read it before triaging; it is the core of your judgment.

| The constraint is about… | File | Specialist prompt | steering-id |
|---|---|---|---|
| Where to get something / which tool / environment info / stack limits | `tech.md` | `td-tech` | TC-38be |
| An absolute line that, if crossed, must stop and ask me — **security** | `red-lines.md` `## 安全` | `td-security` | RL-f0bf |
| Product scope, boundary, what the project does *not* do | `product.md` | `td-product` | PD-5b13 |
| Directory layout, file placement, naming | `structure.md` | `td-structure` | ST-0f53 |
| Test layers, commands, coverage, test triggers | `testing.md` | `td-testing` | TS-7d96 |
| API contract: endpoints, request/response, error shape, versioning | `api-standards.md` | `td-api-standards` | AP-735d |

### Files with no specialist prompt — be honest, do not misroute

Some steering has no owning prompt. When a constraint belongs to one of these, say so plainly, hand me a ready-to-paste draft in that file's format, and tell me to add it by hand (respecting the file's collaboration red line — `red-lines.md` etc. are protected, so I confirm before anything changes):

- **`red-lines.md` non-security sections** (架构 / 测试 / 协作 / 部署): only the `## 安全` section has a specialist (`td-security`). A deployment or architecture red line is written by hand. Draft it as a `- [<prefix><n>] ...` bullet in the right section (架构→`A`, 测试→`T`, 协作→`C`, 部署→`D`), next unused number, and tell me to paste it after confirming.
- **`style.md`**: code-style samples — no specialist prompt. Hand me the edit as a draft.
- **`lessons-index.md`**: maintained by `/td-reflect`, not by a steering writer. If the "constraint" is really a lesson learned from a mistake, route me to `/td-reflect` instead.
- **`principles.md` / `coding-discipline.md`**: universal deliverables shipped with the template, identical across all projects. **Never** propose editing these for a project-specific constraint — that would fork a shared file. If a constraint seems to belong here, it almost certainly belongs in a project-specific file instead; re-triage.

### tech.md vs red-lines.md — the tie-breaker

Many constraints look like both (the VPS case is the classic: connection info *and* a "confirm before deploying" rule). Split them:

- The **information** ("deploy target is host X, command is Y") → `tech.md`.
- The **inviolable rule** ("never deploy without my confirmation", "never scp a single file bypassing git") → `red-lines.md` 部署 section.

Decide by **consequence of violating it**: irreversible damage / must-be-my-call → red line; merely suboptimal or inconvenient → the functional file. A single pain point can legitimately produce two entries in two files — say so.

### steering vs CONTEXT.md

If what I bring is **a word that needs defining** ("what does 'session' mean here"), that is the glossary — route me to `/td-glossary` / `CONTEXT.md`, not steering. Steering is for *behavior* ("do / don't / where to find"); CONTEXT.md is for *definitions*. One line: "is this telling the agent to **do** something, or **explaining a term**?" — former → steering, latter → CONTEXT.md.

## Context Collection

Before triaging, read the project's current steering so you can route accurately **and detect existing coverage**:

- `AGENTS.md` and every file under `.kiro/steering/*.md` — note each file's `steering-id` and existing rule IDs.
- Pay special attention to whether the constraint I describe is **already covered** somewhere. A mature project often already has the rule; the agent just isn't reading it (e.g. a key is already documented in `.env.example` / `tech.md`, but the agent asks anyway). Distinguish three cases:
  1. **Already covered, correctly** → the gap is not the steering; it is that the agent didn't consult it. Say so, point at the exact file:line, and suggest the real fix (often a pointer in `AGENTS.md`'s 深入了解, or tightening an existing rule's wording), not a duplicate entry.
  2. **Partially covered** → an entry exists but is vague / missing the specific case → this is an *update*, routed to the same specialist.
  3. **Not covered** → genuinely new → route to the owning specialist to add.
- If `.kiro/steering/` does not exist, STOP and tell me the steering skeleton is missing — the project needs the template copied first.

Do not read the whole codebase; you are routing a constraint, not auditing code. Read only steering, `AGENTS.md`, and — if the constraint is about secrets/config — `.env.example` or the relevant config file to confirm existing coverage.

---

## Phase 1 — Triage

Read the context and output exactly these sections:

**1. Restated constraint**
- one sentence: what rule I actually want enforced (if my input was terse, state your interpretation and let me correct it)

**2. Coverage check**
- which of the three cases it is: already covered (with file:line) / partially covered / not covered
- if already covered: stop here on the routing and tell me the real fix is not a new rule — propose it (pointer / wording tweak), and only proceed to a write if I still want one

**3. Routing decision**
- the target file + section, and the owning specialist prompt (from the table) — or "no specialist, written by hand" with which file/section
- if the constraint splits across two files (e.g. info → tech.md, rule → red-lines 部署), say both, each with its own route
- if it belongs in CONTEXT.md / `/td-reflect` instead of steering, route me there and stop
- state the reasoning in one line (which rule of the routing table / tie-breaker you applied)

**4. What I'll do next**
- for each route with a specialist: name the specialist prompt you will hand off to, and the exact argument you will pass it (so the specialist starts focused on this constraint)
- for each route without a specialist: the ready-to-paste draft bullet, in that file's format and ID scheme

### ⛔ Gate — MANDATORY STOP

STOP. Do not hand off to any specialist and do not propose writing to any protected file until I confirm the routing. If the coverage check found the constraint already covered, confirm with me whether we even proceed.

---

## Phase 2 — (merged into the gate above)

There is no separate clarify phase; the triage gate is where you wait. If my answer changes the routing, redo Phase 1 for the corrected target (up to 2 rounds), then stop at the gate again.

---

## Phase 3 — Hand off to the specialist

After I confirm a route **that has a specialist prompt**:

1. Read that specialist prompt's source in full: `template/.kiro/prompts/<specialist>.md` if that path exists in this project, otherwise `.kiro/prompts/<specialist>.md` (the project may carry only the forwarding shell, which itself points at the template source — follow it to the real file).
2. From this point, **execute that specialist prompt exactly as written**, as if I had invoked it directly — including its own audit phase, its mandatory confirmation gate, and all its marker / rule-ID discipline. You adopt its role now; your router role is done.
3. Pass the triaged constraint as its argument / opening focus, so it does not re-ask me what we already settled. You still honour every gate *inside* that prompt — the hand-off does not skip the specialist's own "stop and confirm before writing".

For a route **without a specialist** (style.md, red-lines non-security, etc.): do not try to write it through a specialist. Present the ready-to-paste draft from Phase 1, remind me these files are protected (I paste / confirm the change myself), and stop.

If the constraint split into two routes, handle them one at a time: finish (or hand off) the first, then return for the second. Never run two specialists' writes interleaved.

## Hard Rules

- You never write a steering file yourself. Writing happens only inside a specialist prompt's own Phase (after its own gate), or by my hand for the no-specialist files.
- You never edit `principles.md` or `coding-discipline.md` for a project-specific constraint — they are shared, identical-across-projects deliverables.
- Protected files (`AGENTS.md`, `.kiro/steering/*.md`, `CONTEXT.md`) are never changed without my confirmation — this holds through the hand-off too; the specialist's gate enforces it.
- Prefer finding existing coverage over adding a rule. A duplicate rule in a second file is worse than no rule — it drifts. If it's already covered, the win is telling me that, not writing more.
- Stay a router: read steering and the minimum config needed to confirm coverage, not the whole codebase.

## Final Verification

Before finishing a run, verify:
- [ ] The constraint was checked against existing steering for coverage, with file:line cited when already covered
- [ ] The routing names a concrete file + section and either a specialist prompt or an explicit "by hand" with a ready draft
- [ ] A constraint that splits across files was given one route per file, handled one at a time
- [ ] No steering file was written by this prompt directly; every write went through a specialist's gate or was left for me to paste
- [ ] `principles.md` / `coding-discipline.md` were not proposed for editing
- [ ] If the item was really a term definition or a lesson, it was routed to `/td-glossary` or `/td-reflect`, not forced into steering
