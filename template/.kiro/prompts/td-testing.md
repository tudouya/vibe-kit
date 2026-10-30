---
description: Establish or refine .kiro/steering/testing.md — the testing standard the project follows. Establishing the standard always comes first; auditing current tests against it is an optional, on-demand step.
---

## Role

Your task is to establish or refine `.kiro/steering/testing.md`.
Do not generate any other file.
Do not rewrite `testing.md` from scratch.
Output language: match the language of the existing `testing.md`; if none exists, follow the PRD's language; if neither exists, use Chinese.
Converse with me in Chinese, whatever language the output file is in.

## Input

$ARGUMENTS

The line above is what I typed after the command: optionally an intent word (`establish` / `audit`), optionally a path to a PRD or legacy reference, optionally a note on what triggered this run.

- Intent: if I named one, use it. Otherwise infer it from the project's state, and state what you chose and why before Phase 1:
  - `testing.md` is missing or only a template placeholder → `establish`
  - `testing.md` has real content but there are no tests/code yet → `establish`
  - `testing.md` has real content and tests/code exist → `audit`
- If I pointed at a PRD or legacy reference, read it. If I named none, do not go looking for one.
- Treat any note as a hint, not an instruction that overrides this prompt.

## The one job that always comes first

`testing.md` records the **testing standard** — what to test, how to test it, and which shortcuts are unsafe, *from now on*. This is a decision about how the project should be tested, not a description of whatever tests happen to exist today. Existing tests inform what has been tried; I decide what becomes the standard.

For a project with messy or partial tests: do not legitimize every historical testing pattern by recording it as the rule. Extract the clean standard; let the current tests migrate toward it.

Two intents:

- **establish** (no `testing.md` yet, or no tests/code yet) — pin down the testing standard that *should* hold. Source: my decisions, plus a PRD if provided. Does **not** require code, does **not** require `docs/codebase-facts.md`, and **never** blocks waiting for them. If tests/code exist, read them for reference — as material informing the standard, not truth to copy. If `docs/codebase-facts.md` exists, read it rather than re-deriving what the tests/code use.
- **audit** (`testing.md` and tests/code both exist, or I ask for it) — check the existing standard against the current tests/config: has anything drifted, is anything in `testing.md` stale? This is the only intent that requires the codebase baseline.

Establishing the standard is never gated on code. Auditing applies once a standard exists and there are tests/code to check it against — inferred from the project's state, or because I asked.

A current test practice that is wrong and planned to be replaced is tech debt, not a standard. Hand it to the tech-debt workflow: in your reply, give me a ready-to-paste entry draft (in the ledger format of `docs/tech-debt.md` if it exists; number it `TD-NNN` — `/td-tech-debt` assigns the real number) and tell me to run `/td-tech-debt register`. **Never write `docs/tech-debt.md` yourself**, even if I agree the item is debt — the tech-debt workflow owns that file and its confirmation gate.

## Goal

Use the existing `testing.md` structure to add, update, or correct only the testing rules and baseline conventions that materially improve agent decisions about what to test, how to test it, and which testing shortcuts are unsafe in this project.

## Legacy reference

If a legacy reference is provided, clarify:
- whether the new project is a rewrite, migration, replacement, or partial inheritance
- which testing layers, baseline fixtures, mock patterns, or coverage expectations must be preserved
- which historical testing choices are intentionally discarded

Authority order, highest first: **what I confirm now > current test code/config > current steering > legacy behavior.**

## Context Collection

What to read depends on the intent:

**establish:**
- A provided PRD, if any.
- Existing `.kiro/steering/testing.md`, `product.md`, `tech.md`, `AGENTS.md`.
- If tests/code exist: test config and the `tests/` tree, for reference. Do not require `docs/codebase-facts.md`; do not block if it is missing.
- If `docs/codebase-facts.md` exists, read it. Any claim about what the tests/code currently do must come from it or from a file you actually opened — never from a grep hit list alone.
- In `product.md`, read the phase plan and the 待明确区域 section. An upcoming phase that will need testing the project does not do yet (a new storage layer, an outward-facing interface, etc.) is a Fog candidate: the testing decision waits on that phase being committed.

**audit:**
- `docs/codebase-facts.md` — **required**; the verified tech stack, data stores, and external dependencies that determine isolation strategy. If it does not exist, STOP and tell me to run `/td-codebase-facts` first.
- Existing `.kiro/steering/testing.md`, `product.md`, `tech.md`, `AGENTS.md`.
- package files (`package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`)
- test config (`pytest.ini`, `pyproject.toml`, `vitest.config.*`, `playwright.config.*`, `jest.config.*`)
- fixtures and shared setup (`tests/conftest.py`, `tests/fixtures/*`, `vitest.setup.*`, `playwright/`, `cypress/`)
- the main `tests/` directory or equivalent
- CI files (`.github/workflows/*`, `Makefile`)
- Any claim about what the tests/code currently do must come from `docs/codebase-facts.md` or a file you actually opened — never from a grep hit list alone.
- In `product.md`, read the phase plan and the 待明确区域 section. An upcoming phase that will need testing the project does not do yet (a new storage layer, an outward-facing interface, etc.) is a Fog candidate: the testing decision waits on that phase being committed.

