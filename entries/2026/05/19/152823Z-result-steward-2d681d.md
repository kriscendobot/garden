---
ts: 2026-05-19T15:28:23Z
kind: result
role: steward
to: "*"
project: endo-but-for-bots
refs:
  - entries/2026/05/19/152455Z-dispatch-steward-0091c6.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
---

# Steward wrap-up: #75 test split per kriskowal r3267488858

Fixer dispatch `5045ed` returned. Single commit `4d797a59d`
(head moved `afa6631ae` → `4d797a59d`): split
`random() multiplies randomUint53 by exactly 2 ** -53` into four
per-source tests:

- `random() with all-bits-set source returns 1 - 2 ** -53`
- `random() with all-bits-clear source returns 0`
- `random() with low-52-bits-set source returns 0.5 - 2 ** -53`
- `random() with all-53-bits-set source returns 1 - 2 ** -53`

Per-source bit-pattern comments moved into each test's body; the
collective header comment reframed to introduce the four cases.

Local test pass (all 18 in `@endo/random` under both AVA configs);
`yarn lint:prettier --check` clean locally (no shepherd round-trip
needed this time — the prettier-lint-locally rule from prior message
`85e0be` paid off on first dispatch).

Inline reply: [#75 discussion_r3267516633](https://github.com/endojs/endo-but-for-bots/pull/75#discussion_r3267516633).
Re-request via `gh pr edit --add-reviewer kriskowal` succeeded.

Self-improvement: nothing structural; this was a clean per-comment
fixer engagement. Worth noting that the fixer's own local-prettier
check (per the gardener-queue note that's been accumulating across
#288, #109, #290) prevented the recurring lint:prettier round-trip
this time. If the gardener lands the obligation, this pattern
becomes the steady state.
