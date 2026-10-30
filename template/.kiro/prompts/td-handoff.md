---
description: Write or update the session handoff in docs/handoff/ so a fresh session can continue the work.
---

## Role

You are wrapping up the current session. Your job is to compress everything that matters about this session into a portable handoff document, so that a completely fresh session — with zero memory of this conversation — can pick the work up and continue.

This works for any kind of session: coding, research, writing, planning, decision-making, analysis. Do not assume the work is code. Describe artifacts, attempts, and decisions in whatever terms fit the actual work.

Output language: match the language this conversation has been using. Keep the section headings of the template exactly as written (in English), so every handoff can be scanned the same way; write the content in the output language.
Converse with me in Chinese, whatever language the output file is in.

## Input

$ARGUMENTS

The line above is what I typed after the command. It may be empty, or contain a mode (`explore` or `execute`) and/or a hint about the topic or what the next session will focus on. Treat anything that is not a mode keyword as a hint, not as an instruction that overrides this prompt.

## Goal

Produce a Markdown file at `docs/handoff/HANDOFF_<YYYY-MM-DD-HHMM>_<topic>.md` that a fresh session can read cold and know what to orient on.

- The timestamp is local time at the moment the file is first created, and orders the files; no manual sequence number is needed. Get it with `date +%Y-%m-%d-%H%M`; do not guess.
- `<topic>` names what the work is about **at the end of the session**, not what it started as.
- One file per **line of work**. A session usually has one; if it also produced an independent line with its own next steps (see Step 2), that line gets its own file or an explicit pointer to where it is tracked.

## Mode

Check the Input for `explore` or `execute`. If it names neither, decide for yourself: if there is already a clear plan to carry out, use `execute`; otherwise use `explore`. Only `execute` mode fills in the Execution Plan section.

## When this is the right tool

Write a handoff only when the work has to **cross a boundary**: continue in a fresh session, move to a different tool/agent, move to a different place, or hand off to someone else. If you are staying in the same session on the same task and only need to shed noise, that is not a handoff.

---

## Steps

1. **Gather** what actually happened this session — the goal, the current state, what was tried, what was decided, what to avoid. Do not fabricate anything that was not said or done.

2. **Inventory the topics.** Sessions drift: research detours, evidence-gathering, side questions, a new line of work, sometimes a change of goal. List every topic the session touched and classify each one by what it is **now**:
   - **mainline** — the work this handoff carries forward;
   - **research** — gathered knowledge for a mainline judgement → put its conclusion against the decision it informed, with the artifact path and evidence grade;
   - **evidence** — gathered to prove or disprove a specific claim → attach it to that claim; evidence detached from its claim is useless. A failed attempt to get evidence is an Approaches Tried row;
   - **separate line** — has its own next steps → its own handoff file, or a pointer to where it is tracked (an issue, a TODO file). The mainline keeps one line about it;
   - **discarded** — turned out irrelevant → no detail in the body, but record "looked into X, irrelevant because Y" in Do-not-do, so nobody re-investigates it;
   - **goal-changing** — its outcome changed what the mainline is for → handle in The Goal (see below).
   A detour's conclusion keeps its own grade when the mainline cites it: a `[lead]` gathered on the side does not become a decision by being mentioned in the main thread.

3. **Read the prior handoff** — the one this session resumed from (if any). You need its Reflection to spot repeated corrections, and its claims to decide what to carry forward (see §Rules, *Inheritance*).

4. **Grade every claim** by what you actually did, not by how confident you feel:
   - `[proven]` — you executed or checked it this session and saw the result.
   - `[inferred]` — derived from something proven, but not directly checked.
   - `[lead]` — evidence exists but is too weak to carry a conclusion: a single observation, correlation only, a single source, insufficient samples.
   - `[proven@<handoff filename>]` — proven in an earlier session, carried forward without re-checking. The reader treats it as proven *at that time*, not now.
   Use the equivalent terms in the output language. What I state as my preference or decision is authoritative as a decision; what I state as a fact about the world is graded like any other claim.

5. **Settle the sources of truth.** For every domain the next session will read documents about, decide which file is authoritative. For every document that was superseded, retracted, or partly invalidated this session, fix it **at the source** in this pass — the handoff cannot do it on the document's behalf:
   - fully superseded → put a first-line banner `> SUPERSEDED by <path> on <date> — do not use` on it;
   - partly valid → put a first-line banner naming which sections are void and where the authoritative version lives; the Sources of Truth table must name exactly which sections are still valid;
   - a correction to a document's content → write it into that document, not only into the handoff.
   Do not move, archive, or split documents in this pass — that is document maintenance, done separately.
   A note in the handoff saying "document X is outdated" loses to the document itself: X is longer, more detailed, and looks authoritative.

6. **Write the document** using the structure below. Every section appears, in that order, under the exact heading. A section with nothing to say gets "none" — do not drop, rename, merge, or reorder sections, and do not add top-level sections of your own. Anything that does not fit goes into the closest section.

