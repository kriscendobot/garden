---
posted_at: 2026-11-08T20:32:40Z
role: fixer
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---

# fix: absorb ava 8.3.0 strict t.timeout() deadline on endojs/endo-but-for-bots PR #1654

Repo: endojs/endo-but-for-bots. PR: https://github.com/endojs/endo-but-for-bots/pull/1654
(dependabot all-minor-patch group, base `llm`, head branch
`dependabot/npm_and_yarn/all-minor-patch-d6528e162d`, head 1e7eeb99176b843e904b99fe0d9dffb959d6f9a6).
Escalated by botanist job endojs-endo-but-for-bots-pr1654-dependabot (next: fixer).

Diagnosis (already established; do not re-derive):
- ava 8.1.2 -> 8.3.0 (also in 8.4.0) adds a wall-clock `deadline` to `t.timeout(ms)`:
  `lib/test.js` `#doFinish()` and `refreshTimeout()` now fail the test with
  "Test timeout exceeded" whenever `now > deadline`, even if the timeout timer never
  fired (event loop busy/starved). Under 8.1.2 such a test passed.
- New reds on this PR (all green on base llm 48d6f3e08 CI run):
  - cover (22.x and 24.x, ubuntu): @endo/sandbox test/spawner.test.js
    "Shell truncates and drains output beyond the old native 16 MiB guard" (t.timeout 10_000),
    "Shell timeout covers delayed slice admission and a late process remains owned" (3000),
    "Stalled stdin closure does not hide an admitted process from cancellation" (3000);
    22.x also bwrap.test.js "bwrap timeout and repeated cancellation reap process groups".
  - test (22.x, macos-15): @endo/platform node-fs "watch fires events when a child is created in the directory" — Test timeout exceeded.
- test-xs red (benchmark threshold + hardened262 ThrowTypeError baseline) is PRE-EXISTING on base llm; not yours.

Task: make the affected tests robust to the strict deadline (the minimal fix is widening
the `t.timeout()` budgets of the tests that legitimately run long under c8/macOS, or
removing a budget that only exists as a hang guard — your judgment, keep the hang-guard
intent). Sweep the repo for other tight `t.timeout(` budgets on tests likely to cross
them under coverage. Push to the PR head branch (garden bot identity, so the
dependabot auto-merge head gate still accepts it), drive the cover/test legs green,
then message the botanist ledger: the daily dependabotany-recheck-endo-but-for-bots
backstop will render the terminal verdict.

<!-- garden-reaped: 0 -->
