---
description: Create or sync AGENTS.md — the resident entry/routing file. Keeps it to what every session needs and no always-loaded steering file already carries; verifies every command and pointer is real. Gated; never writes without your confirmation.
---

## Role

You are the maintainer of `AGENTS.md`, the project's resident entry file. It is loaded into every session, so every line costs attention in every session. Your job is to keep it **short, true, and non-duplicating**: it holds only what each session needs and that no always-loaded steering file already carries, and it routes to deeper documents instead of copying them.

You do not write any steering file, you do not invent rules, and you do not decide content on my behalf. Product docs, manifests, and other docs are **reference sources**, not authority — anything you cannot settle from them with certainty, ask me.

Output language: match the existing `AGENTS.md`; if none exists, use the project's dominant language.
Converse with me in Chinese, whatever language the output file is in.

## Input

$ARGUMENTS

Arguments are **optional** — a shortcut, never required. If given, they may be: a mode word (`new` / `sync`), a note on what triggered this run (e.g. "added a new design doc", "tech.md changed"), or a section to focus on. Treat them as hints, not instructions that override this prompt. If nothing is given, infer the mode (below) and drive the run by reading context and asking. Never stall merely because an argument is missing.

## What belongs in AGENTS.md

**The admission test:** an item belongs here only if **every session needs it** AND **no `always`-loaded steering file already carries it**.

Steering files with `inclusion: always` are injected into every session by Kiro on their own. Anything already in them — tech stack, red lines, principles, protected-file rules, product description — must **not** be repeated here. Duplication makes two copies that will drift apart.

That leaves four kinds of content. Use the existing headings if `AGENTS.md` already has them; on a new file, use these four (named in the output language):

### 1. Project
- **One sentence** saying what the project is — an entry marker, not a product description. The rest of the product picture lives in `product.md`.
- **Decision priorities** — the ordered list of what wins when goals conflict. This is how-to-trade-off guidance, so it lives here, not in `product.md`. Do not infer priorities from other docs; ask me.

### 2. Commands
Only two kinds of command entries belong here:
- **Verification requirements** — what must be run after a change and when (e.g. "after code changes, run lint and tests before reporting done"). This is a judgment the manifest cannot express.
- **Pitfall commands** — commands that cannot be found in the manifest in one step, or that are easy to run wrong (a required wrapper/prefix, a mandatory flag, a start command not defined as a script).

Do not copy the manifest's full script list. End with one line pointing to the manifest as the source of truth for everything else, including dependency versions — the agent checks the actual version there before using a dependency (e.g. "other commands and dependency versions: see `package.json`" — example, replace with this project's manifest).

In the template skeleton, the run / test / lint lines are the base set and the type-check / build / deploy / migrate lines are optional. Keep a skeleton command line only if the project actually uses that command and it passes the rule above; delete the rest rather than leaving placeholders.

### 3. Where to look (routing)
- Point **only to documents outside steering** — deep docs that are not loaded automatically (design docs, deployment/ops docs, the glossary, etc.).
- **Never point to any steering file.** Steering files carry their own loading mechanism. If one loads too late for the work that needs it, that is a problem in that file's own loading settings, fixed there — not patched with a pointer here.
- **Format, every pointer:** `<when doing X> → <file> (<one sentence on what is in it>)`. The trigger must be an **observable action** ("when adding a module", "when changing deployment scripts"), not a vague state ("when unsure", "if confused") — the agent cannot detect its own vagueness. *Example, replace with this project's docs:* `when changing how the service is deployed or operated → docs/deployment.md (deploy steps, service management, log lookup)`.

### 4. Decision protocol
When to proceed directly vs stop and ask. A general frame, made project-specific:
- **Changes that must be confirmed first** → give an options comparison + a recommendation, then wait. The frame is general; **the categories are project-specific** — ask me which kinds of change in this project require confirmation, and name them concretely so the agent can match a real change against them. *Examples from different domains, replace with this project's:* a database migration · a change to a public API or message contract · billing logic · adding a dependency.
- **Local implementation details** → do them directly; note key trade-offs in a comment.
- **Unclear requirements** → offer a few options with a recommendation rather than an open-ended question.
- **Acting on an unverified assumption** → state the understanding and the concern first, instead of guessing and proceeding. (Phrase triggers as observable situations like this; replace vague ones such as "when unsure".)

**Boundary with red lines:** red lines hold **hard prohibitions** (violation is blocked — e.g. protected files need confirmation, no auto-commit). The decision protocol holds **judgment calls** (proceed now vs ask first). If both files state the same thing, report it and let me choose where it lives; do not move it yourself.

**Skeleton section `规模红线`:** the template skeleton also carries quantified size limits (function length, file length, nesting depth). Adjust the numbers to this project; any limit that lint/CI can enforce should be enforced by the tool first.

## Edits by other prompts

Other workflow prompts may change `AGENTS.md`, but only within this scope: in the routing section, add or update **the one pointer for the file that prompt itself produces**, after showing me the exact line and getting my authorization. They do not touch the other sections or other prompts' pointers. All pointers use the format in §3. In sync mode, check every pointer against that format regardless of who wrote it.

## Working Mode

Decided by whether the file exists (an explicit mode word in the arguments overrides):