7. **Externalization review.** When the body passes roughly 120 lines, stop and ask *what can move out* — never *what can be deleted*. Rules in §Rules.

8. **Anti-bloat pass.** Test every line: if it were removed, would the next session act differently? If not, cut it. This pass tightens wording only inside Retractions, Do-not-do, Approaches Tried, and Key Decisions — it never removes an entry or its evidence there.

9. Redact anything sensitive (keys, passwords, personal data, internal URLs that should not persist).

10. **Verify every reference against reality.** The test is not "does this path exist" — it is **"does my claim about it hold"**:
    - Cited as existing → confirm it exists *and* contains what you said it contains.
    - Cited as deleted, absent, or not yet created → confirm it really is absent.
    - Cited relative to something else (a bare filename, a path under a directory you named, a different repository) → resolve it against that base, or rewrite it unambiguously.
    - **Competing documents** → for each domain in Sources of Truth, search the workspace for other documents on the same subject. Each one must be either the authoritative file, listed as not-to-read, or already bannered. Also search for references to superseded files from entry points (the always-loaded rules, README, indexes, the authoritative documents) and fix or annotate them.
    A reference that points nowhere is worse than inline content: it looks authoritative and is not.

---

## Output Format: the handoff document

```markdown
# Handoff — <topic> (<YYYY-MM-DD-HHMM>)

## Chain
- Prior handoff: <filename of the handoff this session resumed from, or "none">
- One-line result of each prior session in the chain.
- If an earlier handoff in the chain says something this one contradicts, this one wins — say so here, naming the point.
- Related separate lines: <their handoff files or trackers, or "none">

## The Goal
- What we are trying to achieve, and why.
- Scope boundary: what is explicitly out of scope.
- Goal change: if the goal changed this session, state the old goal, the new one, and which work done under the old goal must be re-judged. Otherwise "unchanged".

## Retractions & Criteria Changes
> Placed this early on purpose: inheriting a dead conclusion is the most expensive mistake the next session can make.

| Retracted conclusion / criterion | What it rested on at the time | Why it is wrong | Retroactive impact |
|---|---|---|---|
| ... | ... | ... | which past conclusions built on it are now void |

- A bad criterion contaminates every result derived from it — that is why this outranks a failed path.
- Keep the original evidence here, not just the verdict. Without the "why", a later session will rationalise the retraction away and revive it.

## Sources of Truth
| Domain | Read this | Do not read (and why) | Partly valid: use only |
|---|---|---|---|
| ... | the one authoritative file | superseded / bannered files on the same subject | file + exact sections |

- Every document the next session needs is reached through this table. Rows already settled earlier in the chain may be repeated briefly or referenced.
- A superseded document is named here and **nowhere else** in the body. Every extra mention — in Current State, Pitfalls, References — makes it more salient than the file that replaced it.
- State what was done at the source (bannered / corrected) per Step 5.

## Do-not-do
- Scope I parked ("not now / skip / leave out"), directions already rejected, known dead ends, topics investigated and found irrelevant.
- Name the thing to avoid precisely: "do not use X's structure" still permits opening X; if X must not be read, say "do not read X" (and list it in Sources of Truth).
- The next session must not silently revive these.

## Current State
- Done / in progress / stuck / waiting on me. Open questions that need my answer go here, each with the options on the table.
- Where the work lives — cite it precisely enough that a stranger can find it (repository, path, section), and quote the exact wording / error / value when it matters. Avoid vague phrases like "fixed the thing".
- Tag each item `[proven]` / `[inferred]` / `[lead]` / `[proven@...]`.
- Carry the context of verification with the claim: which version / commit, which environment, when, at what sample size. "Still fails" is useless if the next session cannot tell whether it ran the same thing.
- **As of**: the commit or uncommitted state of each repository involved, and the time this section was last true.
- If the context was compacted before this pass, say so — the reader should know which parts are a second-hand summary.
- Separate work to keep from scaffolding: which changes are part of the result, and which are temporary instrumentation to throw away. Flag anything left half-done.

## Approaches Tried
| Hypothesis | The test that would kill it | What actually happened | Rules out / does NOT rule out | Kept or dropped, and why |
|---|---|---|---|---|
| ... | ... | ... | ... | ... |

- Never omit the paths that failed — this is the highest-value section.
- State the hypothesis first. "Tried X, still broken" reads as though X were ruled out, when the test may never have touched the hypothesis at all.
- Be exact about what was and was not eliminated. "Changing X did not fix it" is a useful fact; "we ruled out X" is a far bigger claim.
- Include the exact command / action and the verbatim result or error when they matter. If a row needs more room than a table cell, promote it to its own sub-block.

## Key Decisions
- Decision made / alternative rejected / reason for the choice.

## Pitfalls & Constraints
- Non-obvious constraints, gotchas, things that look usable but are not, and why.

## Reflection
- Where I corrected you: what was corrected / attribution / suggested opening instruction for next time. If I did not correct you, write "no corrections this session".
- Attribute honestly to one of: **missing context** · **faulty judgment** · **over-claiming** · **tool or environment limit** · **overreach**.
- Repetition: compare with the prior handoff's Reflection. If a correction recurs, say so and propose the standing rule or check that would stop it (for `/td-reflect` to pick up) — do not just carry the note forward again.

## Execution Plan   (execute mode only; otherwise "n/a — explore mode")
- Phased plan; each phase carries a measurable acceptance criterion.
- A phase may be a go/no-go gate — its acceptance criterion is allowed to be "reject the whole approach".
- Anti-goals distilled from the failed paths above.
- The receiving session derives its own first action before reading this plan and compares; the plan is a proposal to be checked, not an order.

## Quick Start
Orientation only — do not prescribe the first action. Carries exactly four things:
- what to read first: this file, then the authoritative files from Sources of Truth that matter most — nothing that is not in that table;
- the key premises it must not re-litigate;
- environment facts it needs before touching anything (what is running, what is consumed, what is fragile, which repository is which);
- behavioural instructions for the next session (how to label evidence, which language to use, what to disclose).

## Key References
- Anything already captured elsewhere (a plan, a decision record, an issue, an external page) — referenced by path or URL, not copied. Superseded documents do not appear here; they live only in Sources of Truth.
```

