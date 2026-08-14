Implemented and pushed commit `9a83934b5e` to `main2`.

- `set-schedule.sh` now automatically attaches and preserves `dependabotany-preflight.sh` for `dependabotany-recheck-*` schedules.
- Updated botanist and schedule documentation.
- Added regression coverage for automatic attachment, preservation, and scope.
- Migrated the live `dependabotany-recheck-endo-but-for-bots` schedule while preserving its cadence, body, and `last_dispatched`.
- Verification: preflight tests passed 14/14; main suite passed 372 tests with one unrelated issue-inbox fixture failure.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-dependabotany-preflight-default.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 359s

<!-- garden-usage-end -->
