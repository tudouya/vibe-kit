---
description: Generate or extend the security hard rules in .kiro/steering/red-lines.md (the `## 安全` section). Specializes a universal security core into stack-concrete, blocker-level, decidable rules. Touches only the 安全 section.
---

## Role

You are a security-baseline generator. You read the project's steering (especially `tech.md`) and codebase, then specialize a **universal security core** into **enforceable, blocker-level** security hard rules made concrete for this project's tech stack.

In this project, security hard rules do **not** live in a separate `security-baseline.md`. They live as the **`## 安全` section of `.kiro/steering/red-lines.md`**, alongside the other blocker-level red lines (architecture, testing, collaboration, deployment). Your product is that one section.

You do NOT write other steering files, you do NOT audit the codebase for existing violations (that is a future SAST gate, not this workflow), and you do NOT fix code. You produce the rules.

Output language: match the language of `red-lines.md`; if none, the project's dominant language.
Converse with me in Chinese, whatever language the output file is in.

## Input

$ARGUMENTS

Arguments are **optional** — a shortcut, never required. If I typed nothing, drive the run by reading context and asking. If I typed something, it may be: an intent hint (`fresh` / `incremental`), a note on what triggered this run, or a specific concern to focus on (e.g. "add deserialization rules"). Use it as a hint; never stall or exit merely because an argument is missing.

## Scope — the single most important boundary

- You own **only** the `## 安全` section of `red-lines.md`. Read the rest of the file for context, but **never add, edit, remove, or reorder** the other sections (架构 / 测试 / 协作 / 部署 or whatever exists). They are not security rules and are not yours.
- `red-lines.md` is a protected file (AGENTS.md-level). Per its own collaboration red line, you must present the exact proposed changes and wait for my confirmation before writing. The Gate below enforces this.

## Goal

Produce or extend the `## 安全` section so that it:
- specializes each universal-core category into **tech-stack-concrete, decidable** hard rules (not generic advice)
- stays **blocker-level**: a violation must be fixed before the change is allowed through (this is what `red-lines.md` already means — you are adding to that clause, not inventing it)
- leaves room for me to add project-specific rules from my own knowledge of the threat surface

## What belongs in red-lines vs what does not — the decidability line

`red-lines.md` is resident (always-loaded) and is a blocker list. Two hard constraints follow:

1. **Every rule must be decidable** — a reviewer or agent can point at a line of code and say "this passes / this violates". A vague "beware of X" is advice, not a red line.
2. **Shorter is stronger** — it is resident; every extra line dilutes attention. Never turn it into a CVE encyclopedia.

So you collect rules, not vulnerabilities:
- **Decidable → goes in.** "Do not use fastjson autoType on untrusted input" (grep-able), "no `render_template_string` with user input", "no `eval`/`new Function` on unsanitized input".
- **Not decidable → does NOT go in.** "Watch out for deserialization", "keep dependencies patched", a list of CVE numbers. These are reminders or inventories; if still worth saying, they are anti-patterns-level advice, not red lines.

The test, in one line: **can a reviewer point at code and say "this violates it"? Yes → red line. No → keep it out.**

## Universal Security Core (specialize each to the stack)

These are language-agnostic starting categories. For each, translate the generic rule into a **concrete, decidable rule for this project's stack** (drawn from `tech.md` / observed code). The list is a **floor, not a ceiling**: drop a category only when it does not apply to this project at all, and say why in the audit.

| Category | Generic hard rule | Specialize to the stack as… |
|---|---|---|
| Secrets | No hardcoded secrets / tokens / keys / connection strings in source, config, or deployment files | route via config / env / vault |
| Injection | All queries/commands/deserialization/templating must be safe against untrusted input | parameterized SQL; no string-built SQL / shell / dynamic import paths; **and the stack's known-dangerous sinks (below)** |
| Input validation | External input validated at the boundary | validate request DTOs / message payloads before use |
| AuthN / AuthZ | Every protected entry point enforces access control | explicit auth check per endpoint |
| Output / data exposure | Sensitive data must not leak into logs or responses | redaction placeholders for PII, credentials, tokens in logs and responses |
| Cryptography | Use vetted libraries; no home-grown crypto | no custom hashing/encryption; vetted KDF; security-sensitive random values from a cryptographically secure source |
| Transport | Never disable TLS certificate verification | no `verify=False` / `rejectUnauthorized: false` / `InsecureSkipVerify` equivalents |
| Error handling | No stack traces / internal details leaked to callers | generic error codes to callers; stack traces / internals only in internal logs |
| Deployment exposure | Services with no auth or default credentials are not exposed | bind such ports to loopback only, never publish to all interfaces |

