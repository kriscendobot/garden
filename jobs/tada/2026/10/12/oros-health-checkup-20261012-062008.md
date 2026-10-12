**Verdict: degraded.** oros is still running `78f9dacc`, 14 commits behind main2 (`3935f665`). The deploys stalled because the leader never learned oros was waiting on long jobs. I fixed that on main2.

**Snapshot (06:55–07:40Z):**
- **Load and memory:** load peaked at 9.1 and settled to 5.1. 12 GiB of 15.6 GiB is available.
- **Disk:** 6% used, inodes 1%. Up 10 days 14 hours, no recent reboot.
- **Deploy attempts:** the leader released oros for `563e6db8`. Self-deploy tried at 06:23 and 06:59, and both times it held back behind long jobs (monk 6 at 8822s, then monk 1 at 2921s). The 06:08 tick hit the 2400s handler timeout.
- **Unit failures:** 5 at 06:55: state-clone-keeper, library-link-scan, regenerate-sections-index, regenerate-topics-counts and worktree-sweeper. They are journal-git timeouts under load, and their fixes are on main2 but not yet deployed. All were clear by 07:39.
- **Budget heartbeat:** pushes are landing but with gaps of 31 and 19 minutes. Spend is 31% of the weekly cap, status ok.
- **Workers:** 8 monks, not drained, no derotation marker.
- **State clones:** repacks of the four clones with the most packs (54–77) timed out at 120s. There are no orphaned clone directories and no stale held locks.
- **Timeouts:** 290 rc=124 in the last 3 hours, mostly per-monk journal clones.

**Root cause and fix:**
- **Why the leader never quiesced oros:** from 02:39 to 07:36, every attempt to publish the "deferred" status failed. The status write shared the host's general journal clone with job posting and other journal edits. That clone's lock had waits of about 100s and one holder of 300s, so the publish gave up every time. Without that status the leader never sends its "quiesce for deploy" drain, and with eight monks there is almost always a job over the 300s long-job limit, so oros never deploys.
- **The fix:** landed on main2 as `3935f665`. The status now goes through its own journal clone (`$GARDEN_STATE/fleet-health/journal`).
- **Test:** I added a check to `scripts/jobs/test/rolling-deploy-test.sh` that holds the shared clone's lock and asserts the status still publishes. The full suite passes (120/120), and the new check fails against the old code.

**Changes on the host:**
- A pending retry happened to land at 07:36:57, so the leader now sees oros deferred for `563e6db8` behind monk 1. It should send the quiesce drain on its own.
- I ran a manual publish to seed the new clone. The clone was created, but my 600s wrapper killed the publish before it committed, so nothing was pushed from it. The first clone took about 7 minutes because the root repo is shallow. Later publishes only need a fetch.
- I ran `reset-failed`; the units had already cleared by then.
- I appended the health note to `projects/garden/oros-health-log.md` on journal2.

I did not touch drains, worker leveling, derotation, budgets or schedules.

**Needs a person or the maintainer:**
- **Deploy:** oros still has to land the deploy once the quiesce drain lets the long jobs finish. Until it does, none of the fixes on main2 (including this one) are live there. Note that this checkup ran past 300s, so it is itself one of the jobs a deploy waits behind.
- **Shallow root repo:** the root is still shallow, as the 07:12 note flagged. An operator should run `git fetch --unshallow origin journal2` on it at a quiet moment.
- **minion.town MCP probe:** it has been down since 10-08 because oros has no AWS credentials. This is known.
- **Inbox:** my final inbox check timed out under load, so a message could be unread.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261012-062008.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 124 tokens (5736613 cached reads)
- Output: 27006 tokens
- Cost: $2.6483065999999997
- Wall-clock: 2959s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
