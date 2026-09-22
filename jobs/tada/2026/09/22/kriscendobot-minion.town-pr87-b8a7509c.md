Implemented the repo-wide Vitest migration in draft PR https://github.com/kriscendobot/minion.town/pull/107, commit `7a613ac`.

- Migrated the remaining 49 SIWE and Claude harness tests from `node:test`.
- Added Vitest dependencies/lockfiles and CI coverage for both packages.
- Local checks passed: 49 migrated tests, 428 root tests with 5 skipped, typecheck, and harness pin check.
- CI’s new Vitest steps passed. Overall CI remains red from an unchanged live-daemon test that failed differently on two attempts, indicating an existing flake.
- Posted completion details on PR #87.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr87-b8a7509c.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (1 unmetered)
- Input: 66 tokens (2142859 cached reads)
- Output: 41349 tokens
- Cost: $3.5131335000000004 (1 engagement(s) unpriced)
- Wall-clock: 1844s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
