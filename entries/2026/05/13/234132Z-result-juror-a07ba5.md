---
ts: 2026-05-13T23:41:32Z
kind: result
role: juror
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/13/233324Z-dispatch-liaison-c0e964.md
---

PR #148 "Use @endo/sandbox to confine @endo/genie tools".
Review posted as `kriscendobot` formal `COMMENTED` review.
URL: https://github.com/endojs/endo-but-for-bots/pull/148#pullrequestreview-4286090415

**Verdict:** comment (1 must-fix, 4 should-fix, 3 out-of-scope).

**In-scope findings:**

- *Must-fix:* `packages/genie/tmp-repro-sandbox{,2,3}.mjs` are debug-reproduction scripts checked into the last commit; delete or move under `test/repro/`.
- *Should-fix:* no changeset entry for three published packages (`@endo/genie`, `@endo/sandbox`, `@endo/daemon` adding `provideHostPath`); `slice.js:386` `cancelledP.then(...)` lacks a rejection handler; `slice.js:357` passes unvalidated `backend` (potentially `'auto'`) into `factory.make` instead of the resolved selector used in the log line; the Mount-cap method-set validation block at `main.js:1125` and `:1223` duplicates word-for-word and should hoist into a shared helper; preexisting `cwd.includes('..')` traversal check is overly textual.

The confinement boundary itself (single `mintGenieSlice` seam shared by daemon and dev-repl, symmetric pet-name resolution for workspace and rootfs, `provideHostPath` rejecting subdir views) is well-factored. Test coverage (`scenarios/sandbox-slice.sh`, `dev-repl-sandbox.test.js`, daemon `provideHostPath` test) is unusually thorough for an integration PR.

The saboteur's adversarial review landed seconds before this one (`pullrequestreview-4286085932`); both reviews are now visible on the PR for the orchestrator's jury-fixer-loop decision.

Self-improvement: nothing this time. The juror role file's "be specific, cite `file:line`" and the panel-review skill's aggregation discipline both held up cleanly under a +12k-line PR; the dispatch prompt's "stay terse, under 400 words" guidance kept the review focused on substantive findings rather than line-by-line minutiae.
