---
description: Resume work from a named handoff in docs/handoff/ — re-verify its load-bearing claims, checkpoint, then continue.
---

## Role

You are picking up work from a handoff document written by an earlier session. You have zero memory of that session. Your job is to orient yourself correctly and continue the work — without redoing what is done, and without reviving anything that was deliberately set aside.

This works for any kind of work: coding, research, writing, planning, analysis. Do not assume it is code.

Output language: match the language of the handoff document.
Converse with me in Chinese, whatever language the output file is in.

## Input

$ARGUMENTS

The line above is what I typed after the command: the handoff to read, optionally followed by `explore` or `execute`, optionally followed by a note.

- Read exactly the handoff I named. A bare filename means `docs/handoff/<filename>`. Do not look for a newer or different one, and do not second-guess my pick.
- If I named no file, or the file does not exist: list the three newest files in `docs/handoff/` by filename (the `HANDOFF_<YYYY-MM-DD-HHMM>_<topic>.md` names sort as text in time order — do not sort by modification time), and ask me which one to read. Do not pick one yourself.
- Treat any note as a hint, not as an instruction that overrides this prompt.

## Goal

Continue the work described in the handoff, starting from an explicit checkpoint that proves you understood it and that its load-bearing claims still hold.

## Mode

If the Input names neither `explore` nor `execute`, infer it rather than asking: a handoff containing an Execution Plan was written to be executed; one without it was not. State the inference in the checkpoint so I can redirect you there. Only ask if the document contradicts itself on this point.

## The handoff is a record, not the present

Everything the handoff asserts was true — at best — **at the moment it was written**. Code, data, and environments move on; earlier sessions also make mistakes they do not know about. A handoff you were handed and told to read is still not evidence about the present. Being specific, confident, or marked `[proven]` does not change that.

So for you, every claim in it is dated:
- `[proven]` in the handoff means "proven by the previous session, as of the handoff" — treat it like `[proven@<handoff filename>]`.
- `[proven@<file>]`, `[inferred]`, `[lead]`, and anything marked "not verified here" are weaker still.

Two kinds of content are judged differently:
- **Facts about the world** (files, code behaviour, test results, data, external systems, what was measured) — the world is the authority. Re-check the ones you will build on.
- **Decisions and preferences I stated** (Key Decisions, Do-not-do, scope) — I am the authority. Do not re-litigate them or "verify" them against the world. But if a decision rested on a factual premise that no longer holds, say so.

---

## Steps

1. Read the handoff document I named.

2. **Re-verify before you restate.** Before writing the checkpoint, check the present state with tools — not by reading the handoff again:
   - For each repository the handoff involves: `git status` and `git log` since the handoff's "As of" state. Note anything committed or changed after it.
   - Pick the **load-bearing claims**: the ones your proposed first action, or the next phase of the plan, depends on. Usually three to five. Re-check each one directly — run the command, read the file, query the thing. Do not redo the previous session's whole investigation; check only what you are about to stand on.

3. **Before doing any work, output a checkpoint.** Do not read and act in one motion. The checkpoint has nine parts:

   - **What you read and under which mode** — which file you read, and whether you are in `explore` or `execute` and how you concluded that. Put this first: if either is wrong, nothing after it matters.

   - **Re-verified now** — for each load-bearing claim: the claim → how you checked it (the exact command or file) → result: holds / changed / could not check. Then what changed in the repositories since "As of". A claim you could not check stays unconfirmed; say what would check it. If something load-bearing no longer holds, say what it invalidates. *What* changed and *why* it changed are separate claims: report the change as found; name a cause only if you checked it (commit authors and times, file times, the other line's records), otherwise mark it inferred and say what would settle it.

   - **What you will read next** — the documents you plan to open, taken from the handoff's Sources of Truth (for a partly valid file, which sections). If you mean to open anything outside that table, name it and say why. Files listed there as not-to-read stay closed, even if a search turns them up and they look more complete.

   - **The goal**, restated in one line.

   - **Task classification** — done / in progress / not started, based on Current State and Approaches Tried, corrected by what you re-verified. Only what you re-verified in this session counts as established now. Everything else is "as of the handoff": usable as orientation, not as a foundation.

   - **Retractions restated** — what was retracted, and what that retraction invalidates downstream. If a criterion was retracted, any conclusion that rested on it is void too, even where the handoff did not enumerate it. This is the most expensive thing to get wrong: do not reintroduce a dead criterion or a conclusion derived from one.

   - **The Do-not-do list, restated.** You must not silently revive any of it; if something there now seems necessary, ask me first.

   - **Your own proposed first action.** Derive it from The Goal, Current State, Approaches Tried, Retractions, and what you re-verified **before** you look at the Execution Plan — then say whether it agrees with what the plan or the rest of the document implies, and where it differs, and why. The point is not to pretend independence; it is to make your reasoning visible so a mismatch surfaces now instead of after the work is done. The handoff deliberately does not name your first move.

   - **Defects you found in the handoff** — references whose claim does not hold (something said to exist that does not, or said to be gone that is still there), claims you cannot locate, contradictions between sections, anything you needed and could not find, and every claim that failed re-verification. Report these; do not paper over them.

4. **Wait for my confirmation.** If I tell you your restatement or your proposed first action is off, treat that as a **defect in the handoff, not a misunderstanding to argue about**: propose a correction to the handoff file first, then proceed. A handoff that produces the wrong understanding is incomplete regardless of who is at fault.

5. Then continue:
   - **explore mode**: continue from Current State. Avoid what Approaches Tried (failed paths) and Pitfalls & Constraints list. Open questions waiting on me stay waiting — do not answer them yourself.
   - **execute mode**: start from the first phase of the Execution Plan that Current State and your re-verification do not show as done. Do not retry any approach marked "dropped" in Approaches Tried. A phase may be a go/no-go gate — if its criterion says reject the approach, report that rather than working around it.

---

## Rules

- **Checkpoint first**: reconstruct understanding before touching anything. Reading and acting in one motion is how the wrong thing gets built.
- **Re-verify what you stand on**: a load-bearing claim enters your reasoning as established only after you checked it this session. The checkpoint must show the check, not just the conclusion.
- **Unconfirmed is not done**: anything you did not re-verify — including the handoff's `[proven]` — is "as of the handoff"; verify it before treating it as complete.
- **Retracted stays retracted**: do not revive a retracted criterion, and do not trust a conclusion that depended on one — including conclusions the handoff did not think to list.
- **Preserve what was parked**: a vague "continue" does not unpark anything in Do-not-do; ask before reviving it.
- **Scaffolding is not the result**: where the handoff separates work-to-keep from temporary instrumentation, do not mistake the second for the first, and do not build on it.
- **One authority per subject**: read what Sources of Truth names. When an earlier handoff in the chain, or another document on the same subject, says something different, the current handoff wins; report the conflict instead of blending the two. Being longer, more detailed, or mentioned more often does not make a document authoritative. (This governs which *document* to believe; the present state of the world still outranks every document.)
- **Divergence is a signal about the document**: when your understanding and mine differ, the handoff is the thing to fix.
