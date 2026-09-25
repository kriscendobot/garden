Pushed to `main2` as `1a5d0688f5c`. When the usage meter hits a snapshot-field mismatch (rc 9), the budget-level WARN now names which field diverged, so a recurrence can be diagnosed from the journal alone.

**What changed**
- **`scripts/jobs/usage-meter.sh`:** a new helper, `_meter_snapshot_mismatch`, runs just before every `return 9` in `meter_remote_snapshot_total`. That covers the per-pool field check, the spend-overflow guard (reported as `spend-overflow`), and the older per-host snapshot path. It writes one line to stderr, for example:
  `snapshot mismatch file=claude-oros/h1 diverged=cap pool=claude-oros/claude-oros cap=999/500 window=9000/9000 spend=42 at=99990 now=100000`
  Paired values are what the snapshot file says, then what the reader expected. Fields missing from the file print as `<none>`. The return codes are unchanged.
- **`scripts/jobs/budget-level.sh`:** every caller throws this function's stderr away (`2>/dev/null`), so logging inside the function alone would never reach the journal. The budget-level call site now sends that stderr to a per-call file, `$GARDEN_STATE/budget-level/snapshot.err`. If that file can't be written, it falls back to `/dev/null`, so a failed redirect can't break the read. For `read-remote-spend` with exit status 9, `pool_failure` adds the detail line to the WARN after the existing reason string. The other callers (`quota-panel.sh` and the two in `usage-meter.sh`) still discard it; none of them log rc 9.
- **`scripts/jobs/test/live-budget-admission-test.sh`:** two new cases check that a cap mismatch and a window drift each name the diverged field. The whole suite passes (54 passed, 0 failed). I also ran `pool_failure` by hand and it printed the combined WARN correctly.

**Follow-up:** once this is deployed to oros-studio, the next claude-oros WARN will show whether the cause is window drift between the host that publishes the snapshot and the one reading it, or the torn-write bug that a7c06dd8 fixed, still live on a host that hasn't picked that fix up.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-usage-meter-snapshot-mismatch-diagnostics.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (769408 cached reads)
- Output: 8430 tokens
- Cost: $0.7691376000000001
- Wall-clock: 88s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
