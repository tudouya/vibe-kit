---
description: Establish or refine .kiro/steering/api-standards.md — the API contract guardrails. Zero-argument friendly: it asks whether the project even has an outward-facing API, and exits cleanly if not.
---

## Role

Your task is to establish or refine `.kiro/steering/api-standards.md`.
Do not generate any other file.
Do not rewrite `api-standards.md` from scratch.
Output language: match the language of the existing `api-standards.md`; if none exists, follow the PRD's language; if neither exists, use Chinese.
Converse with me in Chinese, whatever language the output file is in.

## Input

$ARGUMENTS

Arguments are entirely **optional** — a shortcut, never a requirement. If I typed nothing, drive the whole thing by asking (see Opening). If I did type something, it may be: an intent word (`establish` / `audit`), an API paradigm, a PRD/legacy path, or a free-text note. Use whatever I gave to skip the matching question; ask for the rest. Never stall or exit merely because an argument is missing.

## Opening — does this project even have an API?

`api-standards.md` is **optional steering**: only projects with an outward-facing interface need it. A pure CLI, scraper, batch job, or library does not. So before anything else, settle this — unless my arguments already answered it:

> Does this project expose an outward-facing API?
> - **No** (pure CLI / scraper / batch job / library) → I will not create `api-standards.md`. I stop here, writing and changing nothing.
> - **Yes, or I want to start planning one now** → which paradigm? REST / RPC / GraphQL / event-driven (MQ · webhook) / mixed.

Rules for this gate:
- **"No" exits cleanly and leaves no trace.** Do not write `api-standards.md`, do not write any "this project has no API" marker anywhere. The exit is just "nothing to do this time."
- This judgment is about **right now**, re-made every run. A project that has no API today may add one later; when that happens, running this prompt again will see the API and proceed normally. Nothing about today's exit blocks that.
- Establishing an API contract is a planning action — I can run this to design the contract **before** the endpoints exist. "Yes, planning one now" is a full-fledged path, not a special case.

## The two intents (once there is, or will be, an API)

- **establish** (no `api-standards.md` yet, or no endpoints yet) — pin down the API contract that *should* hold. Source: my decisions, plus a PRD if provided. Does **not** require code or `docs/codebase-facts.md`; never blocks on them. If endpoints exist, read them for reference. If `docs/codebase-facts.md` exists, read it rather than re-deriving what the code exposes.
- **audit** (`api-standards.md` and endpoints both exist, or I ask for it) — check the existing contract against current routes/schemas. This is the only intent that requires the codebase baseline.

If I did not name an intent, infer it from the project's state, and state what you chose and why before Phase 1:
- `api-standards.md` is missing or only a template placeholder → `establish`
- `api-standards.md` has real content but there are no endpoints yet → `establish`
- `api-standards.md` has real content and endpoints exist → `audit`

## Goal

Use the existing `api-standards.md` structure to add, update, or correct only the API contract rules and consistency guardrails that materially improve agent decisions when creating or modifying endpoints.

## API Paradigm

Never assume REST. The confirmed paradigm (from the Opening) governs which rules apply. The rest of this workflow adapts to it; do not ask REST questions of an event-driven project, etc.

## Current patterns are "what is", not "what should be"

When endpoints already exist, sort each dominant pattern into one of three — do not legitimize a pattern just because it is there:
1. **Consistent and reasonable** → extract as a rule.
2. **Consistent but unreasonable** → ask me: define a new standard (old becomes tech-debt via `/td-tech-debt`), or accept temporarily (mark "known issue, to improve").
3. **Inconsistent across the codebase** → ask me: pick one as the going-forward standard (rest becomes tech-debt), or define an entirely new one (all old becomes tech-debt).

Code is the stronger signal about *what is currently done*, not about *what should be the standard* — that is my call.

Whenever something "becomes tech-debt" here, hand it to the tech-debt workflow: in your reply, give me a ready-to-paste entry draft (in the ledger format of `docs/tech-debt.md` if it exists; number it `TD-NNN` — `/td-tech-debt` assigns the real number) and tell me to run `/td-tech-debt register`. **Never write `docs/tech-debt.md` yourself**, even if I agree the item is debt — the tech-debt workflow owns that file and its confirmation gate.

## Legacy reference

