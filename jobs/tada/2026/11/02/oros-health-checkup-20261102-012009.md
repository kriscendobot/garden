**Verdict: degraded (disk).** oros's services, deploy and meter are all fine, but the shared disk is at 85% (74G free), and most of its usage is outside the garden tree. Free space was 190G on 10-31.

**Snapshot (logged to `journal2:projects/garden/oros-health-log.md`):**
- **Load and memory:** load is 4.10, with 12 GiB of 15 GiB available. Swap is now completely full (1.0 GiB, 108 KiB free), up from 954M at 23:17Z. That isn't memory pressure yet, but there's no swap headroom left.
- **Uptime:** 31 days, no reboot.
- **Deploy:** deployed `d0690e9`, `roll_status: deployed`, 0 of 290 units failing. `origin/main2` is one commit ahead, which is this run's fix, and nothing is blocking its rollout.
- **Workers:** not draining, 4 monks running, no derotation marker.
- **Meter:** the last push was at 03:49Z. Recent pushes are all ok, every 12–17 minutes, and spend is 12.5M of 180M.
- **State clones:** 52 journal clones, the largest at 47 packs (under the threshold of 50), with no `gc.log` and no stale `.git` locks.
- **Timeouts:** one rc=124 in the last 3 hours: `weave-endojs-endo-but-for-bots-pr1476-llm-20261102` hit its 7200s wall and was left for reaper requeue.

**What I changed:**
- **Removed idle caches:** seven `scratch/cargo-target-*` caches, about 14.4G by `du`. Each had a `CACHEDIR.TAG`, no writes for at least 8 days, and no process using it. Their PRs are still open, so a later job on one will rebuild from cold. I kept `cargo-target-pr1614`, which was written on 11-01.
- **Fixed the leak (`11fe1c6` on main2):** the worktree sweeper now removes top-level scratch dirs tagged `CACHEDIR.TAG` after 7 idle days. The new `worktree-sweeper-build-cache-test.sh` passes 11 of 11, and the follower and lock-liveness sweeper tests still pass. The 7-day rule would not have caught yesterday's 46G dir, which filled the disk within hours.

**Still unexplained:**
- **Disk reclaim:** `df` didn't improve after the 14.4G removal (75G free before, 74G after). Either something outside the mount used the same amount, or the Mac hasn't released the space yet; I couldn't confirm either from inside the container.
- **CLI reinstall:** the Claude Code tree was reinstalled at 03:46:33Z and now reports 2.1.316. One of my commands hit `claude native binary not installed` during the swap, but the journal shows no such errors in the last hour. Any job starting in that few-second window could fail the same way.

**Needs a person at the machine:** someone at the Mac should find what is using the shared disk. By a rough estimate, the garden tree accounts for only about 80G of the 388G in use, which leaves about 300G I can't see from here. At the rate since 16:40Z (14G in 11 hours), 74G lasts about 2.5 days.

I did not change drains, worker leveling, derotation markers, budget pools or schedules.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261102-012009.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1417313 cached reads)
- Output: 26396 tokens
- Cost: $1.5807346
- Wall-clock: 2411s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
