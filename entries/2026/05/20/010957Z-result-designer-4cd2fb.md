---
ts: 2026-05-20T01:09:57Z
kind: result
role: designer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/307
  - PRR_kwDORRE4FM8AAAABAbyZXw
---

Revised `designs/patterns-diagnostic-feedback.md` on `design/patterns-diagnostic-feedback` per kriskowal `CHANGES_REQUESTED` review on PR #307 (6 inline asks orbiting a single load-bearing redesign: build a separate lane for rich diagnostic matching rather than carry detailed diagnostics through the existing matcher path).

**Investigation finding on `applyLabelingError`** (the maintainer's open question, comment 3270362266): `applyLabelingError` in `@endo/common/apply-labeling-error.js` already records the full per-level labeled cause chain when a nested match fails. It wraps the inner Error in an outer Error whose `.message` is `"${label}: ${innerMessage}"` AND annotates the outer via `annotateError(outerErr, X\`Caused by ${innerErr}\`)`. `annotateError` is SES's `assert.note`: it attaches a hidden details record (via a SES-internal weakmap) that the SES console surfaces at log time but that is **not** present on `err.message` or any enumerable property. So the matcher already produces (for a six-level-deep failure) a six-link annotated cause chain plus the flat colon-joined message; `@endo/exo`'s argument labeling composes through the same chain. The gap is not that the matcher fails to record the path. The gap is that the recorded chain is held in SES-private weakmaps, in a string-only label format with no step-kind discrimination, with no combinator-aware renderer, and `M.or` discards branch attempts at the disjunction. The maintainer's intuition that "the implementation exists but the maintainers failed to notice its potential for agents" is essentially correct.

**Redesign shape**: replaced the three-axis carry-on-error design with a single separate-lane proposal: a new sibling package `@endo/patterns-diagnose` whose single export `diagnose(err, { specimen, pattern }): string | undefined` returns a multi-line Rust-compiler-style indented ASCII-line-art report (or undefined when there is nothing useful to add). The production `@endo/patterns` matcher path stays bit-identical; callers that want rich diagnostics import the sibling package and pay; callers that do not, do not. The renderer is a line-by-line emitter (no template literal), reports every `M.or` alternative ranked by depth (no configurable closest-alternative heuristic), and uses `|`, `+`, `-` ASCII line-art so it renders correctly in every terminal and log. The tracing matcher mirrors `confirmMatches` recursion; the chain-walk fallback (for callers without the original specimen + pattern) is Phase B and deferrable. The text-source parse axis (old Axis C) was deferred as a separable concern (its own front-end language deserves its own design).

**Commits** (pushed to `origin/design/patterns-diagnostic-feedback`):
- `87dc4908` — `designs(patterns-diagnostic-feedback): separate-lane redesign per kriskowal review` (478 inserts, 348 deletes on the design doc)
- `c0e56923` — `designs(patterns-diagnostic-feedback): sync designs/README.md to separate-lane redesign` (see-also blurb, summary-table status, milestone size/duration recalibrated S-M / 2-3 days)

**Per-inline disposition** (all 6 threads replied + top-level summary posted at https://github.com/endojs/endo-but-for-bots/pull/307#issuecomment-4493600653):
- 3270346825 (line 407, *new lane*) → reply 3270656034, addressed by 87dc4908.
- 3270347987 (line 433, *also avoided*) → reply 3270656452, addressed by 87dc4908.
- 3270351680 (line 442, *return path + indentation + line-art*) → reply 3270656867, addressed by 87dc4908.
- 3270354786 (line 449, *no template literal*) → reply 3270657235, addressed by 87dc4908.
- 3270357548 (line 454, *no configurable heuristic*) → reply 3270657500, addressed by 87dc4908.
- 3270362266 (line 462, *applyLabelingError investigation*) → reply 3270658845, addressed by 87dc4908 (investigation lands as the design's opening section).

**Push result**: `origin/design/patterns-diagnostic-feedback` updated 65dab647a..c0e569236. `prettier --check designs/` passes. The design is ready for the maintainer's next pass; not un-drafting (the steward will if appropriate).

Self-improvement: nothing this time.
