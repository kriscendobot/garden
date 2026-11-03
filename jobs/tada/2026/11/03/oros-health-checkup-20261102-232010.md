**Verdict: degraded (disk only).** Otherwise oros is working: deployed at `e97673a` with `roll_status: deployed`, 0 of 290 units failing, and 4 monks running. No drain or derotation marker seen.

**Snapshot** (note landed on `journal2:projects/garden/oros-health-log.md`):
- **Load and memory:** load is about 3-4, with 12 of 15 GiB available. Swap is still full, unchanged.
- **Uptime:** 32 days, no reboot.
- **Disk:** 51.5 GiB free (90%), down about 5.9 GiB since 21:13Z, then flat over the last 10 minutes or so. The source is still unknown; a bounded `find` was cut off at 240s with no hits, so that check is incomplete. Inodes are at 2%.
- **Budget heartbeat:** the last 8 pushes are all ok, about 15 minutes apart. Spend is 18.7M of 180M.
- **State clones and locks:**
  - The largest clone is 49 packs; there is no `gc.log` or temp pack in the monk and monitor clones.
  - No stale `.git` locks in the monk, monitor or producer clones.
  - I did not check the 58 older `.lock` files at the top of `$GARDEN_STATE`; I took them for flock files and left them.
- **Timeouts:** 4 rc=124 in the last 3h, all contention-watch notice deferrals. No rc=137 or `Failed with result` in 4h.

**Changed:** I landed `0844a5d` on main2, fixing a leak in `scripts/jobs/journal-contention-watch.sh`.
- **The bug:** rings for deleted per-job inbox clones were never removed. There were 424 inbox slugs (503 slugs in all) against 4 inbox entries in `$GARDEN_STATE/inbox`, and every slug still paid the stats pass on each tick. A tick was taking about 90s wall time and 36-40s of CPU every 5 minutes.
- **The fix:** the watcher now forgets a slug with no clone once all its rings are older than 6h and no rebuild is waiting on it. It also drops stats files with no slug behind them.
- **Testing:** I added a case to `journal-contention-watch-test.sh` and the suite passes. I did not run the new case against the unfixed code.
- **Not yet live:** it reaches oros at its next deploy, so the tick improvement is unmeasured.

I removed no files by hand and touched no units, drains, leveling, pools or schedules.

**Deploy:** no help needed; oros matches main2 apart from this run's fix.

**Needs the maintainer or a person at the machine:**
1. **Watcher backlog:** four `oros-health-watch` runs (13:50, 17:05, 20:20, 23:20Z) still wait in todo, so no sibling watcher has covered oros since at least 13:50Z. This run also waited 25 minutes for a claim, and `watchdog-unclaimable-host-requirements` fired for it at 23:37Z. claude-endolin1 reads 71%; the previous run put these waits down to endolin's budget pacing, and I did not re-check that.
2. **Shared disk:** someone at the Mac should find what used it, with about 51 GiB left.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261102-232010.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1511086 cached reads)
- Output: 24875 tokens
- Cost: $1.6253172
- Wall-clock: 1184s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