If a legacy reference is provided, clarify: relationship (rewrite / migration / partial inheritance); which API conventions, error formats, versioning, or compatibility expectations must be preserved; which historical choices are intentionally discarded.
Authority order, highest first: **what I confirm now > current code/config > current steering > legacy behavior.**

## Context Collection

What to read depends on the intent:

**establish:**
- A provided PRD, if any.
- Existing `.kiro/steering/api-standards.md`, `product.md`, `tech.md`, `AGENTS.md`.
- If endpoints exist: route/controller files, request/response schemas, exception handlers, auth middleware — for reference. Do not require `docs/codebase-facts.md`; do not block if missing.
- If `docs/codebase-facts.md` exists, read it. Any claim about what the code currently exposes must come from it or from a file you actually opened — never from a grep hit list alone.
- In `product.md`, read the phase plan and the 待明确区域 section. An upcoming phase that will add or change an outward-facing interface is a Fog candidate: the contract decision waits on that phase being committed.

**audit:**
- `docs/codebase-facts.md` — **required**; verified API entry points, frameworks, external dependencies. If it does not exist, STOP and tell me to run `/td-codebase-facts` first.
- Existing `.kiro/steering/api-standards.md`, `product.md`, `tech.md`, `AGENTS.md`.
- route/controller files, schemas, exception handlers, auth middleware, framework config, app entrypoints, API tests, OpenAPI setup.
- package files (`package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`).
- Any claim about what the code currently exposes must come from `docs/codebase-facts.md` or a file you actually opened — never from a grep hit list alone.
- In `product.md`, read the phase plan and the 待明确区域 section. An upcoming phase that will add or change an outward-facing interface is a Fog candidate: the contract decision waits on that phase being committed.

For monorepos: identify the target workspace first, then stay inside it.

If `.kiro/steering/api-standards.md` does not exist on a project that clearly has an API, STOP and say the steering skeleton is missing.

## What `api-standards.md` Should Cover

Preserve its role as a contract guardrail file, not an endpoint catalog. Which areas apply depends on the confirmed paradigm:

**REST:** endpoint naming & resource/action conventions · HTTP method & status code usage · request/response consistency · error response structure & status semantics · pagination, idempotency, auth, versioning.
**RPC (gRPC / tRPC / Thrift):** service/method naming · proto/schema design (field numbering, backward compat) · error code semantics & propagation · streaming conventions · versioning & deprecation.
**GraphQL:** query/mutation/subscription separation · naming for types/fields/operations · error handling (unions vs exceptions) · pagination (Relay cursor vs offset) · schema evolution & deprecation.
**Event-driven (MQ / Webhook):** topic/queue naming · message envelope structure · idempotency & dedup · retry & dead-letter policy · payload schema versioning.
**Cross-paradigm (always):** auth/authorization boundary · framework-specific contract pitfalls agents get wrong · backward compatibility rules.

## Hard Rules

- Default to incremental improvement, not regeneration.
- Preserve correct existing content whenever possible.
- Surface conflicts explicitly before editing.
- Do not silently change existing API contract rules that affect downstream work.
- If a missing API rule is actually blocked by unresolved product or technical ambiguity, surface it as a question instead of encoding an assumption.
- Do not turn `api-standards.md` into a route inventory, implementation guide, or framework tutorial.
- Do not write product scope, business rules, directory structure rules, or testing strategy into it; route those to `product.md`, `tech.md`, `structure.md`, or `testing.md`.

## Phase 1 — Audit

Read the context and output exactly these sections:

1. Confirmed API Contract Facts
- only facts supported by my decisions, code, schemas, docs, or tests — each cited (route file, schema, config, my decision)
- a fact traceable to neither my decision nor a source is not confirmed — downgrade to "Additions Needed" to verify

2. Additions Needed
- contract rules, consistency guardrails, or framework-specific constraints to add

3. Outdated Items to Update
- existing entries that appear stale, misleading, incomplete, or inconsistent with the current project

4. Fog — API decisions not yet determinable
- API decisions that depend on unresolved product/technical decisions (e.g. versioning cannot be defined until public-vs-internal boundary is confirmed)
- each states what upstream decision must land first
- proposed for the `待明确区域` section only — never written into the contract sections

5. Conflicts or Questions
- conflicts between current routes/schemas/error handling, existing steering, legacy, and my current intent
- apply the three-way sort for inconsistent / unreasonable patterns; items I choose not to fix now get a tech-debt draft (see above)
- ask at most 5 focused questions per round

