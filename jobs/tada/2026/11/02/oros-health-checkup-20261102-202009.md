**Verdict: degraded (disk only).** Oros itself is otherwise fine, and I fixed a budget admission bug that affects the whole fleet.

**Snapshot (recorded in `oros-health-log.md`)**
- **Load and memory:** load is about 3, with 12.7 GiB of memory available. Swap is full, as in earlier runs.
- **Disk:** the garden mount has 57.4G free (88%), flat since 17:31Z. The cause of the earlier growth is still unknown.
- **Units and workers:** no failed units, and 4 monks running with no drain or derotation marker seen.
- **Deploy:** oros is on `9f4eb64`, status `deployed`. My fix (`e97673a`) is on main2 but not rolled out yet, so there is no deploy to help along.
- **Timeouts:** no rc=124 or rc=137 in the last 3 hours.
- **Budget meter:** pushing normally, about every 15 minutes. Spend has been flat since at least 18:18Z because oros has had almost nothing it can claim.

**What I changed (`e97673a` on main2)**
- **Admission bug:** `subscription_used_percent` splits about 11k usage files into 8 `jq` batches but read only the first batch's result.
    - **Effect:** in scripts on oros that batch had no samples, so utilization read as unknown and admission fell back to the token estimate. `claude-endolin1` read `ok` at about 35% when its real figure is 70%, which puts the 90% quota policy at risk.
    - **Fix:** it now takes the newest sample across all batches, and the same script reads 11% for `claude-oros` and 70% for `claude-endolin1`.
    - **Impact so far:** I found no overspend, since endolin's declines and flat spend suggest it read correctly, but I can't see its reads from here. Hosts that were reading unknown will now gate on real utilization, which is stricter when the estimate runs low.
- **Misleading notice:** `requirements-watch.sh` told the maintainer to provision a capability for jobs that were only waiting on budget pacing. It now names the backed-off pool.
- **On-host cleanup:** nothing was needed, so I removed no files and touched no units, drains, leveling or schedules.

**Tests**
- **New and updated:** the new `subscription-used-percent-batches-test.sh` passes 4 of 4, and 2 of those fail without the fix. `host-requirements-gating-test.sh` passes 17 of 17.
- **Already failing:** `live-budget-admission-test.sh` has 4 failures, the same four cases without the fix. `budget-live-percent-label-test.sh` has 1 failure with and without it.
- **Did not finish:** `subscription-used-percent-per-subscription-test.sh` passed its first 6 cases, then hung past 110s at the snapshot publish step, which I didn't change.

**For the maintainer**
1. **Unused oros quota:** oros has 89% of its week unused, and it resets around 10–11Z on 11-03. It sits mostly idle because its PAT can't write PRs on endojs, and those PR-opening jobs are waiting on endolin. Whether to spend that quota is your call.
2. **Watcher gap:** 9 jobs pinned to endolin are stuck because its budget pools are at high water, including three `oros-health-watch` runs, so nothing has watched oros since at least 13:50Z. This is pacing working as configured, and I estimate endolin's monks resume near 22:40Z. Even so, a watcher pinned to the leader stops whenever the leader is backed off, so the schedule needs a design decision.
3. **Disk:** someone at the Mac should still find what used the shared disk.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261102-202009.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (3530142 cached reads)
- Output: 42607 tokens
- Cost: $2.6378083999999995
- Wall-clock: 2502s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