---

## Rules

- **No fabrication**: record only what was said or done this session. Inference is allowed only when graded `[inferred]`.
- **Belief vs fact**: the next session treats this document as a contract and will not re-check it — an unverified claim written as fact becomes a false premise for everything that follows. Downgrade anything you only assumed.
- **A conclusion may not be stronger than its evidence.** Grade by what you did, not by how sure you feel. Where the work involves measurement, disclose the sample size and the base rate and let the reader judge the discriminating power.
- **A conclusion borrowed from elsewhere is not a premise here.** Anything carried over from another source, environment, or scenario must be reproduced here before you build on it; until then mark it "not verified here".
- **Inheritance**: content from the prior handoff is either (a) re-checked this session and graded normally, (b) carried as `[proven@<file>]` / its original grade, or (c) left in the prior file and referenced. Do not restate it as "unchanged / inherited" summaries — that is a summary of a summary. Retractions, Do-not-do, and Sources of Truth rows that still hold must be carried in full, because the reader is told this file wins over earlier ones.
- **Authority must be single and explicit**: for any domain, exactly one document is authoritative, and the handoff says which. Banner superseded documents at the source; never leave a document "partly valid" without naming the valid sections.
- **Specific over brief**: precise locations, exact wording, exact values beat abstract summaries.
- **Externalize, never delete.**
  - ~120 lines is a review trigger, not a cap.
  - When over, ask what can move out, not what can be cut.
  - Cannot be externalized, must not be compressed: Retractions, Sources of Truth, Do-not-do, Approaches Tried, Key Decisions.
  - Should be externalized: round-by-round detail, experiment data tables, knowledge write-ups, the contents of a plan or issue that already exists — move them out and leave the conclusion plus a path.
  - Externalizing requires a real destination: the target must already exist, or you must create it in this pass. Content with nowhere to go stays in the body.
  - Create a new external file when the content is bulky and keeps its value beyond this handoff. Keep it inline when it is bulky but one-off — compressed to the part that changes the next action.
- **Redact**: strip keys, passwords, personal data, and internal URLs that should not persist.

---

## Self-check before finishing

- [ ] Every template section is present, in order, under its exact heading; empty ones say "none".
- [ ] Every topic of the session was classified; detours sit against the decision or claim they serve; separate lines have their own file or pointer.
- [ ] A stranger could read this cold and know what to orient on.
- [ ] Every state claim is graded, and carries the version / environment / sample size it was established under; inherited claims show their origin.
- [ ] No conclusion is stated more strongly than its evidence supports; borrowed conclusions are marked "not verified here".
- [ ] Failed paths are recorded, each with its hypothesis and with what it does *and does not* rule out.
- [ ] Retractions are filled in (or "none"), including retroactive impact; a goal change, if any, is in The Goal.
- [ ] Sources of Truth names one authoritative file per domain; superseded documents are bannered at the source, mentioned only in that table, and no entry point still sends readers to them.
- [ ] Reflection is filled in, compared against the prior handoff, and recurrences are turned into a proposed rule rather than carried forward.
- [ ] Work to keep is separated from scaffolding; half-done work is flagged.
- [ ] Every reference was checked against what is actually there, including competing documents on the same subject.
- [ ] An externalization review was done; what remains in the body has nowhere else to go or must not be compressed.
- [ ] Quick Start orients without prescribing the first action, and points only at files in Sources of Truth.
- [ ] Nothing sensitive remains.
