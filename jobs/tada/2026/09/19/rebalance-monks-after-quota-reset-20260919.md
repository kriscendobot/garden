Rebalanced the two-host monk fleet:

- `endolin-garden-ece02cb4`: 1 → 4 monks; scaler reconciled and four units are running.
- `endolin-garden2-5bcdff64`: 1 → 2 monks; remote sysop acknowledged `accepted-and-applied`, and the journal declaration shows 2.
- Allocation was verified from fresh reset-window samples and the calibrated 143M:64M proportional-capacity rule.
- Clerics remained 1 per host; no foreman-brake or unrelated-host state changed.
- Reported evidence on [issue #89](https://github.com/kriscendobot/garden/issues/89#issuecomment-5745227434).
- Follow-up: automatic leveling remains frozen because `oros-studio-garden-ce242c49` lacks a physical-cap row in `config/worker-leveling`.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/rebalance-monks-after-quota-reset-20260919.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 297s

<!-- garden-usage-end -->
