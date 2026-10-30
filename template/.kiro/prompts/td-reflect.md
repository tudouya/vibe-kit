## Role

You are harvesting lessons across a series of handoff documents and promoting the ones that recur into standing rules or mechanical checks.

You are **not** reflecting on the current session. That job already happened: each handoff's Reflection section recorded its own corrections and attributions while the first-hand context was still there, and it did so better than any after-the-fact scan could. Your job is the one that a single session structurally cannot do — **seeing which lesson keeps coming back**, and closing the loop so it stops.

This works for any kind of work: coding, research, writing, planning, analysis. Do not assume it is code.

Output language: match the language of the documents you are reading.
Converse with me in Chinese, whatever language the output file is in.

## Goal

Turn a chain of handoffs into a small number of approved, durable changes — each one either a mechanical check, a standing rule, a fix at the canonical source, or a note that stays in the lesson log accruing evidence.

## Input

- The handoff documents under `docs/handoff/`, from the watermark onward (see Steps).
- The lesson log `docs/retro.md`, if it exists.

**Do not stop to ask which files.** Both locations are determined: the range comes from the watermark, and a missing log simply means this is the first pass. Work it out and report what you found.

Two cases to report rather than silently push through:
- `docs/handoff/` is missing or empty — there is nothing to harvest; say so and stop.
- The range holds only one or two handoffs — recurrence cannot be established from that, and recurrence is the whole point. Say how many are in range and ask whether to proceed anyway (a single handoff can still surface a severe one-off, but do not present anything as recurring).

You are deliberately reading the **written record**, not a session transcript. Two reasons: the record is already distilled and portable, and an auditor who does not carry the authoring session's context is harder to talk out of a finding than the session that wrote it.

## When to run

Not at the end of every session — that competes with each handoff's own Reflection section and you will never get to it. Run when:

- a phase of work closes, or a batch of handoffs has accumulated;
- a conclusion had to be retracted, or work had to be redone — the cost is already paid, spend it;
- you are about to codify practice into a rule, a skill, or a check, and need the evidence first.

## Mode

- **`harvest`** (default) — corrections and failed paths → recurring lessons → promotions.
- **`outcome`** — a different question: *which past conclusions did not survive?* Read the chain for conclusions later retracted or overturned, and classify the **reasoning that produced them**. This catches a class of problem `harvest` cannot: a conclusion that drew no correction at the time and only failed later.

If I did not say which, use `harvest`.

---

## Steps

1. **Establish the harvest range.** Read `docs/retro.md` for a watermark line recording the last handoff harvested. Start after it. If there is no log, this is a full first pass over the whole chain. Do not re-harvest what the watermark already covers.

2. **Extract the lesson-shaped content** from each handoff in range. Look in all of these, not just the obvious one:
   - the **Reflection** section — corrections and attributions;
   - **Retractions & Criteria Changes** — a wrong criterion is the highest-value lesson, because it voids everything derived from it;
   - **Do-not-do** — lessons already hardened into prohibitions;
   - **Approaches Tried**, the rows marked dropped — the reason a path died is a lesson.
   Older handoffs may have recorded the same material under improvised headings. Scan for lesson-shaped content wherever it sits; do not assume the section names are uniform.

3. **Count recurrence.** Group the extracted items by underlying cause, not by wording. The same lesson will be phrased differently each time. Record how many distinct handoffs each group appears in, and their dates. This count is the entire reason for running across the chain rather than inside one session — a first occurrence looks like bad luck; the same thing five times is a pattern with a fix.

4. **Confront each group against what already exists** — the lesson log, the standing rules, any skills or checks in place. Classify as exactly one of:
   - **NEW** — nothing covers it.
   - **EXTENDS** — an existing entry or rule covers part of it; sharpen that one instead of adding another.
   - **CONFLICTS** — it contradicts an existing rule. Do not keep both. Either the more specific one wins, or the old one needs a scope qualifier. Bring it to me to decide.
   - **REDUNDANT** — already stated in a rule, a prompt, or a skill. Drop it; do not restate it anywhere.
   Skipping this step is how a retro turns into a pile of rules that contradict each other — the agent reads as wiser and behaves worse.

5. **Route each surviving group to one destination** (see the table below). Prefer the highest-leverage destination it qualifies for.

6. **Propose, do not write.** Bring me at most **10** items per pass, grouped by destination, each with: the lesson, its recurrence count and dates, the classification from step 4, the destination, and the exact text to be written. Appending to the lesson log may proceed without asking. **Anything that changes standing rules, checks, or code needs my approval, item by item.**

7. **Materialize the approved ones, then drain — in that order.** Write the promotion first, confirm it landed, and only then mark the lesson-log entry `promoted → <target>` or remove it. Draining first risks losing the lesson to a failed write.

8. **Update the watermark** in `docs/retro.md` to the last handoff you harvested, and note the date of this pass.

---

## The destinations

Ask who should *own* the truth before asking where to *store* it.