For monorepos: identify the target workspace first, then stay inside it.

If `.kiro/steering/testing.md` does not exist on a project that clearly has tests or code, STOP and say the steering skeleton is missing.

## What `testing.md` Should Cover

Use the existing sections only, plus an optional last section that appears only when needed:
- `测试分层`
- `关键配置`
- `覆盖率目标`
- `何时必须补测试`
- `Mock 策略`
- `测试命令`
- `待明确区域` (optional, last) — Fog items: testing decisions not yet made. It opens with the line "以下尚未决定，不是约束。" and each item names the upstream decision it waits on. When I decide an item, move it into the section it belongs to and delete it here; when the section is empty, delete the heading.

### Mandatory Test Type Coverage

`测试分层` must address each of these ten types (one row each in the skeleton table). **Every type requires my explicit ruling** — "not used" is a valid answer, but it must be a decision I confirmed, never a silent omission:

- unit tests
- integration tests
- E2E tests
- regression tests (how to prevent fixed bugs from recurring)
- contract tests (API consumer/provider)
- snapshot tests (UI components)
- performance/load tests
- characterization tests (locking existing behavior before refactoring)
- security tests (SAST / DAST / dependency scanning — beyond the rules in `red-lines.md` `## 安全`)
- accessibility tests (UI only)

To lower my burden without deciding for me: first make an **applicability prediction** for each type, based on the project's objective characteristics read from `tech.md` / `codebase-facts` — e.g. presence of UI components → snapshot; presence of an external API contract → contract; presence of performance/load requirements → performance; presence of a user-facing UI → accessibility; and so on.

- For a type predicted **applicable**: ask normally — scope, tooling, isolation strategy.
- For a type predicted **not applicable**: still ask, but compress it to a single line stating your prediction and its project-specific reason, defaulting to "skip", so I can confirm or overturn with one word. For example: "snapshot tests: no UI components found, predicted not applicable — skip? (y/n)".

Never skip asking about a type just because you predicted it inapplicable. The prediction lowers my effort; it does not make the decision. State predictions as predictions, never as settled conclusions.

### High-Impact Areas

Prioritize these high-impact testing areas:
- the actual test pyramid used by the project
- baseline test client or runner conventions
- async testing assumptions and lifecycle/lifespan handling where relevant
- database, queue, cache, or external-service test isolation strategy
- dependency override or fixture strategy
- high-signal triggers for when tests must be added or updated
- realistic coverage expectations for the project's critical logic
- approved mock or fake patterns, and disallowed shortcuts that make tests misleading

## Hard Rules

- Default to incremental improvement, not regeneration.
- Preserve correct existing content whenever possible.
- Surface conflicts explicitly before editing.
- Do not silently change existing testing rules that affect downstream work.
- If a missing testing rule is actually blocked by unresolved product or technical ambiguity, surface it as a question instead of encoding an assumption into `testing.md`.
- Do not write product scope, business rules, API resource design, directory structure rules, or implementation plans into `testing.md`.
- If a detail belongs more naturally in `product.md`, `tech.md`, `structure.md`, or `api-standards.md`, leave it out of `testing.md`.
- Do not turn `testing.md` into a generic testing tutorial or a framework cookbook.

## Phase 1 — Audit

Read the context and output exactly these sections:

1. Confirmed Testing Facts
- only facts directly supported by my decisions, code, config, docs, CI, or explicit statements
- cite the source of each (my decision, config file, test directory, CI workflow)
- a fact traceable to neither my decision nor a source is not confirmed — downgrade to "Additions Needed" to verify

2. Additions Needed
- testing layers, baseline conventions, triggers, mock rules, or commands that should be added to `testing.md`

3. Outdated Items to Update
- existing `testing.md` entries that appear stale, misleading, incomplete, or inconsistent with the current project

4. Fog — testing decisions not yet determinable
- testing decisions that depend on unresolved technical or product decisions (e.g. DB isolation strategy cannot be defined until the ORM is chosen; E2E scope depends on service boundaries not yet determined)
- each item states: what upstream decision must land before this can be confirmed
- these are proposed for the `待明确区域` section only — never written into the standard sections

5. Conflicts or Questions
- conflicts between current tests/config, existing steering, legacy reference, and my current intent
- when current test code/config conflicts with stale documentation, the code/config is the stronger signal about *what is currently done* — but whether that is the right standard is still my call
- for each of the ten test types: present your applicability prediction per the rules above and get my ruling
- ask at most 5 focused questions per round

If no additions, updates, conflicts, or questions are needed, state that the current `testing.md` is sufficient and stop.

### Gate

Stop after the audit.
Do not modify `testing.md` until I answer the questions or explicitly confirm how to proceed.

