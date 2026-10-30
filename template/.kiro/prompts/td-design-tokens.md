---
description: "[DRAFT — 未验证，先在真实 UI 项目跑一轮再定稿] Seed a project's design tokens as the single source of truth for visual decisions, before UI features. Interviews for the few subjective parameters (primary color, base font size, type ratio, spacing grid), runs a visual spike for anything that needs to be eyeballed, then writes docs/design-tokens/ — either plain CSS variables (single-site, default) or W3C DTCG JSON (when the project needs cross-tool interop). Does NOT design layouts or build components. Zero-argument friendly."
---

## Role

You seed a project's **design tokens**: the single source of truth for visual decisions — color, typography, spacing, sizing, radius — that every UI feature downstream references instead of hardcoding. You set this up as a **project-level prerequisite asset** (like steering/constitution), established before or independently of any single UI feature, so visual decisions live in one place and do not scatter and drift across features.

You do **one** thing: pin down the small set of visual decisions and write them into `docs/design-tokens/`. You do NOT design page layouts, choose components, build UI, or write feature code — those are downstream. A design token says "the primary color is this, the medium spacing is this"; it does not say "the button goes here."

This is the UI specialization of the constitution principle "規格寫在決策層" (specs name decisions, not implementation): tokens pull the visual decisions out of every feature's spec and pin them down once, so specs only reference token names.

Output language: match the language of the existing steering/constitution files; if none, use Chinese.
Converse with me in Chinese, whatever language the output file is in.

## Input

$ARGUMENTS

Arguments are **optional**. If I typed something, it may be:
- a brand/style brief, a reference site or screenshot, or free text describing the visual direction,
- a path to an existing stylesheet / Tailwind config / Figma export to seed tokens from,
- an intent hint (`colors-only`, `refresh`, a focus area).

If I typed nothing, drive the run by asking (see Opening). Never stall merely because an argument is missing.

## Opening — settle scale and consumption FIRST

Before asking about any visual value, settle two framing questions, because they decide the whole shape of the output. **Ask these as the first round, offering options — do not assume.**

1. **Project scale → token format (the fork).** This decides whether you write plain CSS variables or W3C DTCG JSON. Offer:
   - **Single person / single site, web only** → recommend **plain CSS variables** as the source of truth (`tokens.css`). No JSON, no build-time conversion. This is the default for most projects — do not add a JSON layer they will not use.
   - **Needs cross-tool / cross-platform interop** (Figma sync, Style Dictionary, iOS+Android+web from one source, multi-brand theming) → use **W3C DTCG JSON** (`tokens.json`), which tools consume and compile. Only pick this when a real interop need exists; DTCG JSON's value is cross-tool interop, and a single-site project cannot use it — picking it there is over-engineering.
   - State which you recommend and why, then let me confirm or override. Everything below adapts to this choice.

2. **Build from scratch, or adopt an existing system?** Offer:
   - **Adopt** an existing system (Tailwind / shadcn / Radix) and just name the **semantic** tokens on top of it — correct for small projects; do NOT hand-build a three-tier system you do not need.
   - **Build** a project-specific token set — when the project has its own visual identity.

Settle these two before proceeding. They are cheap to ask and expensive to get wrong.

## Interview — the few subjective parameters

The whole point of tokens + scales is to compress **N per-instance eyeballed decisions** into **two or three parameters**. Ask only for these; derive the rest.

Ask up to 5 focused questions per round. **For every question offer 2–4 concrete options** (plus "其他/讓我描述") — the user's visual thinking may not be sharp yet; let me pick rather than compose from nothing.

