Implemented and opened draft PR https://github.com/kriscendobot/minion.town/pull/151 at commit `dcc2d64`.

- Added JavaScript-only script policy, contributor guidance, transition allowlist, and CI guard.
- Added shared AWS/SSM JavaScript helper.
- Converted and updated all callers/docs for the five scoped scripts.
- Added unit and regression coverage; regenerated vendored provenance.
- Verified `npm test` (806 passed, 10 skipped), typecheck, pre-push probes, and all three PR CI jobs, including both Docker architectures.
- No live deployment or SSM action was performed.
- Follow-up: parts 2/3 should shrink the transitional allowlist and ultimately delete `common.sh`.
- Local verification intermittently hit an unrelated existing `projectPartition` test race; the test passed isolated, direct full suites passed, and PR CI is green.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1119s

<!-- garden-usage-end -->
