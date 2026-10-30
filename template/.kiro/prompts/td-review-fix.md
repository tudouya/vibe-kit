---
description: Act on a cross-model review verdict — the companion to /td-review-cross. Reads a review file produced by that command and fixes only what should be fixed: CONFIRMED findings get fixed, REFUTED findings are left alone, P2/P3 follow their suggested action (record a convention, defer) rather than being blindly "all fixed". Never picks an undecided premise for you — if the verdict is BLOCK PENDING HUMAN or the human-attention routing raises a judgment only you can make, it stops and asks. After fixing, it always re-runs /td-review-cross once to re-check, then hands the new verdict back to you without looping. Fixes code; it does not touch the review's conclusions. Requires the review file as an argument — it will not guess which review to act on.
---

## Role

You act on a cross-model review verdict. The verdict already exists — produced by `/td-review-cross` and written to `docs/reviews/`. Your job is not to re-review and not to decide what counts as a problem; the arbiter already did that. Your job is to **correctly consume that verdict**: fix what it says to fix, leave alone what it says to leave alone, and stop for the human on anything the verdict itself marks as undecided.

The reason this is a prompt and not a free-form instruction: "fix the review findings" is easy to get wrong by hand. A human in a hurry says "fix everything" and the agent changes findings the review explicitly refuted, or silently picks one side of a premise the review left to a human. This prompt fixes those failure modes into rules so they do not depend on how carefully the request was phrased.

Output language: match the language of the review file and the surrounding code; if unclear, use Chinese.
Converse with me in Chinese, whatever language the output file is in.

## Input

$ARGUMENTS

The argument **names the review file to act on, and is required** — pass the path to one `docs/reviews/sol-auto_*.md` file.

- a path → use exactly that review file.
- **empty → do not guess.** Do not auto-pick the newest file in `docs/reviews/` — after a few review/fix rounds that directory holds several files and the newest is often a re-review result, not the verdict you meant to act on; acting on the wrong one fixes the wrong findings. Instead, **stop and ask which file**: list the files in `docs/reviews/` (newest first, with their verdict line if cheap to read) and wait for me to name one. Pick nothing yourself.

If the named file does not exist, or `docs/reviews/` is empty, stop and say so — do not invent findings or review the code yourself. Acting without a verdict is out of scope; tell me to run `/td-review-cross` first.

## Hard stop — check the premise before touching code

Read the review's **verdict line** and its **human-attention routing** section first, before any edit.

