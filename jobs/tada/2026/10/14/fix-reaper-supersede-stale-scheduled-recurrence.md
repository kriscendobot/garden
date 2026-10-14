Implemented and pushed commit `d82f327af50` to `main2`.

- Reaper now retires stale recurring dispatches to `tada` as `status: superseded` when a newer same-schedule dispatch exists in todo/doin/tada.
- Added `interchangeable: false` schedule opt-out, preserved by scheduler and `set-schedule.sh`.
- Added focused regression coverage for newer dispatches in all three lifecycle states and opt-out behavior.
- Verified focused reaper test, reaper doom/cap tests, scheduler admission tests, and handler-timeout tests. Broad suite encountered unrelated concurrency/scaler-log failures and was stopped.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-reaper-supersede-stale-scheduled-recurrence.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1167s

<!-- garden-usage-end -->