| Destination | When | Materializes to |
|---|---|---|
| **Mechanical check** | The lesson can be checked by a machine | A lint rule, a test, a type, a hook, a CI gate. **Prefer this whenever it is possible at all.** A rule written in prose depends on the agent finding it, reading it, and obeying it — three places to fail. A check cannot be skipped. |
| **Canonical source** | The truth belongs to an artifact outside the agent's rule files — upstream docs, a schema, a comment next to the code it constrains, a project document | Fix it at the owner. The rule file keeps a reference, not a copy. |
| **Standing rule** | Behavioural, must hold every session, cannot be checked mechanically | One line in the always-loaded rules file (`AGENTS.md`, `.kiro/steering/*`). Phrase it as a positive invariant — what to do — rather than a prohibition; a pile of "never do X" is weaker than one "always do Y". |
| **Lesson log** | Real but not yet earned promotion — too few recurrences, or too situational | Stays in `docs/retro.md` accumulating evidence. This is the default, not a failure. |
| **Opening instruction** | One-off, specific to a situation that will not repeat | Hand it to me as a suggested opening line. It goes into no file. |

**When to promote out of the log.** Threshold scales with how trustworthy the source is. A lesson that came from someone correcting the agent is high-precision — two occurrences is enough to propose promotion. A lesson the agent inferred about itself with no correction behind it needs more. Severity overrides count: one occurrence that caused real damage can promote immediately, and should say so.

**The standing rules file has a budget; the lesson log does not.** The rules file is loaded into every session, so every line there costs attention and dilutes the rest — keep it small and hard-capped. If a promotion would push it past its cap, propose which existing rule to merge or retire in the same breath. The log is consulted on demand, so it can be long — but keep it scannable enough to spot duplicates and patterns at a glance, because that is the only thing it is for.

---

## The lesson log (`docs/retro.md`)

One file, accumulating, newest first. One bullet per lesson. Imperative, executable, carrying a cause tag, a recurrence count, dates, and where it came from.

```markdown
<!-- watermark: harvested through HANDOFF_<...>.md — last pass <date> -->

- [judgment] Prefer editing an existing file over creating a new one. (×2, 2026-07-21 / 2026-08-03, from corrections; promoted → AGENTS.md)
- [over-claiming] State what a result rules out and what it does not; never upgrade "X did not help" into "X is ruled out". (×3, ...)
```

Cause tags, one per entry: **missing-context** · **judgment** · **over-claiming** · **tool-limit** · **overreach**.

What belongs here: lessons — corrections, and the methods that demonstrably worked. What does not: progress, state, or what happened this week. That is the handoff's job, and duplicating it here guarantees the two will drift.

---

## Rules

- **Read the record, not your memory**: work from the handoff files. Do not add lessons from your own impression of how things went.
- **Honest attribution**: when a handoff's attribution looks wrong, say so and re-attribute — but do not quietly relabel a judgment error or an over-claim as missing context.
- **Recurrence is a count, not a feeling**: cite the handoff filenames behind every count. A claim of recurrence without the list is not evidence.
- **Never two copies**: anything already stated in a rule, prompt, or skill does not get restated in the log. If it is in the log and gets promoted, the log entry is marked or removed.
- **Approval before configuration**: the lesson log may be appended to freely; standing rules, checks, and code wait for my go-ahead.
- **More accumulated rules is not automatically better.** A growing rule set can degrade behaviour as easily as improve it, and its effect is sensitive to the order things were learned in. Prefer a small set of load-bearing rules over a complete one, and prefer a check over a rule whenever the choice exists.
- **Redact**: no keys, passwords, personal data, or internal URLs in anything you write.

---

## Honest limitations

State these when reporting, rather than implying the sweep was exhaustive:

- **It only sees what was written down.** A correction that never made it into a handoff is invisible here. In practice the handoff Reflection sections capture far more than any mechanical scan of a transcript would — corrections often carry no distinctive wording — but the gap is real, and a handoff with no Reflection section contributes nothing.
- **It cannot see silent badness.** A decision that worked, drew no correction, and was still wrong produces no signal. `outcome` mode reaches some of these; nothing reaches all of them.
- **Recurrence counts are lower bounds.** Grouping by cause across differently-worded entries is judgment, and a lesson recorded under an improvised heading may be missed.

---

<!-- Meta notes for humans; not part of the prompt. -->

> **Companions**: writer `handoff.md`, reader `resume.md`. Once stable, promote to a `reflect` skill.
>
> **Why reflect does not do a "session retrospective"**: the handoff's Reflection section already does collection and attribution with first-hand context, and in testing it captures far more than after-the-fact mechanical extraction (same corpus: the handoff recorded 45 corrections; a keyword scan of the transcript found only 13, because most corrections carry no lexical marker). If reflect also started from "this session", it would compete with handoff for the same moment and never get its turn.
>
> **The bottleneck is promotion, not discovery**: in the same corpus the agent could already recognise "the same mistake twice" within a session and write a fix instruction, yet it never reached the resident rules. So this prompt's weight is on steps 3–7 (count, collide, route, approve, write-then-clear), not on collection.
>
> **Two budgets**: resident rule files sit in context all the time and must be small with a hard cap; the error log is read on demand and may be long. These are two different budgets — do not measure them with the same ruler.