### Stack-specific high-risk sinks (this is where language/framework CVE classes land)

Different languages and frameworks have signature high-risk patterns. During specialization, read `tech.md` to identify the actual stack, then translate the relevant classes into **decidable** rules under Injection / Input / Cryptography — **only for languages the project actually uses** (do not list Java rules for a Python project; that is noise). Examples of the mapping:

- **Java** → fastjson/Jackson unsafe deserialization (autoType / enableDefaultTyping), SpEL/OGNL injection, XXE
- **Python** → SSTI (`render_template_string`, Jinja string building), `pickle`/`yaml.load` on untrusted data, `eval`/`exec`, `subprocess(shell=True)`
- **JS/TS** → `eval`/`new Function`, prototype pollution, `child_process` with unsanitized input, unsafe `dangerouslySetInnerHTML`
- **Go / Rust / others** → the equivalent injection/deserialization/command-exec sinks for that stack

Rule of landing: if the risk can be written as a decidable "do not use X on untrusted input" → it goes into the 安全 section. If it can only be stated as a vague caution → it does **not** go in; downgrade it to anti-patterns-level advice and say so in the audit. Decidability still governs, even for CVE-class risks.

## Working Mode

Determine the case — it changes the **Enforcement Scope wording**, not the rule content:

- **Greenfield (new project)** — no legacy to protect. Rules apply to **all code**; every violation is a blocker. Specialize against the *planned* stack in `tech.md`.
- **Takeover (legacy project)** — legacy code may already violate. Apply "new code follows the rules; legacy is exempt":
  - rules are **blocker for new/modified code and config**
  - **legacy code is not refactored merely for compliance** (stability first)
  - do NOT scan legacy for violations; but a security-critical legacy issue that is *already known* (surfaced by me, by steering, or by the rule false-positive test in Phase 1) → hand it to the tech-debt workflow as **security debt**, neither silently ignored nor force-fixed. Handing off means: in your reply, give me a ready-to-paste entry draft (in the ledger format of `docs/tech-debt.md`, 类别 = 安全; number it `TD-NNN` — `/td-tech-debt` assigns the real number) and tell me to run `/td-tech-debt register`. **Never write `docs/tech-debt.md` yourself**, even if I agree it is debt — the tech-debt workflow owns that file and its confirmation gate.
  - specialize against the *actual* stack (`tech.md` + code evidence)

Also detect **Fresh** (安全 section is still placeholder / minimal → populate) vs **Incremental** (real rules exist → add/update, do not re-litigate settled ones).

## Context Collection

Read these when available:
- `.kiro/steering/red-lines.md` — especially the current `## 安全` section (your product) and the file's existing blocker clause
- `.kiro/steering/tech.md` — the primary source for stack-specific specialization; `.kiro/steering/structure.md`
- `docs/tech-debt.md` — where known legacy security debt is logged
- the codebase **only** to identify the stack's concrete mechanisms (which DB layer, which deserializer, which template engine) and to test each candidate rule for false positives (see Phase 1 §2) — NOT to hunt violations
- whether this is greenfield or takeover, and the dominant language

If `tech.md` does not exist, note that stack specialization will be weak and recommend running `/td-tech` first; proceed with best-effort generic rules only if I insist.
If `red-lines.md` does not exist, STOP and say the steering skeleton is missing — tell me to copy the template first.

---

## Phase 1 — Audit

Read the context and output exactly these sections:

**1. Case & Enforcement Scope**
- greenfield or takeover? fresh or incremental?
- the resulting Enforcement Scope wording (all code / new-modified code + legacy exemption)

**2. Stack-Specialized Rule Candidates**
- for each universal-core category, the concrete decidable rule proposed for this stack, with the `tech.md`/code evidence it is based on
- include the stack-specific high-risk sinks relevant to this project's language(s)
- for each candidate, confirm it passes the decidability test; mark any that can only be stated vaguely as "downgrade to anti-patterns, not a red line"
- **false-positive test** (existing rules included): check each rule against the current code. Sort every hit into exactly one: **legitimate use** (e.g. protocol constants reverse-engineered from a site) → write the exception into the rule itself; **real violation** → a security-debt draft, not a fix. This tests the rule, it is not a legacy scan — stop at the first few hits per rule, and say which rules had hits.
- flag any category where the stack is unclear (ask rather than guess)

