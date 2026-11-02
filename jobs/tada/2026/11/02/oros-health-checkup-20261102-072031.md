**Verdict: degraded (disk).** Free space on the garden mount is down to about 69.5G (86% used), from 72G at 05:15Z, and I still don't know what's using it. Everything else checked out, and the note is on `journal2:projects/garden/oros-health-log.md`.

**Snapshot**
- **Load and memory:** load ran about 2.5–5, peaking at 10.10 during my prune. 12 GiB of 15 GiB is available, and swap is still full.
- **Uptime:** 31 days, no reboot.
- **Inodes:** 2% used.
- **Deploy:** oros runs `11fe1c6` with `roll_status: deployed` and 0 of 290 units failing. origin/main2 is one commit ahead with this run's fix; I saw nothing blocking the roll, so I did nothing to help it along.
- **Workers:** monks 1–4 are running, with no drain or derotation marker seen.
- **Budget heartbeat:** the last 8 pushes I checked (06:03–07:49Z) were all ok, about every 15 minutes, with spend at about 14.1M of 180M.
- **Timeouts:** the only rc=124 in the last 3 hours was a benign deferred notice, with no rc=137.
- **State clones:** the largest has 50 packs, at the threshold but not over it, with no `gc.log` or temp packs.
- **Stale locks:** none found, but that search hit its 60s bound, so it isn't complete.

**Changed**
- **Pruned `scratch/tmpexec`:** removed 7,990 entries (about 6.2G by `du`) with no writes in 7 days and no live process holding them; 190 remain. The load peak above was during this prune.
- **Landed `6d9c658` on main2:** nothing was sweeping `tmpexec`, so the worktree sweeper now prunes it every tick, within a 300s budget. The new `worktree-sweeper-tmpexec-test.sh` passes 16 of 16 and the build-cache and follower tests still pass. For the lock-liveness test I only saw its last line, which was a PASS.
- **Left alone:** drains, worker leveling, derotation markers, budget pools and schedules.

**Disk still unexplained**
- **The prune didn't help `df`:** free space went from 71.4G to 69.5G across it, so `tmpexec` was not the cause.
- **Ruled out:** project worktrees total only about 12G. Searches for large recent files and the size check on the remaining scratch caches both hit their time limits, so those stay unmeasured.

**Needs a person**
- **Maintainer, at the Mac:** please find what is using the shared disk. Earlier runs put about 300G outside the garden tree, and this is the third run in a row to ask.

**Minor, not investigated**
- The gardener-scaler logged 2 "spend reading below published" warnings in 6 hours, and held the published value both times.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261102-072031.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1066395 cached reads)
- Output: 20272 tokens
- Cost: $1.2326629999999998
- Wall-clock: 1967s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
