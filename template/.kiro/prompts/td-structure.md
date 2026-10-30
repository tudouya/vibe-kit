---
description: Establish or refine .kiro/steering/structure.md — the directory/placement conventions code should follow. Establishing the convention always comes first; auditing current layout against it is an optional, on-demand step.
---

## Role

Your task is to establish or refine `.kiro/steering/structure.md`.
Do not generate any other file.
Do not rewrite `structure.md` from scratch.
Output language: match the language of the existing `structure.md`; if none exists, follow the PRD's language; if neither exists, use Chinese.
Converse with me in Chinese, whatever language the output file is in.

## Input

$ARGUMENTS

The line above is what I typed after the command: optionally an intent word (`establish` / `audit`), optionally a path to a PRD or legacy reference, optionally a note on what triggered this run.

- Intent: if I named one, use it. Otherwise infer it from the project's state, and state what you chose and why before Phase 1:
  - `structure.md` is missing or only a template placeholder → `establish`
  - `structure.md` has real content but there is no code yet → `establish`
  - `structure.md` has real content and code exists → `audit`
- If I pointed at a PRD or legacy reference, read it. If I named none, do not go looking for one.
- Treat any note as a hint, not an instruction that overrides this prompt.

## The one job that always comes first

`structure.md` records the **convention** — how code *should* be organized from now on: directory responsibilities, dependency direction, import boundaries, where new code goes. This is a planning decision, not a description of the current layout. Describing what currently exists is `codebase-facts`'s job, not this file's.

This matters most for messy legacy projects: the current directories may be disorganized. Your job is **not** to copy that mess in — it is to **establish a clean convention**, which may deliberately differ from what the code looks like today, and then let the old layout migrate toward it over time. Do not legitimize an inconsistency by recording it as the rule.

Two intents:

- **establish** (no `structure.md` yet, or no code yet) — pin down the convention that *should* hold. Source: my decisions, plus a PRD if provided. Does **not** require code, does **not** require `docs/codebase-facts.md`, and **never** blocks waiting for them. If code exists, read the current layout for **reference** — but what you read is material to be regularized, not truth to copy. If `docs/codebase-facts.md` exists, read it rather than re-deriving the layout.
- **audit** (`structure.md` and code both exist, or I ask for it) — check the existing convention against the current layout: has new code drifted from the rules, is anything in `structure.md` stale? This is the only intent that requires the codebase baseline.

Establishing the convention is never gated on code. Auditing applies once a convention exists and there is code to check it against — inferred from the project's state, or because I asked.

## When current layout breaks the convention

Whether establishing or auditing, when some existing directory/placement does not match the convention, sort it into exactly one of three:

1. **Intentional difference** — it is actually fine → fold it into the convention.
2. **Historical violation, to be migrated** — it is wrong and should move to the convention over time → do **NOT** record it in `structure.md` as a rule. Hand the migration to the tech-debt workflow (`/td-tech-debt`), which owns the "what's wrong, where it should go, when" list.
3. **Unsure** — can't tell if intentional or accidental → ask me.

Handing off to tech debt means: in your reply, give me a ready-to-paste entry draft (in the ledger format of `docs/tech-debt.md` if it exists; number it `TD-NNN` — `/td-tech-debt` assigns the real number) and tell me to run `/td-tech-debt register`. **Never write `docs/tech-debt.md` yourself**, even if I agree the item is debt — the tech-debt workflow owns that file and its confirmation gate.

### Pointer, not a counter-examples list

`structure.md` holds the convention only. It must NOT carry a list of bad directories as counter-examples — that list belongs in `docs/tech-debt.md`, and a list inside a resident steering file would drift as migration proceeds and dilute the rules. The one allowed concession: a **single-sentence pointer** appended to the relevant rule, e.g. "put shared utilities in `core/`; the legacy `lib/` and `utils/` are pending migration — see `docs/tech-debt.md`". Rules for the pointer:
- one sentence, inline on the rule it guards — never a standalone "counter-examples" section
- it only says "there is legacy here + see tech-debt"; it does not enumerate the files or the migration plan
- delete the pointer once the migration is done (an audit-mode cleanup)

## Goal

Use the existing `structure.md` structure to add, update, or correct only the structural facts and placement rules that materially improve agent decisions about where code belongs and how modules should be organized.

## Legacy reference

If a legacy reference is provided, clarify:
- whether the new project is a rewrite, migration, replacement, or partial inheritance
- which module boundaries, dependency directions, or placement rules must be preserved
- which historical structure choices are intentionally discarded

Authority order, highest first: **what I confirm now > current code layout > current steering > legacy behavior.** Do not treat legacy as automatic truth.

## Context Collection

What to read depends on the intent:

