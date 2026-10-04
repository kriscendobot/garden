Implemented and pushed commit `939c6ea3df2` to `main2`.

- Added a durable arm epoch so historical PR backlog remains alert-only.
- Added bounded staging for post-arm bot-authored non-draft PRs: two attempts per tick, 180-second post timeout, idempotent gauntlet records.
- Failed or overflow staging falls back to deduplicated maintainer alerts.
- Increased audit cadence from hourly to every five minutes.
- Updated systemd units, documentation, role guidance, and regression fixtures.
- Verified with the readiness-audit regression test, systemd unit documentation test, `systemd-analyze verify`, calendar validation, shell syntax checks, and `git diff --check`.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-pr-gauntlet-readiness.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 317s

<!-- garden-usage-end -->
