---
arc: endo-backlog
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Fix endojs/endo-but-for-bots PR #1538 (https://github.com/endojs/endo-but-for-bots/pull/1538) on `build/daemon-git-clone`: apply the REMAINING round-six panel findings from review 5635752238 (https://github.com/endojs/endo-but-for-bots/pull/1538#pullrequestreview-5635752238).

Already done by fix-six at 17884689de: the locksmith/saboteur must-fix (recorded-identity re-checks for the staging directory in `provideGitClone` and `moveMountEntries`), and saboteur should-fix 2 (truncated record) and 3 (leaked staging directory).

Still open: saboteur 4 (`renameNoReplace` non-atomic for non-directories), breaker, integrator (stale PR description), changeset-auditor/releaser (split changesets per package, migration first, drop @endo/floot), pruner, corner-prober (driver `kill(signal)` must preserve signal semantics, must-fix-loop), coverage-auditor 1-3 (must-fix-loop, including a test for a swapped staging directory), and decomplector 1-2 (consider daemon-private staging instead of in-mount staging, which would also close the residual check-then-use window locksmith noted). Note: daemon tests cannot start locally on endolin-garden-ece02cb4 (better-sqlite3 ABI mismatch); verify via CI.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-24T01:33:58Z
