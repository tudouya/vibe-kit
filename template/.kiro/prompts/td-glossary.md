---
description: Build or extend CONTEXT.md — a restrained baseline glossary of the project's core domain terms, each marked 待确认 for later confirmation. Format matches the domain-modeling skill so grill-written and baseline-written terms stay consistent.
---

## Role

You are a glossary baseliner. You read the **codebase and docs** to produce a **restrained baseline** of the highest-frequency, cross-module core domain terms into `CONTEXT.md`, each marked `待确认`, so later confirmation work (via the `grill-with-docs` / `domain-modeling` skills, or by me) can sharpen them.

You do not aim for completeness, you do not write steering files, and you do not confirm terms.

Output language: match the language of the existing `CONTEXT.md`; if none, use the project's dominant language.
Converse with me in Chinese, whatever language the output file is in.

## Input

$ARGUMENTS

Arguments are **optional** — a shortcut, never required. If nothing is given, drive the run by reading context and (sparingly) asking. If given, it may be: an intent hint (`fresh` / `extend`), a note on what triggered this run, or a specific area to focus on. Treat it as a hint; never stall merely because an argument is missing.

## What CONTEXT.md is (and is not)

`CONTEXT.md` is a **glossary and nothing else** — the project's shared vocabulary, in the spirit of Domain-Driven Design's *ubiquitous language* (the same idea a Palantir-style ontology implements at industrial scale, but this is only its smallest subset: the concept layer in plain prose, with **no data binding and no executable behavior**).

Its single job is to **kill ambiguity**: when the same word means different things to different people or in different places, pin down which is which.

### Inclusion test — a term belongs only if ALL three hold

1. **It is a domain concept or domain role** — not a general technical term (VPS, JSON, thread pool), not an implementation detail or file path.
2. **It carries real ambiguity or confusability** — if left undefined, a person or agent would get it wrong: same word → different concepts (e.g. two kinds of "session"), different words → same concept, or an acronym/role whose referent is unclear.
3. **It recurs across modules / is high-frequency** — a term appearing in only one place is not baseline-worthy.

**Explicitly excluded:** general tech terms, implementation/path/config details, bare lists of codes or IDs, one-off words. (Worked examples: "counterparty system" → **in** (domain role, needs disambiguation, used throughout). "VPS" → **out** (generic infra, no ambiguity, a deployment detail). A short internal code → **in only if** not spelling it out would mislead; a plain roster of such codes → **out**.)

### Express relationships, but do not build an ontology

Within the tight definition, state the concept's relationships and boundaries where that is what resolves the ambiguity (e.g. belongs to / produces / is the opposite of / replaces; "A is not B; passing A does not imply B"). But stay a glossary: no data binding, no behaviors, no implementation. Rich implementation-level relationships go to `docs/design.md` or an ADR, not here.

## Format — follow the domain-modeling skill's CONTEXT-FORMAT.md

So that terms written by this prompt and terms written later by `grill-with-docs` / `domain-modeling` stay consistent, use **that skill's format**, not a home-grown one:

```md
# {Context Name}

{One or two sentences: what this context is and why it exists.}

## Language

**Term**:
One or two sentences. Define what it IS, not what it does.
_Avoid_: synonym1, synonym2
```

Format rules (from CONTEXT-FORMAT.md):
- **Be opinionated.** Multiple words for one concept → pick the best, list the rest under `_Avoid_`.
- **Keep definitions tight.** One or two sentences. Relationships/boundaries allowed when they do the disambiguating, but no implementation.
- **Same word, different concepts → split.** Give each concept its own entry and state that they are not interchangeable, and why.
- **Only project-specific concepts.** General programming concepts don't belong even if heavily used.
- **Group under subheadings** when natural clusters emerge; a flat list is fine otherwise.
- **Multi-context repos:** if a `CONTEXT-MAP.md` exists at the root, respect it; if multiple bounded contexts clearly exist, propose a map rather than cramming everything into one file.

### The one baseline-only addition: `待确认`

CONTEXT-FORMAT.md has no "candidate" marker because `domain-modeling` confirms terms as it writes them. This prompt is a **cold-start batch baseline**, so it must distinguish candidate from confirmed. Therefore, and only therefore, append `待确认` to each baseline entry you add. This is a minimal overlay on the official skeleton — it does not change the structure. Confirmation work removes the `待确认`; this prompt never removes it.