**establish:**
- A provided PRD, if any.
- Existing `.kiro/steering/structure.md`, `product.md`, `tech.md`, `AGENTS.md`.
- If code exists: the first two levels of the repo structure, workspace markers, and app entrypoints — for reference, as material to regularize. Do not require `docs/codebase-facts.md`; do not block if it is missing.
- If `docs/codebase-facts.md` exists, read it. Any claim about what the code currently looks like must come from it or from a file/directory you actually opened — never from a grep hit list alone.
- In `product.md`, read the phase plan and the 待明确区域 section. An upcoming phase that will need structure the project does not have yet (a new service, an outward-facing interface, a new storage layer, etc.) is a Fog candidate: the structural decision waits on that phase being committed.

**audit:**
- `docs/codebase-facts.md` — **required**; the verified module structure and entry points to check the convention against. If it does not exist, STOP and tell me to run `/td-codebase-facts` first.
- Existing `.kiro/steering/structure.md`, `product.md`, `tech.md`, `AGENTS.md`.
- Package files (`package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`), key config (`Dockerfile`, `docker-compose.yml`, `tsconfig.json`, `next.config.*`), repo structure.
- Any claim about what the code currently looks like must come from `docs/codebase-facts.md` or a file/directory you actually opened — never from a grep hit list alone.
- In `product.md`, read the phase plan and the 待明确区域 section. An upcoming phase that will need structure the project does not have yet (a new service, an outward-facing interface, a new storage layer, etc.) is a Fog candidate: the structural decision waits on that phase being committed.

For monorepos: identify the target workspace first, then stay inside it.

If `.kiro/steering/structure.md` does not exist on a project that clearly has code, STOP and say the steering skeleton is missing.

## What `structure.md` Should Cover

Use the existing four sections only, plus an optional fifth that appears only when needed:
- `目录结构`
- `组织原则`
- `命名约定`
- `新增代码指引`
- `待明确区域` (optional, last) — Fog items: structural decisions not yet made. It opens with the line "以下尚未决定，不是约束。" and each item names the upstream decision it waits on. When I decide an item, move it into the section it belongs to and delete it here; when the section is empty, delete the heading.

Prioritize these high-impact structural areas:
- stable top-level and module-level directory responsibilities
- dependency direction and import boundaries between layers or modules
- public module boundaries vs internal implementation boundaries
- project-specific naming rules that affect placement or organization
- executable guidance for where to place new code
- when to reuse an existing module vs create a new module or top-level directory

## Hard Rules

- Default to incremental improvement, not regeneration.
- Preserve correct existing content whenever possible.
- Surface conflicts explicitly before editing.
- Do not silently change existing structural rules that affect downstream work.
- If a missing structural rule is actually blocked by unresolved product or technical ambiguity, surface it as a question instead of encoding an assumption into `structure.md`.
- Do not write product scope, runtime limitations, API schema details, or testing strategy into `structure.md`.
- If a detail belongs more naturally in `product.md`, `tech.md`, `api-standards.md`, or `testing.md`, leave it out of `structure.md`.
- Do not turn `structure.md` into a full architecture document or implementation plan.

## Phase 1 — Audit

Read the context and output exactly these sections:

1. Confirmed Structural Facts
- only facts directly supported by my decisions, the repo layout, docs, or config
- cite the source of each (my decision, directory path, codebase-facts entry, config file)
- a fact traceable to neither my decision nor a source is not confirmed — downgrade to "Additions Needed" to verify

2. Additions Needed
- directory responsibilities, organization rules, naming rules, or placement guidance that should be added to `structure.md`

3. Outdated Items to Update
- existing `structure.md` entries that appear stale, misleading, incomplete, or inconsistent with the current repo

4. Fog — structural decisions not yet determinable
- structural decisions that depend on unresolved product-level or technical decisions (e.g. mono-repo vs multi-repo not yet decided, microservice boundaries unclear)
- each item states: what upstream decision must land before this can be confirmed
- these are proposed for the `待明确区域` section only — never written into the four convention sections

5. Conflicts or Questions
- conflicts between current repo layout, existing steering, legacy reference, and my current intent
- when the repo layout conflicts with stale documentation, the layout is the stronger signal about *what currently exists* — but whether that is the right convention is still my call
- **structural inconsistencies**: when the same responsibility has multiple placement locations (e.g. `lib/` vs `utils/`), present as the three-way choice — intentional difference / historical violation to migrate / unsure — do not assume an answer. For a migration, give a tech-debt draft as described above.
- ask at most 5 focused questions per round

If no additions, updates, conflicts, or questions are needed, state that the current `structure.md` is sufficient and stop.

### Gate

Stop after the audit.
Do not modify `structure.md` until I answer the questions or explicitly confirm how to proceed.

Answering my questions does not approve anything else. Before writing, list every entry you will add, change, or remove — with its exact wording and target section — and wait for my explicit yes. Silence or "no objection" is not approval; anything I did not approve stays out of the file.

