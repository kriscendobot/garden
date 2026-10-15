**Verdict:** oros-studio-garden-ce242c49 is **healthy**, with one garden bug that I fixed on main2 as `85389eda` (not deployed yet).

**Snapshot** (also in `journal2:projects/garden/oros-health-log.md`):
- **Load and memory:** load 3.1/3.9/3.4; 13 of 15 GiB available.
- **Disk:** 6% used; inodes 1%.
- **Uptime:** 13d8h, no reboot.
- **Deploy:** the host runs `8d47418e`, the same as origin/main2 when I claimed the job. fleet/health shows `roll_status: deployed` and 0 of 293 units failed. Last run's fix `624ea1f3` is live.
- **Workers:** 0 failed units; monks 1–6 running. No drain, and I didn't touch derotation.
- **Budget heartbeat:** claude-oros sampled at 01:18Z, status ok, 3% used, on its normal 15-minute cadence.
- **Root store:** 28 packs, 469M, no `gc.log`, no `tmp_pack`. root-repo-guard reports healthy every 30 minutes.
- **State clones:** none bloated, no `tmp_pack`, and 0 dead-pid repo-lock holders.
- **rc=124 timeouts:** the contention watch was killed at its 240-second start timeout on every tick until 23:30Z, when `624ea1f3` deployed. Since then it finishes inside that limit. transcript-capture still times out about once an hour, as in earlier runs.

**Finding, fixed on main2 `85389eda`:**
- **Bug:** the contention watch saved a "cleared" notice for the lock-contention storm alert. That notice loses journal push races for about 200 seconds on every tick. The watch delivers saved notices before its sweep and after each clone, so the notice used the whole 210-second budget. Most ticks logged `analyzed 0`, and the sweep sat at clone 325 of 496 from 23:44Z to 00:53Z.
- **Fix:** notice delivery before and during the sweep now stops once half the tick's budget is left. Delivery after the sweep still uses whatever remains. The share is set by `GARDEN_CONTENTION_SWEEP_SHARE`.
- **Test:** I added a case to `journal-contention-watch-test.sh`. It fails without the fix and passes with it.
- **Deploy:** the fix reaches oros through the normal rolling deploy; nothing is blocking it.

**Changed on-host:** nothing.

**For the maintainer:**
- The open lock-contention alerts are real. The producer, sysop, unblock, repo-watcher and gardener-scaler journal clones are contending. That matches the 10-01 diagnosis (pushes to the journal losing races under load), so I'm watching it rather than treating it as new.
- Still open from the 20:35Z run: the 104 unpruned backups in `journal-worktree-keeper/backups` need your decision.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261014-211624.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1690934 cached reads)
- Output: 14184 tokens
- Cost: $1.2382828000000001
- Wall-clock: 1242s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