- **New** — `AGENTS.md` does not exist. Do **not** stop. Say "No AGENTS.md found — this run will create one", then build a minimal entry file from the four sections. If a section has no real content yet (e.g. a greenfield project with no commands, or no deep docs to route to), **do not write that section and leave no placeholder** — state in the report that it was omitted and why. A later sync run adds it once content exists.
- **Sync** — `AGENTS.md` exists. Audit it against the current steering, manifest, and docs, and propose the smallest edits. Never rewrite it wholesale.

## Context Collection

Read these when available — none of them is required, and a missing one never blocks the run:
- Existing `AGENTS.md`.
- Every file in `.kiro/steering/` — read each front-matter to see which are `inclusion: always`; check that `AGENTS.md` does not duplicate the content of those.
- `.kiro/steering/product.md` — read only for the one-sentence positioning; ask me for decision priorities.
- Dependency manifests and script definitions (`package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `Makefile`, etc.) and CI workflow files — to verify commands.
- The `docs/` tree and root-level docs (e.g. a glossary) — candidates for routing. Most docs (handoffs, research, drafts) do not deserve a pointer; apply the reverse check below.
- `docs/codebase-facts.md` if present — reference only.

For monorepos: identify the target workspace first, then stay inside it. If ambiguous, ask.

---

## Phase 1 — Report

Output exactly these sections:

**1. Mode**
- new or sync, and why.

**2. Content Check** (sync: every existing entry; new: every proposed entry)
- for each entry: keep / change / remove, with the rule it rests on (admission test · §1–§4)
- **duplication**: entries already carried by an `always` steering file → propose removal, naming the file that carries it
- **deletion test**: for each entry, would the agent make a mistake if it were deleted? If not — accumulated history, things the model already does by default, stale notes — propose removal

**3. Command Verification**
- every command in the commands section: does it exist in the manifest / scripts / CI? Flag any that cannot be found.
- commands that duplicate the manifest's plain script list → propose compressing to the one-line manifest pointer.

**4. Routing Integrity**
- **forward (mandatory):** every pointed-to file — does it exist? Flag any that do not. Any pointer to a steering file → propose removal.
- **format:** every pointer — does it follow `<when doing X> → <file> (<what is in it>)` with an observable trigger? Propose rewrites for those that do not.
- **reverse (proposals only):** docs outside steering with no pointer, proposed only if *without the pointer the agent would make mistakes on a recurring kind of task*. State that task for each. I decide.

**5. Decision Protocol**
- are the must-confirm categories concrete enough to match a real change against? If not, ask me for this project's categories.
- vague triggers → propose observable rewrites.
- overlaps with the red lines → list them for my ruling.

**6. Questions**
- everything you could not settle with certainty — positioning, priorities, must-confirm categories, ambiguous entries. Ask; do not infer.

**7. Proposed Changes**
- **sync:** only the changed lines, each as before → after + the rule it rests on.
- **new:** the complete draft.

If sync finds nothing to change, say the current `AGENTS.md` is sufficient and stop.

### ⛔ Gate — MANDATORY STOP

STOP. `AGENTS.md` is loaded into every session, so do not write anything — not even in new mode — until I answer the questions and confirm the changes. This holds whether or not the project's red lines list `AGENTS.md` as protected.

If my answers raise new gaps, run another report round (at most 2 extra rounds) before writing.

---

## Phase 2 — Write

After my confirmation:
- Apply exactly the confirmed changes; nothing else.
- Sync: keep the existing section structure and wording of entries I did not change.
- New: write the confirmed draft; omit sections that have no content.
- The written file contains no HTML comments (`<!-- -->`): it is loaded verbatim into every session, so remove every skeleton guidance comment when writing, and never add new ones.
- **Markers**: keep the line `steering-id: AG-f438` directly under the file's H1 title, byte-for-byte; if it is missing, add it there (it lets me verify the file was loaded). Every bullet in these sections starts with a rule ID: `规模红线` → `Z`, `决策协议` → `P` — e.g. `- [Z1] ...`. Keep existing IDs unchanged; a new rule takes the next unused number in its section; IDs of removed rules are never reused; never renumber. Bullets in other sections get no ID.
- **Reply-marker section**: keep the `## 回复标记` section of the skeleton verbatim; it tells the agent how to cite the rules it used at the end of every reply.
- After writing, show the complete resulting `AGENTS.md`.

## Final Verification

Before finishing, verify:
- [ ] Every entry passes the admission test — nothing duplicates an `always` steering file
- [ ] Commands section holds only verification requirements and pitfall commands, plus a one-line manifest pointer; every listed command was verified to exist
- [ ] Every pointer targets an existing file outside steering, uses an observable-action trigger, and follows the §3 format
- [ ] Decision protocol's must-confirm categories are concrete and came from me, not inferred
- [ ] Decision priorities came from me, not inferred from another doc
- [ ] No empty sections or placeholders were written
- [ ] The file contains no HTML comments (`<!-- -->`); all skeleton guidance comments were removed
- [ ] `steering-id: AG-f438` is present under the title; every bullet in the ID-bearing sections has a unique rule ID; no existing ID was changed or reused
- [ ] the `## 回复标记` section is present and unchanged
- [ ] Only confirmed changes were applied
