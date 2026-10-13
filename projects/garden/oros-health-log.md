# oros-studio-garden-ce242c49 health log

Newest first. One note per `oros-health-checkup-*` run.

## 2026-10-13T06:40Z (oros-health-checkup-20261012-155007, rerun after reaper requeue): degraded → sysop fix on main2

- **Load/mem:** load 4.3/3.9/3.5 at 06:10, 3.3 at 06:40; 13 GiB of 15 GiB available.
- **Disk/inodes:** 6% of the overlay used (405 GB free); inodes 1%.
- **Uptime:** 11d13h, no recent reboot.
- **Deployed vs main2:** deployed `bdc2943c`; origin/main2 is `855ba4b6`, now `548243e2` after this run's fix.
  - Self-deploy passed the gate for `31a9c782` at 05:33 but then deferred: `long-job monk 6 2498s`.
  - It retried `855ba4b6` twice, and both gates were rejected for `total-wall-clock` (900s): provider-cooldown-test at 06:20 and api-cooldown-test at 06:39.
  - The gate is marginal on oros. It passes in about 13–15 min and fails just past 15. Self-deploy retries each tick by itself; nothing was hand-forced.
- **Units:** 0 failed; 8 monks running; not drained (`drain-fleet status`: not draining); no derotation marker.
- **Budget heartbeat:** claude-oros pushed at 05:10, 05:21, 05:35, 05:50, 06:06 and 06:22; spend is 59.1M of 180M, status ok.
- **fleet/health:** `deferred @ bdc2943c`, unit_failures 0, as of 05:33.
- **rc=124:** 28 in the last 3h (flat).
- **$GARDEN_STATE:** 30 clones, all ≤48 packs, no tmp_pack; no stale index.lock; held locks belong to live processes.
- **Sysop starvation (root cause of the 05:05Z "unreachable bridge"):** the sysop was alive, but every tick started by acking 11 spooled records through send-msg on the contended producer clone. Those records date from 22:31Z to 02:32Z, and their sysop-log records were already on origin. Each tick hit the 600s timeout before the op loop, so the 04:23 `reset-failed`, the 04:25 `drain off` and the leader's 04:38–05:20 drain ops were never dispatched. Acks are now trickling, with 9 left at 06:40.
- **Changed:** landed `548243e2` on main2. The top-of-tick flush now lands records only (`--records-only`), acks go after the op loop, and each ack is bounded by `GARDEN_SYSOP_ACK_TIMEOUT` (90s). New sysop-test case: a hung ack backlog must not starve a new op. Suite passes 63/63.
- **Still open:** self-deploy runs the 15-min gate before it checks for long jobs, so a passed gate can be wasted by a long-job deferral (05:33). The gate budget is marginal under normal oros load. Self-deploy's idle tick still does not republish a mismatched fleet/health record.

## 2026-10-13T05:05Z (oros-health-watch-20261013-042006): unreachable sysop bridge

- **Checkups:** `oros-health-checkup-20261013-012006` remains claimed after its 03:30:35Z handler deadline, with both deadline notices unread and no health-log progress. The current `oros-health-checkup-20261013-042006` remains unclaimed 45 minutes after dispatch; older 15:50Z and 22:05Z checks are also queued.
- **Host signals:** the claude-oros heartbeat is fresh at 04:36:29Z (quota status `ok`, 22% derived use); no worker-derotation marker. Fleet health reports `deployed` at `bdc2943c`, zero unit/advisory failures, as of 04:02:31Z; origin/main2 is now `31a9c782`, so oros is behind the latest tip.
- **Stale drain:** sysop last applied the rolling-deploy drain-on at 03:46:30Z even though the target `bdc2943c` subsequently reached `deployed`; this makes the remaining drain stale.
- **Intervention:** sent `reset-failed` (`20261013T042311Z-2b93b9`) and `drain off` (`20261013T042557Z-1a4876`). Neither received a sysop-log record or ack during 42 minutes of polling.
- **Unreachable:** newest sysop-log activity remains 03:46:30Z, over one hour old. The maintainer inbox was notified once. A person at oros needs to restart `garden-sysop` and, if necessary, Docker Desktop or the VM; leave the stale checkup claim to the reaper.