## Phase 2 — Write

After I confirm, update `.kiro/steering/structure.md` with the smallest viable edits.

Read the existing `.kiro/steering/structure.md` first. Preserve its front-matter (e.g. `inclusion:`) and its four-section structure (目录结构 / 组织原则 / 命名约定 / 新增代码指引), plus 待明确区域 if present. If the file does not exist yet, create it from the template skeleton with those four sections.

**The written file must contain no HTML comments (`<!-- -->`)** — steering is injected verbatim into agent context, so comments only waste it. Remove any skeleton guidance comments when writing. Anything you would want to note in a comment goes in your report to me instead.

**Markers**: keep the line `steering-id: ST-0f53` directly under the file's H1 title, byte-for-byte; if it is missing, add it there (it lets me verify the file was loaded). Every bullet in these sections starts with a rule ID: `组织原则` → `O`, `命名约定` → `N` — e.g. `- [O1] ...`. Keep existing IDs unchanged; a new rule takes the next unused number in its section; IDs of removed rules are never reused; never renumber. Bullets in other sections get no ID.

Editing rules:
- keep the existing four-section structure; add 待明确区域 at the end only when there are Fog items
- Fog items go into 待明确区域 on the approved list like any other entry; any existing item I have now decided moves to its proper section
- add only high-signal entries
- update stale items in place when possible
- remove or replace misleading content only when the conflict is confirmed
- keep wording concise and operational
- preserve useful existing subsections or grouped steps when they already improve readability
- place new entries into an existing subsection when they clearly belong there
- create a new subsection only when multiple related entries justify it or when an important category is otherwise hard to scan
- do not create unnecessary subsection sprawl for one-off items

Section intent:
- `目录结构`: a tree of the directories or files that materially affect placement decisions, each with a brief responsibility label; generated directories, vendor directories, and build output usually need not be expanded. Examples (illustrative only):
  ```
  src/
  ├── app/          # routes (pages and layouts)
  ├── features/     # feature modules split by business domain
  ├── components/   # UI components shared across modules
  ├── lib/          # general utilities and config
  └── db/           # database schema and connection

  src/
  ├── auth/         # auth module (router/schemas/models/service)
  ├── users/        # users module
  ├── core/         # global config, DB connection, shared dependencies
  └── main.py       # app entrypoint

  cmd/              # entry commands
  internal/         # private business logic (not exposed)
  pkg/              # reusable public packages
  ```
- `组织原则`: dependency direction (which layers/modules may depend on which), import boundaries, the public entry modules interact through vs internals that must not be imported directly, and when a new top-level directory is allowed vs reusing an existing module — no technology-choice rationale, business rules, or API fields. Examples (illustrative only): "import across `features/` only via each feature's `index.ts` public API — no deep imports"; "business components go in `features/`, shared ones in `components/`"; "cross-module access only via `from src.<module> import` public API — never import internal functions"; "packages under `internal/` must not be imported by external projects"
- `命名约定`: only project-specific naming rules that affect organization or placement — do not restate the language's general style guide. Examples (illustrative only): "component files PascalCase (`TermCard.tsx`), utility functions camelCase"; "module directories snake_case, classes PascalCase, functions snake_case"; "DB tables plural snake_case (`users`, `order_items`)"; "exported functions PascalCase, private functions camelCase"
- `新增代码指引`: minimal executable steps for adding files or modules in the correct place, steering toward reusing the existing module structure first; if no existing location fits, state when a new top-level directory is allowed and when the agent must pause and confirm. Examples (illustrative only): "1. create `components/`, `actions/`, `schemas/`, `index.ts` under `src/features/<name>/` 2. export public API only via `index.ts` 3. for a DB change, update `src/db/schema.ts` first, then run the migration"; "1. create `router.py`, `schemas.py`, `models.py`, `service.py` under `src/<module>/` 2. register the router in `main.py` 3. for a DB change, run `alembic revision --autogenerate`"

## Final Check

Before finishing, verify:
- no product, runtime, or API design detail was incorrectly pulled into `structure.md`
- no confirmed structural rule was silently changed
- additions, updates, and removals trace to either my decision or a cited source
- every claim about the current layout traces to `docs/codebase-facts.md` or a file/directory I actually opened
- every entry written was on the list I explicitly approved
- a historical violation went to tech debt, not into `structure.md` as a rule — as a draft in my reply, with no write to `docs/tech-debt.md`
- any legacy pointer is a single inline sentence, not a counter-examples section
- fog items are in 待明确区域 only, each naming its upstream decision — none written into the four convention sections
- `structure.md` contains no HTML comments (`<!-- -->`)
- `steering-id: ST-0f53` is present under the title; every bullet in the ID-bearing sections has a unique rule ID; no existing ID was changed or reused
- the file remains concise and useful to an agent deciding where code belongs
