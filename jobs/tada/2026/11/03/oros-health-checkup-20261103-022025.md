**Verdict: degraded, for disk only.** Everything else is healthy, but the shared disk is at 90% with about 45 GiB free. It dropped about 1.9 GiB/h since 00:00Z, which would fill it in about a day if that rate held.

**Snapshot** (noted in `journal2:projects/garden/oros-health-log.md`):
- **Deploy:** oros runs `0844a5d` with `roll_status: deployed`, and 0 of 290 units failing. Main2 is one commit ahead with this run's fix.
- **Workers:** `garden-monk@1..4` are running, with no drain or derotation marker and no failed user units.
- **Load and memory:** load is about 3, with 12 GiB of 15 GiB available. Swap is full, unchanged. There has been no reboot in 32 days.
- **Heartbeat:** the last 8 budget pushes are all ok, about every 15 minutes, with the latest at 02:19Z. Spend is 19.0M of 180M.
- **Timeouts:** no rc=124 or rc=137 in the last 3h.
- **State clones:** no `gc.log` or temp packs, and no stale locks in the monk and monitor clones or at the top of the root `.git`. A wider search of `$GARDEN_STATE` timed out at 60s, so the rest wasn't checked.
- **Contention watch:** the `0844a5d` fix looks like it worked. One tick took 37s and 11.4s of CPU, against about 90s and 36-40s before.
- **`oros-health-watch`:** it has caught up, with none waiting in todo or doin.

**What I changed:**
- **Sweeper fix (`dd1eb97` on main2):** dependency-cache entries are about 1 GiB each (two samples), and there are 51 of them. Until now they were pruned only when that repo next provisioned, so minion.town and garden-book entries sat at 15-23 days.
    - **New behavior:** the sweeper now evicts entries idle past 14 days on every repo, and sooner (`-mtime +2`, 3 full days idle) when under 64 GiB is free. Each repo keeps its newest entry.
    - **Testing:** the new `worktree-sweeper-dep-cache-test.sh` passes 18 of 18, and the existing build-cache test still passes. I didn't run the new test against the old code. The fix hasn't run on real data yet; it reaches oros at the next deploy, and the next check-up should confirm free space jumps.
- **Host:** I removed no files and touched no units, drains, leveling or schedules.

**Disk accounting:**
- **Inside the garden tree:** roughly 120 GiB of the 415 GiB used, which is an estimate because three state directories timed out. Scratch's project, gardener and tmp directories are 37 GiB of that, led by two idle ironhorse checkouts (8.8 and 8.1 GiB).
- **Current growth:** I can't yet say the growth is coming from inside the tree. The dependency cache accounts for only part of it, about 6 entries touched today.

**Needs a person at the Mac:** find what is using the roughly 300 GiB outside the garden tree, which can't be seen from inside the container.

**Minor, not fixed:** the sweeper keeps one finished checkout (about 48M) indefinitely because its report cites `kriscendobot/garden#89`, which returns 404 when looked up as a PR. It's recorded in the log.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261103-022025.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1624320 cached reads)
- Output: 29838 tokens
- Cost: $1.7195520000000002
- Wall-clock: 2029s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
