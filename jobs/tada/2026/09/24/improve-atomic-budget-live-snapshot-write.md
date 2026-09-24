Both snapshot publishers now write atomically, and `meter_remote_snapshot_total` can no longer exit with the undocumented status 1. The fix is pushed to `main2` as `a7c06dd8217`.

**What changed in `scripts/jobs/usage-meter.sh`:**
- **Atomic writes.** Both publishers (the legacy `budget/live/$GARDEN` write and the per-pool `budget/live/<pool>/<host>` write) now write to `$file.tmp.$$` and then `mv -f` it into place. So a reader can no longer see a truncated snapshot. Two cases of the old race:
  - A file cut off before its later fields got the `snapshot-field-mismatch` (rc 9) WARN.
  - A file cut off partway through the spend line looked valid and was read as a smaller spend, with no warning.
- **Reader skips in-flight files.** The per-pool loop now ignores `*.tmp.*` files in the pool directory, so a write in progress is never counted as a host's snapshot.
- **Where the status 1 came from.** Values like `spend: 08` pass the old `^[0-9]+$` check, but bash treats a leading zero as octal and fails on `$((total + s))`. A value too long for 64 bits breaks the arithmetic the same way. Either one makes the function exit with status 1, which matches the `reason=unknown` WARN. I found this by reproducing the arithmetic failures in a small standalone bash script, not by running the old `usage-meter.sh` against these inputs.
- **The fix for it.** Spend, sample time, `now` and the host-mapping count must now be a plain decimal of at most 18 digits (no leading zeros). A bad value returns rc 9, or rc 8 for a malformed mapping count. There is also an overflow guard before adding to the running total, and `GARDEN_BUDGET_SNAPSHOT_MAX_AGE` has the same length limit.

**Tests:** I added four cases to `scripts/jobs/test/live-budget-admission-test.sh`:
- a leading-zero spend returns rc 9
- a 20-digit spend returns rc 9
- a snapshot cut off partway through returns rc 9
- an in-flight tmp file is ignored (rc 0)

That suite now passes 52/52. These budget tests also pass: `budget-snapshot-publish-retry`, `budget-snapshot-warning-dedup`, `subscription-budget-model` and `meter-journal-cutoff`.

**Follow-ups:** The fix only takes effect on each host after its next deliberate deploy. That includes oros-studio, since every host publishing to the same file needs the new writer. Until then, occasional `snapshot-field-mismatch` WARNs from hosts that haven't updated yet are expected.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-atomic-budget-live-snapshot-write.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (470427 cached reads)
- Output: 7318 tokens
- Cost: $0.6660694
- Wall-clock: 90s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