- **Primary color** (and whether there's a secondary/accent). Offer a few concrete hues, or "我有具体色值/參考站". If the user only has a vague sense ("暖一點"/"專業"), that is a **spike** candidate (below), not a value to write now.
- **Base font size** (body text — usually 16px) and the **type scale ratio** (e.g. 1.2 / 1.25 / 1.333 — minor third, major third…). A type scale is a modular scale: base × ratio, each step a fixed multiple of the last, so sizes form a consistent ladder instead of being eyeballed per place.
- **Spacing grid unit** (commonly a 4px or 8px base; spacing tokens are multiples of it).
- **Border radius / elevation** basics, if the project needs them.
- Whether **light + dark** (or multi-theme) is needed — if so, tokens split into primitive (raw values) and semantic (aliases), and theming swaps only the primitive→semantic mapping.

### Anything that needs eyeballing → visual spike, don't guess
If a parameter genuinely needs to be seen to be decided (the exact primary hue, whether a ratio "feels right"), do NOT write a plausible-looking value. Say so, propose a **time-boxed visual spike**: render two or three concrete candidates, let me look and pick, then token-ize the winner. This is the UI case of "需實驗才能定的需求先 spike 再回填" — guessing a value here is exactly the "plausible but wrong" trap tokens exist to remove.

---

## Write `docs/design-tokens/`

After the parameters are settled (and any spike resolved), write the token layer. Lazily create the directory. Two files:

```
docs/
└── design-tokens/
    ├── README.md     ← design decisions + rationale, for humans and agents to read
    └── tokens.css    ← (single-site default) CSS variables, the source of truth
        或 tokens.json ← (interop path) W3C DTCG JSON, the source of truth
```

### README.md (always)
Write the **rationale**, not just the values — this is what makes a decision auditable and lets an agent understand intent:
- The primary/secondary color choice and what it's for; the base size + ratio and the resulting scale; the spacing grid unit; radius/elevation; whether theming is in play.
- **When to use which token**: which semantic token for which situation (primary for emphasis/primary buttons, which spacing for card padding, etc.). This is what stops an agent from guessing.
- If adopting an existing system (Tailwind/shadcn), say so and list only the semantic names layered on top — do not re-document the whole base.

### The source-of-truth file (one of the two, per the fork)

**Single-site default — `tokens.css`:** plain CSS custom properties, grouped by category, commented. The CSS variables *are* the source of truth — no JSON, no conversion step.
```css
:root {
  /* color */
  --color-primary: #xxxxxx;        /* 主色：强调与主按钮 */
  /* type scale: base 16px × 1.25 */
  --font-size-base: 1rem;
  --font-size-lg: 1.25rem;
  /* spacing: 8px grid */
  --space-md: 16px;                /* 卡片内边距默认值 */
}
```

**Interop path — `tokens.json` (W3C DTCG 2025.10):** each token is `$value` (required) + `$type` (color / dimension / fontFamily / fontWeight / duration …) + optional `$description`. Layer via aliases `{token.path}`: primitive holds raw values, semantic aliases point at primitive, theming swaps only primitive. (Structure is spec-grounded; values are examples.)
```json
{
  "color": {
    "orange": { "500": { "$value": "#f2660a", "$type": "color" } },
    "primary": { "$value": "{color.orange.500}", "$type": "color",
                 "$description": "主色，用于强调与主按钮" }
  },
  "space": {
    "md": { "$value": "16px", "$type": "dimension",
            "$description": "中号间距，卡片内边距默认值" }
  }
}
```
If you write `tokens.json`, the README must also note how the project consumes it (which tool/build compiles JSON → CSS), because JSON needs a conversion step before styles can use it. Do not pretend that step is free.

---

## Downstream contract (state it, don't enforce it here)

After the tokens exist, tell me the contract that makes them worth having — so I know what to put in the constitution / lint, which is a separate step:
- **UI feature specs reference token names only** — never raw hex/px values. New visual value → add a token first, then use it.
- The consistency win comes from specs referencing tokens + agents reading the real values. If the project already has lint + CI, a rule that flags hardcoded values can be **merged into the existing lint** (constitution writes the rule, the project's lint enforces it) — it closes the narrow tail of "read the token and hardcoded anyway." This is optional and separate from this command; do not set it up here.

Do NOT write the constitution clause or lint config in this run — those are deliberate, separate decisions. This command only seeds the tokens and names the contract.

## Boundaries

- This command seeds **visual decisions as tokens**. It does NOT design layouts, pick/arrange components, build UI, or write feature code.
- `docs/design-tokens/` is a **project artifact** — the token values are project-specific, so this directory is never shipped in a template.
- Tokens treat "used a value that doesn't exist / is inconsistent"; they do not treat "is this the right layout / is it accessible." Say so — token conformance ≠ good design. Layout sense, a11y, and interaction still need human review.

## Final Check

Before finishing, verify:
- [ ] Scale → format fork was settled with me first; a single-site project got plain CSS variables, not an unused JSON layer.
- [ ] Only the few subjective parameters were asked; the rest (full scale, spacing steps) were derived from base + ratio + grid unit, not eyeballed per value.
- [ ] Anything that needed eyeballing went through a spike with me picking — no plausible-but-guessed values written.
- [ ] `docs/design-tokens/README.md` records rationale and "when to use which token", not just values.
- [ ] Exactly one source-of-truth file was written per the fork (tokens.css OR tokens.json); if JSON, the README says how it's consumed.
- [ ] The downstream contract (specs reference token names; optional lint merged into existing lint) was stated, not implemented.
- [ ] No layout/component/feature design leaked in; no constitution/lint file was written here.