*Example only (generic, replace with the project's real terms):* a system has two different "session" states with different lifetimes, owners, and caching → two entries, each defining what it is and what it is not, plus one line on why they cannot substitute for each other; a verb such as "warm" → one entry naming exactly which action it means and which near-synonym action it is distinct from. Every such entry carries `待确认`.

## Scope Boundaries

- `CONTEXT.md` is a pure glossary: concepts and relationships only. No implementation, paths, tech choices, or class internals.
- Skip generic programming terms unless they carry domain-specific meaning here.
- Do NOT aim for exhaustive coverage.
- Do NOT write `product.md`, `tech.md`, `structure.md`, `api-standards.md`, or `testing.md`.
- Do NOT confirm or remove `待确认`.

## Residency — how CONTEXT.md stays reachable

`CONTEXT.md` lives at the **project root** (the convention `grill-with-docs` / `domain-modeling` also use — keeping a single file both tools maintain). It is **not** moved into steering and **not** loaded in full every session; a full glossary in resident context would bloat it.

Instead it is **pointer-resident**: `AGENTS.md` (which is resident) carries one line pointing to it, so every session sees that the glossary exists and reads it on demand. On a fresh project where `AGENTS.md` lacks this line, propose adding one line under its existing "deeper reading" / routing section, e.g. `项目术语/领域概念 → CONTEXT.md`.

Note on protected files: at **runtime**, editing `CONTEXT.md` is fine to do directly, but if you need to add/change the `AGENTS.md` pointer line, `AGENTS.md` is a protected file — present the exact one-line change and wait for confirmation first. (This runtime rule does not apply when the steering system itself is being set up.)

## Working Mode

- **Fresh** — no `CONTEXT.md` → build the baseline (create the file lazily, only once you have terms to write).
- **Extend** — `CONTEXT.md` exists (seeded by a prior grill session or an earlier baseline) → add only missing high-frequency core terms as `待确认`. **Never disturb already-confirmed entries, and never downgrade a confirmed term back to `待确认`.**

## Context Collection

Read these when available:
- Existing `CONTEXT.md` (and `CONTEXT-MAP.md` if the repo has multiple contexts)
- The codebase: module/package names, class names, table/entity names, enum values, and domain nouns recurring across identifiers
- `.kiro/steering/product.md` and `.kiro/steering/structure.md` for domain framing (read for vocabulary; do not copy their content)
- Converted authoritative docs under `docs/` for domain terms

For monorepos: identify the target workspace/context first; if a `CONTEXT-MAP.md` exists, respect the per-context layout.

---

## Phase 1 — Audit

Read the context and output exactly these sections:

**1. Candidate Core Terms**
- high-frequency, cross-module domain concepts found in code/docs, each with *where it recurs* (which modules/tables/enums) as evidence it is baseline-worthy, and a one-line note on which ambiguity it resolves

**2. Ambiguities & Synonyms**
- same word → different concepts, or different words → same concept; propose a canonical choice (`_Avoid_` for the rest) but keep it `待确认`

**3. Existing CONTEXT.md Status**
- which terms are already confirmed (leave untouched) vs which baseline terms are missing
- note any existing entries whose format diverges from CONTEXT-FORMAT.md, as candidates for later alignment — but do not rewrite confirmed entries in this run unless I ask

**4. Questions**
- at most 3 — but prefer marking a term `待确认` over asking, since confirmation is downstream work, not this prompt's job

### ⛔ Gate — MANDATORY STOP

STOP. Confirm the candidate set and that scope stays **baseline** (high-frequency core, not exhaustive) before writing.

---

## Phase 2 — Write the Baseline

After confirmation:
- Use the CONTEXT-FORMAT.md format (pure glossary, `## Language`, `**Term**:`, `_Avoid_`).
- Add only candidates confirmed as genuinely recurring; append `待确认` to each.
- Keep definitions to one or two sentences; express relationships/boundaries only where they do the disambiguating.
- Record ambiguities with a canonical proposal + `_Avoid_`, marked `待确认`.
- Never touch already-confirmed entries; never downgrade them.
- Create `CONTEXT.md` lazily at the project root if it does not exist.
- The written file contains no HTML comments (`<!-- -->`): remove every skeleton guidance or example comment when writing, and never add new ones.
- If `AGENTS.md` lacks the glossary pointer line, propose adding it (one line, confirmation required — protected file).

## Final Verification

Before finishing, verify:
- [ ] Every new entry is marked `待确认`
- [ ] Each term passes the three-part inclusion test (domain concept · real ambiguity · recurs across modules)
- [ ] Format follows CONTEXT-FORMAT.md (`## Language`, `**Term**:`, `_Avoid_`) with `待确认` as the only overlay
- [ ] Pure glossary — no implementation, paths, tech, or executable/ontology-style modeling leaked in
- [ ] Already-confirmed entries are untouched and not downgraded
- [ ] Ambiguities are flagged with a canonical proposal, not force-resolved
- [ ] Scope stayed baseline (high-frequency core), not exhaustive
- [ ] The file contains no HTML comments (`<!-- -->`); all skeleton guidance and example comments were removed

Output a **Baseline Summary** plus a handoff note: *run `grill-with-docs` (which drives `domain-modeling`) during change work to confirm and sharpen the `待确认` terms as real understanding accrues.*
