**Verdict: degraded.** oros is up and claiming work, but its journal git operations keep timing out under load, and it is still on `78f9dacc`: no deploy has landed today.

**Landed on main2, each with tests:**
- **`5ec392b0`:** the hourly clone maintenance now also removes clone dirs left behind by killed processes. I found 12 of them (3.0 GB, about 193k inodes, the oldest from 10-01) and removed the 10 dead or old ones by hand.
- **`cc0fa2a2`:** when a journal clone syncs, its reset to origin now gets its own 900s budget instead of the 120s git wrapper limit. A clone that falls far behind was being killed every tick and could never catch up.
- **`eedd785f`:** the scaler no longer treats a tick with no budget snapshot due as recovery from a failed publish. That bug logged false "recovered" messages and kept resetting the outage clock, so the 30-min re-clone recovery and the stale-snapshot alert could never fire.

The tests for these pass, except the slow multi-host publish-retry test: it never finished in either session, so it is unverified. It doesn't use the changed scaler path.

**Changed on the host:** removed those orphaned clone dirs and ran `daemon-reload` and `reset-failed`.

**Health log:** the main note is journal2 commit `d6e0c400` and a 09:06Z addendum is `e3910869`. The producer clone was tied up by self-deploy, so I wrote both commits directly onto journal2 from my worktree instead of through `land-journal-edit.sh`.

**What blocks the deploy:**
- Every attempt passes its test gate (04:51, 05:48, 07:09) and then defers on some monk job that has run longer than 300s.
- Twice (05:48 and 06:39) that job was this checkup's own first session on monk 6. It hung for about 3h after writing its report, until it was reaped.
- At 07:09 it was monk 1. Since 09:01 self-deploy has been holding with no leader release (it treats the leader as absent) at the last leader-validated version, `9affc0d6`.

**Needs a person:**
1. With 8 monks, the 300s long-job threshold almost never sees a quiet moment, so the threshold or deferral policy needs your decision. This checkup itself is a long job that defers the deploy every 3 hours.
2. Five units are still failing: state-clone-keeper, library-link-scan, regenerate-sections-index, regenerate-topics-counts and worktree-sweeper. All die on the 120s reset limit that `cc0fa2a2` fixes, and the monitor journal clones still time out at 300s (`75b15068` fixes those). Neither fix helps until oros actually deploys.
3. Find out why the first session's handler kept running after it wrote its report and completion signal.
4. Claim timeouts and heartbeat push losses are still the journal contention diagnosed on 10-01.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261012-030519.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 10 tokens (785392 cached reads)
- Output: 3138 tokens
- Cost: $5.9438376 (1 engagement(s) unpriced)
- Wall-clock: 3703s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
