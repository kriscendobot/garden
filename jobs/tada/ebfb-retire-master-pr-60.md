The sweep completed cleanly. No garden-library (main2) changes were needed — all work was on the project repo.

## Completion report: retire master base for endojs/endo-but-for-bots#60

**Verified preconditions.** PR #60 (`test(ses): replace deleted get-intrinsics test (closes #390)`) is OPEN and was targeting the moving `master` base. Author kriscendobot; head branch `design/issue-390-intrinsics-test` lives on endojs/endo-but-for-bots.

**Base SHA from upstream.** Took the base SHA from upstream **endojs/endo** master (the `endo` remote on the bare clone), not the fork master: `46d4edf31714c1488ec1d95492cc1ae9643c1f9f`. The endo-but-for-bots (fork) master `fcbb540` is deliberately *not* used.

**Reflection branch — reused.** `master-46d4edf` already existed on the fork and pointed exactly at endo master `46d4edf` (also the base of open PR #779), so I reused it rather than creating a duplicate.

**Rebase.** The PR is 3 self-contained commits adding one new file `packages/ses/test/get-intrinsics.test.js` (+351 lines) on top of the reflection commit `eecc683`. Rebased only those 3 commits with `git rebase --onto origin/master-46d4edf eecc68394ba …` — conflict-free (the new test file exists in neither base). New head: `488646a2b3b`.

**Push + base edit.** Force-with-lease pushed the rebased head (guarded on the prior tip `eddd7c2`); set the PR base to `master-46d4edf` via `gh pr edit`.

**Result.** PR #60 is OPEN, base `master-46d4edf`, head `488646a`, **MERGEABLE**, and its diff is exactly the one intended test file. No conflict, no touch to the fork `master`, no garden-library changes to commit.

**Follow-up for the maintainer (non-blocking):** PR #60 is moderately idle (created 2026-04-27, last content activity 2026-07-02) but is a genuine test PR, not a stale mirror, so I completed the sweep rather than skipping it. Worth a look for merge/close if it has been superseded.
