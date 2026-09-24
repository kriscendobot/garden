Fixed and pushed to `main2` as `a422219ebc9`: a failed remote-spend read for a subscription-mapped pool like `claude-oros` now logs a real reason instead of `reason=unknown`.

**What was wrong.** There were two causes:
1. `meter_remote_snapshot_total` (`scripts/jobs/usage-meter.sh`) returned `1` for every kind of failure.
2. Even with distinct codes, the WARN would still have said "unknown". In `budget-level.sh:176`, the non-`anthropic:*` branch passed `"$?"` to `pool_failure`. At that point `$?` held the result of the `[[ "$pool" == anthropic:* ]]` test, which is always `1`, not the snapshot read's result.

**What changed:**
- **`meter_remote_snapshot_total`** now returns a different code for each cause. The numbers don't overlap with the journal reader's 2–5, so one reason function covers both:
  - `6`: no live snapshot dir or file for the pool, or none readable
  - `7`: snapshot older than `max_age`, or dated in the future
  - `8`: the number of hosts with snapshots doesn't match the mapping
  - `9`: pool, cap or window doesn't match, or spend/timestamp isn't a number

  The old checks that lumped staleness in with field mismatches are split, in both the per-pool path and the legacy host-keyed path.
- **`meter_journal_failure_reason`** now maps 6–9 to short reason strings (`no-snapshot for pool`, `stale-snapshot beyond max-age`, `snapshot-host-coverage-mismatch`, `snapshot-field-mismatch (pool/cap/window/spend)`).
- **`budget-level.sh:176`** now saves the snapshot read's exit code in `snap_rc` and passes that to `pool_failure`. The `anthropic:*` fallback to the journal still reports the journal's own code.
- **Tests:** `scripts/jobs/test/live-budget-admission-test.sh` now covers exit codes 0, 6, 7, 8 and 9 and the new reason strings. It passes 48/0. `subscription-budget-model`, `budget-snapshot-publish-retry`, `budget-snapshot-warning-dedup`, `quota-panel`, `alert-maintainer-edge` and `proportional-worker-leveling` also pass.

**Follow-up:** once this deploys, the next `claude-oros` WARN on `oros-studio-garden-ce242c49` will name the actual cause. Stale (`7`) or host-coverage (`8`) would point at that pool's snapshot publisher rather than at this reader.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-remote-snapshot-failure-reason.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (580397 cached reads)
- Output: 7080 tokens
- Cost: $0.6570874000000001
- Wall-clock: 86s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