If nothing needs adding, updating, or resolving, say the current `api-standards.md` is sufficient and stop.

### Gate

Stop after the audit. Do not modify `api-standards.md` until I answer the questions or confirm how to proceed.

Answering my questions does not approve anything else. Before writing, list every entry you will add, change, or remove — with its exact wording and target section — and wait for my explicit yes. Silence or "no objection" is not approval; anything I did not approve stays out of the file.

Do not write yet if the project still lacks clear answers on: resource-vs-action modeling for core endpoints · sync-vs-async interaction model where it affects endpoint shape · the canonical error response structure · auth boundary and public/private behavior · versioning strategy. (Apply only the ones relevant to the confirmed paradigm.)

## Phase 2 — Write

After I confirm, update `.kiro/steering/api-standards.md` with the smallest viable edits.

Read the existing file first. Preserve its front-matter (e.g. `inclusion:`) and its section structure (API 范式 / 端点/操作约定 / 请求与响应格式 / 错误处理 / 分页 / 认证与授权 / 版本策略 / 幂等性 / 新增端点/操作检查清单), plus 待明确区域 if present. Sections confirmed inapplicable (e.g. 分页, 幂等性) should be deleted entirely rather than left empty. If the file does not exist yet (a "yes, planning one now" path), create it from the template skeleton.

`待明确区域` (optional, last) holds Fog items: contract decisions not yet made. It opens with the line "以下尚未决定，不是约束。" and each item names the upstream decision it waits on. When I decide an item, move it into the section it belongs to and delete it here; when the section is empty, delete the heading.

Editing rules:
- the written file contains no HTML comments (`<!-- -->`): it is injected verbatim, so remove every skeleton guidance comment when writing, and never add new ones
- **Markers**: keep the line `steering-id: AP-735d` directly under the file's H1 title, byte-for-byte; if it is missing, add it there (it lets me verify the file was loaded). Every bullet in these sections starts with a rule ID: `端点/操作约定` → `E`, `请求与响应格式` → `F`, `错误处理` → `R`, `分页` → `P`, `认证与授权` → `U`, `版本策略` → `V`, `幂等性` → `I` — e.g. `- [E1] ...`. Keep existing IDs unchanged; a new rule takes the next unused number in its section; IDs of removed rules are never reused; never renumber. Bullets in other sections get no ID.
- keep the existing overall structure unless a confirmed gap requires a small additive section; add 待明确区域 at the end only when there are Fog items
- Fog items go into 待明确区域 on the approved list like any other entry; any existing item I have now decided moves to its proper section
- add only high-signal entries; update stale items in place
- remove or replace misleading content only when the conflict is confirmed
- keep wording concise and operational
- preserve useful existing examples only when they materially clarify contract rules
- do not add endpoint-specific examples unless they represent a stable project-wide pattern

Section intent:
- `API 范式` records the confirmed paradigm, naming the concrete flavor (examples: `REST`, `GraphQL`, `tRPC`, `gRPC`, or mixed such as `REST + WebSocket`)
- naming/endpoint rules describe reusable conventions, not a catalog of current routes
- status code and error rules define contract semantics, not framework internals
- response and pagination rules define stable response-shape expectations
- framework-specific notes only cover pitfalls that materially affect contract consistency
- the new-endpoint checklist holds generic checks to confirm whenever any new endpoint/operation is added, adapted to the paradigm — not per-endpoint items

## Final Check

Before finishing, verify:
- no product scope, directory rule, or testing strategy detail leaked in
- no confirmed API contract rule was silently changed
- additions/updates/removals trace to either my decision or a cited source
- every claim about current routes/schemas traces to `docs/codebase-facts.md` or a file I actually opened
- every entry written was on the list I explicitly approved
- fog items are in 待明确区域 only, each naming its upstream decision — none written into the contract sections
- inconsistencies and unreasonable patterns were resolved by my decision, not silently legitimized
- patterns I chose not to fix now went to tech debt as a draft in my reply, with no write to `docs/tech-debt.md`
- the file remains concise and useful to an agent designing or editing endpoints
- the file contains no HTML comments (`<!-- -->`); all skeleton guidance comments were removed
- `steering-id: AP-735d` is present under the title; every bullet in the ID-bearing sections has a unique rule ID; no existing ID was changed or reused
