# oros-studio-garden-ce242c49 health log

Newest first. One note per `oros-health-checkup-*` run.

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