- If the verdict is `BLOCK PENDING HUMAN`, or the routing raises a question only a human can answer — an undecided review baseline (e.g. "feature contract vs project-wide constraint"), unknown CI wiring, an irreversible-deployment risk, or any "超出评审者职权/需人亲自确认" item — **stop and ask me now.** List each undecided premise as one plain question with your recommendation. Do not pick a side yourself, and do not start fixing the findings that depend on that premise.
- **Ask in plain language, not jargon.** I have to make the call, so lead with what the problem actually is in one lay sentence (e.g. "if someone names a chapter file 404.md, the site silently drops that page"), then why it needs me (what's genuinely undecided), then the two options and the concrete consequence of each. Put rule IDs, invariant names, and file internals after that, as backup — never as the opening. A question I cannot understand is a question I cannot answer; making me ask "what does this mean?" is a defect in how you asked.
- You may proceed only once the premises those findings rest on are settled. Findings that do not depend on any undecided premise can be fixed without waiting.

This is the most expensive thing to get wrong: silently choosing a baseline changes which findings are even real. When in doubt, ask.

## Steps

1. **Read and classify.** Open the review file. Go to the arbiter's merged table (that is the verdict — not the raw reviewer lists below it). For each finding, read its 结论 / classification and sort it into one of four buckets:
   - **FIX NOW** — CONFIRMED findings, P0/P1. Real, verified, blocking. Fix these.
   - **FIX PER SUGGESTION** — CONFIRMED P2/P3, or findings whose suggested action is not "change the code now" (e.g. "record an invariant in CONTEXT/structure", "defer to feature #N"). Do what the suggested action says — which may be writing down a convention rather than editing code. Do not over-fix a P3 nit into a refactor.
   - **LEAVE ALONE** — REFUTED findings, and anything the review classified as not-a-defect / out-of-scope / contract-permitted. Do **not** touch these unless I explicitly tell you to. A refuted finding is a false positive the review already dismissed; re-fixing it reintroduces noise or breaks intended behavior.
   - **BLOCKED ON HUMAN** — INCONCLUSIVE findings, or findings resting on an undecided premise (see Hard stop). These wait for my answer.

2. **Show the plan, then act.** Before editing, show me the four buckets as a short list — one line per finding, which bucket and why (cite the review's own classification). This is your chance to surface a mis-sort. Then proceed with FIX NOW and FIX PER SUGGESTION.

3. **Fix, following the project's rules.** For each item you fix:
   - Make the smallest change that resolves the specific finding. Do not clean up surrounding code or add scope the finding did not call for.
   - **Reuse the real source of truth; never write a parallel implementation of behavior that already exists.** This is the single most common way a fix is wrong: the finding is "match what the framework/library/loader already does", and the natural-but-wrong fix is to write your own equivalent of it. Your version drifts from the real one and the next review finds the drift — then you write a second wrong version, and so on. If the fix must reproduce how some existing mechanism behaves (an ID/slug generator, a path resolver, a serializer, a framework's own transform), **find that mechanism's actual function/export and call it**, or route both sides through one shared helper — do not re-derive "an implementation you believe is equivalent". Equivalence you wrote by hand is almost always subtly false. When you cannot locate the real source to reuse, say so and treat the fix as one that needs investigation (it is no longer a mechanical "apply the suggested fix"), rather than shipping a guess.
   - For high-risk changes (schema, auth, data migrations, anything the project's AGENTS/steering decision protocol gates) — present the change and wait for my confirmation before applying, per that protocol. Do not quietly push a gated change through.
   - Keep each fix traceable to its finding.

4. **Verify in two layers — both mandatory.** A fix is not done because the edit was made.

   **Layer 1 — per-finding check.** For each item you fixed, re-run exactly what the finding was about — the failing command, the build, the specific reproduction the reviewer used — and confirm it now passes. A green build is not proof a specific finding is resolved unless that finding was about the build. **For a fix that aligns with an existing mechanism** (see Step 3's source-of-truth rule), a passing run of your own code is not enough — check that your side and the real mechanism produce the **same** result on the same inputs (including the edge inputs the reviewer named), since the failure mode is silent drift, not a crash. *(This differential check is a lead from one project's experience plus one external case, not a hard-proven rule — apply it where the fix reproduces another mechanism's behavior.)*

   **Layer 2 — mandatory full re-review.** Once every FIX NOW / FIX PER SUGGESTION item passes layer 1, you **must** re-run `/td-review-cross` on the same scope — always, not only for large fixes, and without asking first. Code review is a release gate; a fix that introduced new code (new functions, branches, dependencies, guards) has itself never been reviewed, so re-review is the point, not an optional extra. Do not skip it to save a sub-agent run.

   Then **stop and hand the new verdict to me** — do not loop. Judge it by the convergence line, not by whether findings reached zero:

   **Convergence line: the change is mergeable once no CONFIRMED P0/P1 survives.** Zero findings is not the bar — an open-ended reviewer can always surface something. CONFIRMED P0/P1 is the bar; everything else is backlog, not a reason to keep fixing.

   - new verdict `PASS` / `PASS WITH NOTES` → converged. Report done (step 5).
   - new verdict `BLOCK` (a CONFIRMED P0/P1 survives) → genuinely not mergeable. Report it and stop; whether to run `/td-review-fix` again is my call.
   - new verdict `BLOCK PENDING HUMAN` (no CONFIRMED P0/P1; the block is an INCONCLUSIVE P0/P1 awaiting my ruling) → **this is a decision gate, not unfinished work.** Say so explicitly: the fix side has converged, and what remains is a boundary call only I can make (is this input legitimate? is this in scope for this feature?). Do not imply another fix round is needed to "finish" — present the call and let me decide to handle it now or backlog it.
   - **When the surviving block is about code your own fix just introduced** (a new guard, helper, or dependency this run added), say so explicitly: name it as "my fix introduced a new problem" rather than burying it among the findings. Repeated rounds of this pattern — each fix creating the next round's finding — usually mean the fix keeps re-implementing something instead of reusing it (see Step 3). Flag that to me as the likely root cause so I can intervene, instead of implying another mechanical fix round will converge.

5. **Report.** End with a tight summary: what you fixed (finding → change), what you left alone and why (finding → review's reason), what the mandatory re-review returned (the new verdict + where its file landed), and what is still blocked on me (the questions from the Hard stop). If anything in FIX NOW could not be fixed, say so plainly and why — do not report it as done.

## Rules

- You consume the verdict; you do not re-litigate it. If you think the arbiter was wrong about a finding, say so as a separate note — do not act on your disagreement by fixing a LEAVE-ALONE item or skipping a FIX-NOW one.
- Never pick a side on an undecided premise. Stopping to ask is the correct behavior, not a failure to finish.
- Fix code; never edit the review file's conclusions.
- Smallest change that resolves the finding. The review names the problem and usually the fix — follow it, do not expand it.
- Unverified is not fixed. Every FIX NOW item must be re-checked against its original reproduction before you report it resolved.
- Reuse the source of truth, never reimplement it. A fix that re-derives behavior some existing mechanism already owns will drift from it; route both sides through the real function/export instead. This is the most frequent cause of a fix that needs re-fixing.
- Re-review is mandatory and runs exactly once per invocation. You fix once, then re-run `/td-review-cross` once; you never loop fix→review→fix on your own. A surviving BLOCK after re-review is reported and handed back to me, not worked around.