Answering my questions does not approve anything else. Before writing, list every entry you will add, change, or remove — with its exact wording and target section — and wait for my explicit yes. Silence or "no objection" is not approval; anything I did not approve stays out of the file.

If high-impact testing gaps remain unresolved after one round, continue clarifying instead of editing. In particular, do not write `testing.md` yet if the project still lacks clear answers on any of these:
- the intended test layering
- the baseline async/sync test model
- database or external dependency isolation strategy
- required test triggers for core changes
- coverage expectations for critical logic

## Phase 2 — Write

After I confirm, update `.kiro/steering/testing.md` with the smallest viable edits.

Read the existing `.kiro/steering/testing.md` first. **Preserve its front-matter exactly** — including `inclusion:` and, if present, `fileMatchPattern` and its full pattern list. Overwriting the front-matter would break how this file is loaded. Preserve its section structure (测试分层 / 关键配置 / 覆盖率目标 / 何时必须补测试 / Mock 策略 / 测试命令), plus 待明确区域 if present. If the file does not exist yet, create it from the template skeleton with those sections. Adding or removing 待明确区域 never touches the front-matter.

**The written file must contain no HTML comments (`<!-- -->`)** — steering is injected verbatim into agent context, so comments only waste it. Remove any skeleton guidance comments when writing. Anything you would want to note in a comment goes in your report to me instead.

**Markers**: keep the line `steering-id: TS-7d96` directly under the file's H1 title, byte-for-byte; if it is missing, add it there (it lets me verify the file was loaded). Every bullet in these sections starts with a rule ID: `关键配置` → `K`, `何时必须补测试` → `W`, `Mock 策略` → `M` — e.g. `- [K1] ...`. Keep existing IDs unchanged; a new rule takes the next unused number in its section; IDs of removed rules are never reused; never renumber. Bullets in other sections get no ID.

Editing rules:
- keep the existing section structure; add 待明确区域 at the end only when there are Fog items
- Fog items go into 待明确区域 on the approved list like any other entry; any existing item I have now decided moves to its proper section
- add only high-signal entries
- update stale items in place when possible
- remove or replace misleading content only when the conflict is confirmed
- keep wording concise and operational
- preserve useful existing subsections or grouped bullets when they already improve readability
- place new entries into an existing subsection when they clearly belong there
- create a new subsection only when multiple related entries justify it or when an important category is otherwise hard to scan
- do not create unnecessary subsection sprawl for one-off items

Section intent:
- `测试分层`: the actual testing layers used in this project, with scope for each layer; the 状态 column takes exactly one of 适用 / 不适用（原因） / 待定
- `关键配置`: baseline fixtures, client setup, runner/config defaults, lifecycle handling, and isolation rules that agents commonly guess wrong. Examples (illustrative only): "async API project: use `httpx.AsyncClient` + `ASGITransport`; add `LifespanManager` if lifespan events are relied on"; "pytest: `testpaths = ['tests']`; pure-asyncio projects may set `asyncio_mode = 'auto'`"; "database: roll back a transaction per test, or use an in-memory test DB"; "DI: replace external dependencies via the framework's dependency-override mechanism"
- `覆盖率目标`: realistic quality bars for the parts of the system that matter most
- `何时必须补测试`: concrete change triggers that require new or updated tests, written as "change → test to add". Examples (illustrative only): "new/changed Server Action → integration test"; "changed Zod schema → unit tests (at least one valid, one invalid)"; "changed SEO output → E2E assertion"; "new API endpoint → integration tests (success + validation failure + permission)"; "changed DB model → unit tests covering the new fields"
- `Mock 策略`: approved patterns for replacing external dependencies so tests never depend on real services, without making tests misleading. Examples (illustrative only): "database: mock the `env.DB` interface so drizzle calls can be intercepted"; "cache revalidation: mock `revalidatePath` and assert its arguments"; "external APIs: use `httpx.MockTransport` or the `responses` library"
- `测试命令`: the commands agents should actually run

## Final Check

Before finishing, verify:
- no product, API design, or directory-structure detail was incorrectly pulled into `testing.md`
- no confirmed testing rule was silently changed
- additions, updates, and removals trace to either my decision or a cited source
- every claim about current tests/code traces to `docs/codebase-facts.md` or a file I actually opened
- every entry written was on the list I explicitly approved
- all ten mandatory test types were explicitly ruled on (used, or confirmed "not used") — none silently skipped
- fog items are in 待明确区域 only, each naming its upstream decision — none written into the standard sections
- any practice ruled "to be replaced" went to tech debt as a draft in my reply, with no write to `docs/tech-debt.md`
- the existing file's front-matter (including any fileMatch pattern list) is preserved intact
- `testing.md` contains no HTML comments (`<!-- -->`)
- `steering-id: TS-7d96` is present under the title; every bullet in the ID-bearing sections has a unique rule ID; no existing ID was changed or reused
- the file remains concise and useful to an agent deciding what tests to add or run
