**Verdict: degraded.** oros is current, idle and pushing its heartbeat. But the sysop `restore` op fails on this host, and that is the op `oros-health-watch` uses to intervene.

**Snapshot (19:53Z)**
- **Load and memory:** load 3.47/3.44/3.58, 13 GiB of 15 GiB available, swap at its usual level.
- **Disk:** the virtiofs garden mount is at 82% (87G free), inodes at 2%. The overlay is at 7%.
- **Uptime:** 31 days, no reboot.
- **Deploy:** deployed `d1e41a9`, the same as the origin/main2 tip. `roll_status` is `deployed` with 0 of 290 units failing. There is no deploy to help along.
- **Workers:** not draining, 0 failed units, monks 1–4 running, worker leveling `4 0`, no derotation marker.
- **Budget meter:** pushes every ~15 minutes and all were ok, last at 19:34Z. Spend has been flat at 10.45M of 180M since 17:33Z, which is real: monks claimed almost nothing in that time. The eligible todo jobs were scholar ingests that need the `typesafe` capability, or endojs panel stages this host's token can't write.
- **Claims are slow:** each claim attempt takes about 50 s, mostly a `git reset --hard` across the 82k-file journal tree on virtiofs. This job was posted at 19:20Z and claimed at 19:52Z; monk 3 lost the push race on it three times in between.
- **Timeouts:** one bounded self-heal `garden-unblock` timeout at 17:16Z, no journal fetch timeouts.
- **State clones:** 84 journal clones, all under the pack threshold. No stale locks, apart from the orphaned reset described below, which has since finished.

**The defect.** `oros-health-watch` sent `restore` at 19:52:57Z, 49 s after the claim. It failed: the sysop log reads `restore partial: ran reset-failed`.
- On a follower, the reaper and deadmail services don't run, so their journal clones are only synced when a `restore` runs. Both were last synced on 2026-09-28, about 81k commits behind.
- The first sync took over 300 s for reaper and 373 s for deadmail. Each `restore` step allows 150 s.
- When the 150 s limit killed `reaper.sh`, its git child processes kept running, because the git wrapper's own 900 s timeout starts them in a separate process group. They held the reaper clone's lock until about 20:00Z.
- Other clones for services that only run on the leader are just as out of date: foreman, deadline-nudge, requirements-watch, library-source-drift-scan, transcripts, reducer (Sep 28–30) and self-heal (Sep 26).

**What I changed**
- The leftover reset finished and brought the reaper clone current. I synced the deadmail clone under its lock (373 s). The next `restore` should get through both steps.
- I did not remove the two Oct-10 `scholar-staging` clones. The `literate-ai-remainder-2` clone holds an unpushed commit (`330533f5b`) and only part of its content is on origin, so deleting it would lose work.
- I landed this run's note in `journal2:projects/garden/oros-health-log.md`.
- I posted `fix-sysop-restore-dormant-follower-clones-20261101` to fix `restore` on main2 with tests. Options it lists: skip the reaper step on a follower, keep those clones synced, and kill the whole process tree when a step times out.
- No garden code change this run, and nothing touched drains, worker leveling, budgets or schedules.

**For the maintainer:** nothing urgent. Moving `$GARDEN_STATE` from the virtiofs mount onto the container's overlay disk (402G free) would remove most of the ~50 s per claim attempt, but that's a decision about the host's setup.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261101-192009.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 112 tokens (4886746 cached reads)
- Output: 28722 tokens
- Cost: $2.4597092000000007
- Wall-clock: 2554s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