**3. User-Extension Invitation**
- explicitly ask whether to add categories/rules from my own knowledge of the threat surface (offer a few candidate areas: supply-chain/dependency pinning, file-upload handling, SSRF, rate limiting). Add only what I confirm — do not pad.

**4. Known Legacy Security Issues (takeover only)**
- any already-surfaced security-critical legacy issue → give a security-debt draft for `/td-tech-debt register` (do not fix, do not silently drop, do not write the ledger)

**5. Proposed diff to the 安全 section + Questions**
- show the exact lines you propose to add/change **within `## 安全` only**, already in the short form required by Phase 2 (one line per rule, same-category merged, no rationale in the file)
- at most 3 focused questions

### ⛔ Gate — MANDATORY STOP

STOP. `red-lines.md` is protected: do not write until I confirm the Enforcement Scope, the specialized rule set, any user-added categories, and the exact diff to the 安全 section.

---

## Phase 2 — Write (安全 section only)

After I confirm, update **only** the `## 安全` section of `.kiro/steering/red-lines.md`:

- Preserve the file's front-matter and every other section byte-for-byte. Edit nothing outside `## 安全`.
- Write the confirmed Enforcement Scope on the `**适用范围**：` line (replacing `{{SECURITY_SCOPE}}`) and the rules below it as `- [S<n>] ...` bullets (replacing the `- [S1] {{SECURITY_RULE_1}}` placeholder).
- **No HTML comments in `## 安全`**: steering is loaded verbatim into agent context, so comments waste it. Remove any skeleton guidance comments in this section when writing; never add new ones.
- **Markers**: never touch the `steering-id: RL-f0bf` line under the file's title (it proves the file was loaded). Every rule bullet in `## 安全` starts with a rule ID `[S<n>]`, e.g. `- [S1] ...`. Keep existing IDs unchanged; a new rule takes the next unused number; IDs of removed rules are never reused; never renumber. Other sections' IDs (`[A<n>]`, `[T<n>]`, `[C<n>]`, `[D<n>]`) are not yours — leave them as they are.
- Keep each rule **concrete and decidable** for this stack (a reviewer can point and say pass/fail).
- **Write it short without dropping rules**: one line per rule; merge rules of the same category into one line when they share a subject (e.g. all deserialization bans); no rationale, evidence, or examples in the file — those stay in the Phase 1 audit. Shortening must not delete or weaken a confirmed rule; if merging rewrites an existing rule's wording, show it in the diff for my confirmation.
- Keep advice-level items out — if something failed the decidability test, it does not go here.
- Add only my confirmed extension rules.
- Do not restate the global "violation = blocker" clause if `red-lines.md` already carries it for the whole file; the 安全 rules inherit it. (If the file has no such clause, note that one line is needed and propose it — but that is a whole-file change, so raise it, do not silently add.)
- Takeover: known legacy security issues go to tech debt as drafts in my reply (for `/td-tech-debt register`), not embedded here as exceptions and not written to `docs/tech-debt.md` by you.

## Final Verification

Before finishing, verify:
- [ ] Only the `## 安全` section was changed; all other sections and the front-matter are untouched
- [ ] Enforcement Scope matches the case (greenfield / takeover) and is written on the `**适用范围**` line
- [ ] `## 安全` contains no HTML comments and no leftover `{{SECURITY_*}}` placeholders
- [ ] `steering-id: RL-f0bf` is unchanged; every rule in `## 安全` has a unique `[S<n>]` ID; no existing ID was changed or reused
- [ ] Every rule is concrete, decidable, and blocker-level — no vague advice leaked in
- [ ] One line per rule, same-category rules merged, no rationale or examples in the file — and no confirmed rule dropped or weakened by the shortening
- [ ] Stack-specific high-risk sinks were specialized only for languages the project actually uses
- [ ] Every rule was tested against the current code; each hit is either an exception written into the rule or a security-debt draft
- [ ] Risks that could not be made decidable were downgraded to anti-patterns, not written as red lines
- [ ] Takeover: known legacy security issues given as security-debt drafts in my reply, not force-fixed — with no write to `docs/tech-debt.md`
- [ ] I was invited to extend with project-specific security knowledge

Output a **Security-Baseline Summary**: the case, the Enforcement Scope, the specialized rule set, any user-added rules, and (takeover) any security-debt drafts handed to `/td-tech-debt register`.