## 2026-10-12T23:45Z (oros-health-checkup-20261012-220527): degraded → fixed on main2, deployed

- **Load/mem:** load 4.3/3.3/3.2 (4.7 at 23:46); 13 GiB of 15.6 GiB available; swap 387 MiB used.
- **Disk/inodes:** 51% (230 GB free); inodes 1%.
- **Uptime:** 11d6h, no recent reboot.
- **Deployed vs main2:** self-deploy advanced oros `f9b279f6` → `0411ed9f` at 21:53 (gate passed, quiesce instant, 142 timers thawed). The old-code self-deploy process then lost its `deployed` publish until the 2400s timeout (22:16), and the idle ticks after it never republish. So fleet/health kept showing `roll-drained @ f9b279f6`. Main2 is now `bdc2943c` (this run's fix).
- **Units:** 0 failed; 8 monks; not drained; no derotation marker.
- **Budget heartbeat:** claude-oros pushes at 22:35, 22:49, 23:05; spend 57.1M of 180M, status ok.
- **Journal CAS starvation:** every completion and inbox read lost its CAS on every attempt. Monk 7's completion of `kriscendobot-garden-book-pr8-gauntlet-undraft` reached attempt 26 over 55 min, and monk 2's inbox read for `kriscendobot-minion.town-pr181-gauntlet-fix-5` reached attempt 39 over 89 min. Both monks were stuck in a post-deploy graceful restart.
  - **Root cause:** each retry ran sync_clone's reset --hard plus a deepen from the shallow root (~90s), so it always pushed from a stale tip. The deepen never completes (root shallow at `1fa90b4f`) but logged "completed" every sync.
- **rc=124:** 24 in the last 3h (down from 28).
- **$GARDEN_STATE:** no stale locks; held locks all belong to live processes.
- **Changed:**
  - republished oros fleet/health as `deployed @ 0411ed9f` (landed in 47s);
  - landed `bdc2943c` on main2: commit_and_push can replay a lost commit onto the fresh tip through a scratch index (journal_replay_head). It refuses on any path overlap and is opt-in, enabled for complete-job and inbox-read. journal_deepen_from_root now skips once the clone's boundary is the root's. The new `commit-replay-test.sh` fails on old code. fleet-health-publish, land-journal-edit, sync-clone-reset-retry, seed-from-root, post-gauntlet-dedup and the budget-snapshot suites pass. budget-live-percent-label, foreman-edge-kick, outage-doom-pause and repo-locks fail identically on unmodified main2.
- **Follow-up 2026-10-13T05:00Z (resumed after a reaper requeue):** self-deploy put `bdc2943c` on oros at 04:02, and fleet/health reads `deployed @ bdc2943c`. All 8 monks are running and 0 units have failed. Load is 3.6 and 13 GiB is available. Since the deploy there have been 0 `lost a push race` lines, and one inbox read landed on its first replay. rc=124: 29 in 3h. The claude-oros heartbeat is every 15 min, spend 59.0M of 180M.
- **Sysop ack backlog (05:20Z):** the host is not drained, but the sysop's acks go through send-msg.sh on the contended producer clone. Every tick hit the 600s timeout, and 10 records have been spooled since 22:31Z. Landed `855ba4b6`, which opts send-msg into the replay (it is add-only at a unique path). sysop-test passes 62/62. It applies at oros's next self-deploy.
- **Still open:** Self-deploy's idle tick should republish a fleet/health record that disagrees with the deployed sha (this is the second time it was fixed by hand). The root repo is still shallow.

## 2026-10-12T21:00Z (oros-health-checkup-20261012-185007): degraded → fixed on main2

- **Load/mem:** load 1.9/2.6/2.9 (3.2 at 20:57); 13 GiB of 15.6 GiB available; swap 387 MiB used.
- **Disk/inodes:** 50% (233 GB free); inodes 1%.
- **Uptime:** 11d3h, no recent reboot.
- **Deployed vs main2:** self-deploy advanced oros `2e531a6e` → `f9b279f6` at 19:44–19:49 (gate passed in 12.5 min; quiesce was instant; 151 units coherent). Main2 is now `0411ed9f` (this run's fix).
- **Units:** 0 failed; 8 monks active; not drained; no derotation marker.
- **Budget heartbeat:** claude-oros pushes at 18:50, 19:02, 19:17, 19:32, 19:52, 20:06 (max gap 20 min). Spend 57.0M of 180M, status ok. Spend is almost flat since 13:30 (56.8M).
- **Post-deploy publish lost every CAS:** the `deployed` fleet/health publish ran 15 attempts, about 100s each, from 19:49 to 20:10. All lost the CAS. The self-deploy handler hit its 2400s timeout, and fleet/health kept reading `roll-drained @ 2e531a6` for a host that had already deployed.
  - **Root cause:** sync_clone's `reset --hard` over the 68k-file journal. On virtiofs a no-op reset measured 63–105s and `git status` 29s, so every push left from a stale tip.
- **Sysop wedged by the same cause:** from 20:03 every tick hit the 600s handler timeout. Its `flush_pending` was stuck retrying one spooled record, the 20:03 leader `drain off` (applied, never acked).
- **rc=124:** 28 in the last 3h (down from 90): 12 self-heal handlers (sysop, self-deploy), 7 sysop.
- **$GARDEN_STATE clones:** decisions, leader, producer and reaper are at 47–49 packs, all under the threshold of 50. fleet-health and review-docket clones are shallow. Held repo locks all belong to live jobs; none are stale.
- **Changed:**
  - landed `0411ed9f` on main2: `journal_graft_push` grafts host-owned files onto the fresh tip via a scratch index (no worktree), and publish_fleet_health and the sysop flush_pending use it; new `fleet-health-publish-test.sh` (fails on old code), and the rolling-deploy, sysop, land-journal-edit and budget-replay suites pass;
  - republished oros fleet/health as `deployed @ f9b279f6` with the new code (landed first try, 33s);
  - landed the stuck sysop-log record `20261012T195902Z-d97800` so the running sysop can ack it.
- **Still open:** the root repo is still shallow (`.git/shallow` = `1fa90b4f`; see 07:12Z). Other sync_clone+commit producers (post-job, land-journal-edit, watchdog-notice) still pay the slow reset, and only host-owned writers can use the graft.

## 2026-10-12T13:30Z (oros-health-checkup-20261012-125006): degraded

- **Load/mem:** load 3.7/3.6/3.2; 13 GiB of 15.6 GiB available; swap 317 MiB used.
- **Disk/inodes:** 57% (203 GB free); inodes 1%.
- **Uptime:** 10d20h, no recent reboot.
- **Deployed vs main2:** deployed `8da29934` = origin/main2 tip. Deployed at 11:44Z; fleet/health roll_status `deployed`; roll release names `8da29934`. The `3935f665` dedicated fleet-health clone unstuck the roll.
- **Units:** 0 failed (fleet/health's `unit_failures: 2` is the 11:44 publish-time count). Units in `activating` were all under 6 min; none stuck.
- **Budget heartbeat:** claude-oros pushes at 10:28, 10:37, 11:04, 11:22, 11:48, 12:02, 12:18, 12:32, 12:47, 13:12. The largest gap was 27 min. CAS push losses at 10:35, 10:54, 11:37 and 13:07 were each recovered on the next tick. Spend is 56.8M of 180M (22% derived), status ok.
- **Workers:** 8 monks active; not drained; no derotation marker for oros.
- **$GARDEN_STATE clones:** namespace-clone-maintenance repacked leader 61 → 26 at 12:41, but leader is back at 65 packs (with 1 tmp_pack) 40 min later. That is about 1 pack/min. The hourly pass at threshold 50 keeps up, so nothing was done by hand. Other clones are at 47–53 packs. No orphaned reclone or budget-stale siblings. The only held locks belong to a live transcripts fetch.
- **rc=124:** 90 in the last 3h, down from 290. Mostly `monitor/monk-N` journal clones (>300s).
- **Producer lane wedged:** the producer clone sat at 57–59 packs, over gc.autoPackLimit 50. After every fetch, `journal_auto_gc` ran `gc --auto`, and over the limit that is an all-in-one cruft repack. bin/git's 120s bound killed it every time (rc=124), so each fetch, including every CAS retry, paid about 120s under the producer lock. This run's own land spent 20+ min retrying, and the producer lock showed busy >3 min.
- **Changed:**
  - stopped this run's own stuck land;
  - geometric-repacked `producer/journal` from 59 packs to 3 in seconds (`repack -d -l --geometric=2` via the fleet wrapper);
  - fixed `journal_auto_gc` on main2 to use a geometric repack instead of `gc --auto`, with a new `journal-auto-gc-test.sh`.
- **Still open:** the root repo is still shallow (`.git/shallow` = journal2 `1fa90b4f`). Running `git fetch --unshallow` needs an operator decision; see the 07:12Z note.

## 2026-10-12T07:40Z (oros-health-checkup-20261012-062008): degraded

- **Load/mem:** load 9.1/5.0/4.7 at 06:55, 5.1/4.2/4.2 at 07:39; 12 GiB of 15.6 GiB available; swap 334 MiB used.
- **Disk/inodes:** 6% (405 GB free); inodes 1%.
- **Uptime:** 10d14h, no recent reboot.
- **Deployed vs main2:** deployed `78f9dacc` is now 14 behind `3935f665`.
  - The leader re-released oros for `563e6db8` and self-deploy tried at 06:23 and 06:59. Both passed into deploy-garden.sh and DEFERRED behind long jobs (monk 6 at 8822s, then monk 1 at 2921s).
  - The 06:08 self-deploy tick hit the 2400s SELF_HEAL_HANDLER_TIMEOUT.
- **Root cause of the stuck roll:** every deferred-status publish failed from 02:39 to 07:36, so fleet/health showed oros deferring for an old target and the leader never sent its quiesce-for-deploy drain.
  - publish_fleet_health shared `$GARDEN_STATE/producer/journal` with post-job, land-journal-edit and watchdog-notice. That lock saw ~100s waits, a 300s post-job holder, and give-ups every few minutes.
  - Fixed on main2 by `3935f665`: a dedicated `fleet-health/journal` clone, with a rolling-deploy-test regression check. The test fails on the old code.
  - A pending republish happened to land at 07:36:57, so the leader now sees `deferred` for `563e6db8` behind monk 1.
- **Units:** 5 failed at 06:55: state-clone-keeper, library-link-scan, regenerate-sections-index, regenerate-topics-counts, worktree-sweeper (all journal-git contention; the fixes are pending deploy). All were clear by 07:39 (reset-failed).
- **Budget heartbeat:** claude-oros pushes at 05:59, 06:06, 06:37, 06:56, 07:04 (gaps of 31 min and 19 min); spend 55.1M of 180M (31%); status ok.
- **Roll status:** release `deploy/roll/oros` = `563e6db8`; leader-sha (last-known-good) `9affc0d6`.
- **Workers:** 8 monks; not drained; no derotation marker.
- **$GARDEN_STATE clones:**
  - Repacks of leader (77 packs), state-clone-keeper (59), library-link-check (57) and regenerate-topics-counts (54) all timed out at 120s under load.
  - The only reclone siblings belonged to live in-flight clones; none were orphaned. No stale held locks.
- **rc=124:** 290 in the last 3h, mostly `monitor/monk-N` journal clones/fetches.
- **New clone:** the first publish seeded `$GARDEN_STATE/fleet-health/journal` (~7 min, because the root is still shallow per the 07:12 note). It now exists on oros, so later publishes only fetch.
- **Other:** the minion.town MCP probe has been down since 10-08 (no AWS credentials on oros; known, needs `requires: aws`).
- **Note:** this checkup ran past 300s too, so it is one of the long jobs a deploy defers behind.

## 2026-10-12T07:12Z (oros-health-checkup-20261012-000506, resumed after reap): degraded

- **Deployed:** still `78f9dacc`; roll_status `deferred`, behind a long-running monk job.
- **Monks 5-8 offline (diagnosed 02:35Z):** bin/git's 120s bound killed the root-seed checkout (~68k files on virtiofs). The fallback network clone then timed out at 300s, because the **root repo is shallow** and can't lend objects: `.git/shallow` holds journal2 `1fa90b4f`, written 2026-10-11 09:15Z, cause unknown.
  - Fixed on main2 by `75b15068` (`GARDEN_JOURNAL_SEED_CHECKOUT_TIMEOUT`, 1800s, with a test).
  - A transient serial seed unit got clones in place. At 07:10Z monks 5, 6 and 8 have clones and monk 7 was still seeding.
- **Still open:** the root is still shallow. Run `git fetch --unshallow origin journal2` against the root's object store at a quiet moment. This mutates the shared root repo, so it needs an operator decision.

## 2026-10-12T04:13Z (oros-health-checkup-20261012-030519): degraded

- **Load/mem:** load 3.3/4.1/5.0; 12 GiB of 15 GiB available; swap 326 MiB used.
- **Disk/inodes:** 54% (216 GB free); inodes 1%.
- **Uptime:** 10d11h, no recent reboot.
- **Deployed vs main2:** deployed `78f9dacc` is 7 behind `75b15068`.
  - The 03:31 canary release passed the gate but was DEFERRED at 03:45, because monk 4 had been mid-job for 4396s (the previous health checkup).
  - At 04:14 the leader cleared the release ("peer offline": a 51 min heartbeat gap).
  - At 04:15 a main2 fetch failed transiently.
  - At 04:35 the leader re-released oros for `5ec392b0`. The gate passed at 04:51, but the deploy was DEFERRED again because monk 6 (this run) had been mid-job for 2308s. It retries once this job ends.
- **Units:** 5 failed, all journal-git rc=124 under contention.
  - Timed out: state-clone-keeper, library-link-scan, regenerate-sections-index, regenerate-topics-counts.
  - worktree-sweeper fails "hard reset failed after retry" every 30 min from 02:15. Its reset is killed at the 120s bin/git bound; fixed on main2 by `cc0fa2a2`, pending deploy.
  - Ran reset-failed.
- **Budget heartbeat:** snapshots at 03:26, 03:41, then nothing until 04:32 (51 min).
  - CAS push losses at 03:37, 03:54, and 04:08–04:32 (3 ticks).
  - A not-due tick at 04:00 falsely logged "recovered" and cleared the outage latch. Fixed on main2 by `eedd785f`.
- **Roll status:** canary release for oros was outstanding at 04:35; last-known-good (leader-sha) is `9affc0d6`.
- **Workers:** 8 monks; not drained; no derotation marker.
- **$GARDEN_STATE clones:**
  - Largest per-namespace clones are at 47–53 packs (namespace-clone-maintenance repacks above 50, last ran 02:37).
  - Found 12 orphaned `*.reclone.<pid>.N` / `*.budget-stale.<pid>` sibling dirs: 3.0 GB, ~193k inodes, the oldest from 10-01. Removed the 10 dead/aged ones by hand.
  - No stale locks.
- **rc=124:** 335 in the last 3h.
  - 87 were `claim`.
  - ~175 were `monitor/monk-N`: network journal clones timing out at 300s.
  - The root-seed fix `75b15068` is pending deploy.
- **Changes landed on main2:**
  - `5ec392b0`: namespace-clone-maintenance sweeps orphaned clone siblings.
  - `cc0fa2a2`: sync_clone's reset gets GARDEN_JOURNAL_RESET_TIMEOUT=900s.
  - `eedd785f`: the scaler no longer treats a not-due publish tick as outage recovery.
- **Note:** this 3h checkup is itself a >300s monk job, so it defers any deploy that reaches its gate while the checkup runs (03:45 and 04:51 today).
- **Addendum 09:06Z (resumed after a reaper requeue):** still on `78f9dacc`. The gate passed at 05:48, 07:09 and earlier, but every attempt DEFERRED on a >300s monk job. At 05:48 and 06:39 that was this job's own session on monk 6, which hung for about 3h after writing its report until it was reaped; at 07:09 it was monk 1. Since 09:01 self-deploy has been "leaderless" HOLDING at 9affc0d6. With 8 monks, a 300s long-job threshold almost never sees a quiet moment, so the threshold or deferral policy needs maintainer attention. Units are still failing on the 120s reset bound (fixed by `cc0fa2a2`, not yet deployed).
