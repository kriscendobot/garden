# oros-studio-garden-ce242c49 health log

Newest first. One note per `oros-health-checkup-*` run.
## 2026-10-23T20:45Z (oros-health-checkup-20261023-203508): healthy; deployed = origin/main2 `8576a7c`, no changes

- **Load/mem:** load 2.76/2.43/2.43 at 20:38Z. 2 monks are running. 12 GiB of 15 GiB available; swap reads 819M of 1.0 GiB, back at the earlier steady level; not pressure.
- **Disk/inodes:** 7% of the overlay used (403G free), inodes 1%. The virtiofs garden mount is at 60%; `/tmp` at 766M (10%).
- **Uptime:** 22d03h22m, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `8576a7c` (19:52Z), the origin/main2 tip per `ls-remote`. fleet/health/oros (19:53:22Z): `roll_status: deployed`.
- **Units:** 0 failed user units. `garden-monk@1..2` are running. `drain-fleet.sh status`: not draining. No derotation marker.
- **Budget heartbeat:** claude-oros pushed at 18:02, 18:17, 18:32, 18:48, 19:03, 19:18, 19:32, 19:48, 20:03, 20:18 and 20:33Z, all ok. Spend was 87.21M to 87.34M (48.5% of 180M), flat since 19:32Z while the monks were mostly idle. The meter is not stuck. The live `$GARDEN_ROOT/journal` worktree lagged (newest visible push 20:03Z), so read the heartbeat from a state clone such as `gardener-scaler/journal`.
- **State clones:** 80 journal clones. The largest are reaper and gauntlet (47 packs each), then repo-watcher and monks/1 (45); all under the threshold of 50. No tmp_pack, no `gc.log`, no git `*.lock` older than 30 minutes.
- **rc=124 (3h):** none; no `Failed with result` or rc=137 lines. 175 `garden repo lock: timeout` lines: the usual bounded try-locks, not a wedge.
- **Changed:** nothing.
- **Needs the maintainer:** nothing.


## 2026-10-23T17:30Z (oros-health-checkup-20261023-172020): healthy; deployed = origin/main2 `b5b0188`, no changes

- **Load/mem:** load 2.15/2.75/2.90 at 17:25Z. 2 monks are running. 13 GiB of 15 GiB available; swap reads 0 (down from 816M last run).
- **Disk/inodes:** 7% of the overlay used (403G free). The virtiofs garden mount is at 58%, inodes 1%.
- **Uptime:** 22d00h09m, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `b5b0188` (10:38Z), still the origin/main2 tip. fleet/health/oros (10:38:16Z): `roll_status: deployed`, 0 of 288 units failed.
- **Units:** 0 failed user units. `garden-monk@1..2` are running. `drain-fleet.sh status`: not draining. No derotation marker. The sysop ticks cleanly (applied 0, failed 0).
- **Budget heartbeat:** claude-oros pushed at 14:47, 15:02, 15:17, 15:32, 15:47, 16:02, 16:18, 16:32, 16:48, 17:04 and 17:17Z, all ok, about every 15 minutes. Spend rose from 80.44M to 85.34M (47.4% of 180M). The meter is not stuck.
- **State clones:** 80 journal clones (top-level and nested). The largest are reaper and gauntlet (47 packs each), then regenerate-sections-index (37); all under the threshold of 50. No tmp_pack, no `gc.log`, no git `*.lock` or gc.log older than 30 minutes.
- **rc=124 (3h):** none, and no `Failed with result` or rc=137 lines. About 110 `garden repo lock: timeout after Ns (shared)` lines spread over 7 repo locks. These are the bounded try-locks seen in earlier runs, not a wedge.
- **Changed:** nothing.
- **Needs the maintainer:** nothing.

## 2026-10-23T15:05Z (oros-health-checkup-20261023-142009): healthy; deployed = origin/main2 `b5b0188`, no changes

- **Load/mem:** load 3.66/3.09/2.36 at 14:47Z. 2 monks are running. 13 GiB of 15 GiB available. Swap reads 816M of 1.0 GiB, the same as the last three runs; not pressure.
- **Disk/inodes:** 7% of the overlay used (403G free); inodes 1%. The `/tmp` tmpfs is at 763M (10%), steady. The virtiofs garden mount is at 58%.
- **Uptime:** 21d21h31m, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `b5b0188` (10:38Z), still the origin/main2 tip per `ls-remote`. fleet/health/oros (10:38:16Z): `roll_status: deployed`, 0 of 288 units failed.
- **Units:** 0 failed garden units. `garden-monk@1..2` are running. `drain-fleet.sh status`: not draining. No derotation marker (`.garden-state/worker-derotate` is only the derotate service's journal clone).
- **Budget heartbeat:** claude-oros pushed at 12:18, 12:32, 12:48, 13:03, 13:17, 13:33, 13:47, 14:01, 14:18 and 14:32Z, all ok, about every 15 minutes. Spend rose from 78.54M to 80.31M (44.6% of 180M). The meter is not stuck.
- **State clones:** 33 top-level `*/journal` clones, plus 47 nested ones (`*/*/journal`). The largest are worktree-sweeper (50 packs, at the threshold), monitors/monk-1 (49), repo-watcher (48), and reaper and gauntlet (47 each). No tmp_pack, no `gc.log`, and no git `*.lock` older than 30 minutes under any clone's `.git`. Note that a recursive `find` over all of `.garden-state` takes more than 10 minutes on this host, so scope the lock scan to `*/journal/.git` and `*/*/journal/.git` at maxdepth 2.
- **rc=124 (3h):** none, and no `Failed with result` or rc=137 lines. There are a few `garden repo lock: timeout after 2s (shared)` lines at 14:58–15:03Z. These are bounded try-locks that wait behind a peer, not a wedge.
- **Changed:** nothing.
- **Needs the maintainer:** nothing.

## 2026-10-23T11:50Z (oros-health-checkup-20261023-110509): healthy; deployed = origin/main2 `b5b0188`, no changes

- **Load/mem:** load 1.61/2.63/2.80 at 11:36Z. 2 monks are running. 13 GiB of 15 GiB available. Swap reads 817M of 1.0 GiB, about the same as the last two runs; not pressure.
- **Disk/inodes:** 7% of the overlay used (403G free); inodes 1%. The `/tmp` tmpfs is at 745M (10%), steady. The virtiofs garden mount is at 57%.
- **Uptime:** 21d18h20m, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `b5b0188` (written 10:38Z), the origin/main2 tip per `ls-remote`. fleet/health/oros (10:38:16Z): `roll_status: deployed`, 0 of 288 units failed. The roll that the last run saw deferred behind monk 2's long job completed once the job ended.
- **Units:** 0 failed garden units. `garden-monk@1..2` are running. `drain-fleet.sh status`: not draining. No derotation marker. The sysop is ticking (applied 0, failed 0).
- **Budget heartbeat:** claude-oros pushed at 09:47, 10:05, 10:18, 10:32, 10:49, 11:03, 11:18 and 11:33Z, all ok, about every 15 minutes. Spend rose from 75.19M to 78.30M (43.5% of 180M). The meter is not stuck.
- **State clones:** 33 `*/journal` clones. The largest are repo-watcher (50 packs, at the threshold), reaper and gauntlet (47 each), and fork-watch (46). No tmp_pack, no `gc.log`, and no git `*.lock` older than 30 minutes under any clone's `.git`. The old `*.lock` files at `.garden-state` top level (`ci-pr-source-cache/*.lock`, `*/journal.lock`) are persistent flock files, not stale git locks.
- **rc=124 (3h):** none since 09:25Z. The 08:56–09:25Z journal-fetch burst was already noted in the last run. No `Failed with result` lines. One older rc=137, at 09:10Z: `fix-endojs-endo-but-for-bots-pr1349-constructable-changeset-docs-regressions` hit its own wall-clock budget, which is a bounded kill and not a host fault.
- **Standing noise:** `garden-minion-mcp-watchdog` self-heal still reports minion.town MCP down since 2026-10-08. The cause is that oros has no AWS credentials (`secret minion/test-cc-client`). This is known and expected on this host. gpg-agent `scdaemon` IPC lines are benign.
- **Changed:** nothing.
- **Needs the maintainer:** nothing.

## 2026-10-23T10:05Z (oros-health-checkup-20261023-075030): healthy; deployed `1b0b585f`, roll to tip `b5b0188` deferred on a long job; no changes

- **Load/mem:** load 0.85/2.01/3.13 at 09:55Z. 2 monks are running (monk 2 is on `endojs-endo-but-for-bots-pr1538-gauntlet-fix-3`; monk 1 is this run). 12 GiB of 15 GiB available. Swap reads 819M of 1.0 GiB, about the same as last run; not pressure.
- **Disk/inodes:** 7% of the overlay used (403G free); inodes 1%. The `/tmp` tmpfs is at 755M (10%), steady.
- **Uptime:** 21d16h40m, no reboot.
- **Deployed vs main2:** oros self-deployed `1b0b585f` at 09:32Z, and its canary probe completed at 09:37Z. Origin/main2 then moved to `b5b0188` (09:33:56Z, one commit). fleet/health/oros (09:57:50Z): `roll_status: deferred`, reason `long-job monk 2 1375s`, targeting `b5b0188`. That is the gate waiting for a long job as designed. 0 of 288 units failed.
- **Units:** 0 failed garden units. `garden-monk@1..2` are running. `drain-fleet.sh status`: not draining. No derotation marker.
- **Budget heartbeat:** claude-oros pushed at 08:17, 08:32, 08:46, 09:02, 09:17, 09:32 and 09:47Z, all ok, about every 15 minutes. Spend was flat at 75.02M from 08:01Z to 09:32Z, while the monks were idle (no handler between the end of pr1543-fix-3 and the 09:34Z claim). It then rose to 75.19M (09:47Z push). A live `meter_subscription_window_total` read 75.25M at 10:00Z. The meter is not stuck. 41.8% of 180M.
- **State clones:** 33 `*/journal` clones. The largest are reaper and gauntlet (47 packs each) and gardener-scaler (43), all below the threshold of 50. No tmp_pack, no `gc.log`, and no git `*.lock` older than 30 minutes. The previous run's sysop and screening-control clones (50 and 49 packs) have since been compacted.
- **rc=124 (3h):** 14, all journal-fetch timeouts in one burst from 08:56Z to 09:25Z. That is 8 in `monks/1/journal` (three failed 3-attempt cycles), 4 in `producer/journal` (one failed cycle at 09:17Z), and 2 deferred journal-contention-watch notices about them. The clones are small (175–182M, 8–12 packs), so this is not bloat. None since 09:25Z, and monk 1 claimed and finished work afterwards. It looks like transient GitHub/network slowness against the 45s fetch bound, not a host fault. No `Failed with result` lines.
- **Changed:** nothing.
- **Needs the maintainer:** nothing. If journal-fetch timeouts keep recurring in bursts, compare them against GitHub latency before blaming the host.

## 2026-10-23T05:05Z (oros-health-checkup-20261023-043528): healthy; deployed = origin/main2 `e282e101`, cleared one stale index.lock

- **Load/mem:** load 2.95/2.63/2.42 at 05:00Z. 2 monks are running. 13 GiB of 15 GiB available. Swap reads 797M of 1.0 GiB, up from 0 at 01:30Z; with 13 GiB available this is not pressure.
- **Disk/inodes:** 7% of the overlay used (403G free); inodes 1%. The `/tmp` tmpfs is at 745M (10%), unchanged.
- **Uptime:** 21d11h44m, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `e282e101` (written 04:53Z), the origin/main2 tip. The last fleet/health/oros on origin (04:42:42Z) still shows `roll_status: deferred` on `long-job monk 2 2809s`, targeting `e282e101`. That is the gate waiting for a long job as designed, and the roll completed at 04:53Z. 0 of 289 units failed.
- **Units:** 0 failed garden units. `garden-monk@1..2` are running. `drain-fleet.sh status`: not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 04:32:37Z. Status ok, 73.59M of 180M. The pushes at 02:48, 03:03, 03:18, 03:32, 03:48, 04:03, 04:17 and 04:32Z were all ok, about every 15 minutes. Spend was flat at 72.62M from 02:48Z to 03:32Z, then rose.
- **State clones:** 33 `*/journal` clones. The largest are sysop (50 packs, at the threshold), screening-control (49) and reaper (47). No tmp_pack and no `gc.log`. There was one stale lock: `decisions/journal/.git/index.lock`, empty, from 02:54:09Z (2h09m old), held by no git process (see Changed). Git in the clones went through the fleet repo lock, and two probe commands waited out a transient holder (pid 825830, gone moments later). That is normal contention, not a wedge.
- **rc=124 (3h):** one. At 02:56:53Z the self-heal handler for `garden-triager@kriscendobot-minion.town` exceeded its 600s timeout. It was bounded and cleaned up, and no unit failed. It came 2.7 minutes after the stale index.lock was created, so it may have left that lock, but this is not proven. No `Failed with result` lines.
- **Changed:** removed the stale `decisions/journal/.git/index.lock`.
- **Needs the maintainer:** nothing. If the minion.town triager timeout recurs, look into it.

## 2026-10-23T01:30Z (oros-health-checkup-20261023-012009): healthy; deployed = origin/main2 `32faa8fe`, no changes

- **Load/mem:** load 2.94/2.89/2.74 at 01:23Z. 2 monks are running. 12 GiB of 15 GiB available; swap reads 0.
- **Disk/inodes:** 7% of the overlay used (403G free). The virtiofs garden mount is 60% used; inodes 1%. The `/tmp` tmpfs is at 745M (10%), unchanged since the last run.
- **Uptime:** 21d08h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `32faa8fe`, the origin/main2 tip. fleet/health/oros (00:47:13Z): `roll_status: deployed`, 0 of 289 units failed.
- **Units:** 0 failed garden units. `garden-monk@1..2` are running. `drain-fleet.sh status`: not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 01:02:26Z. Status ok, 72.23M of 180M. The pushes at 23:33, 23:48, 00:02, 00:18, 00:33, 00:48, 01:02 and 01:18Z were all ok, about every 15 minutes. Spend was flat at 72.18M from 23:33Z to 00:33Z and then rose slightly, which matches a quiet board.
- **State clones:** 33 `*/journal` clones. The largest are unblock (49 packs), reaper (47) and screening-control (45), all below the threshold of 50. No tmp_pack, no `gc.log`, and no git `*.lock` older than 30 minutes under any clone's `.git`. No bun/node processes older than 3h.
- **rc=124 (3h):** none in the system journal, and no `Failed with result` lines either.
- **Changed:** nothing.
- **Needs the maintainer:** nothing.

## 2026-10-22T22:20Z (oros-health-checkup-20261022-220533): healthy; deployed = origin/main2 `e93718f2`, no changes

- **Load/mem:** load 2.54/2.36/2.13 at 22:10Z. 2 monks are running. 13 GiB of 15 GiB available. Swap reads 662M of 1.0 GiB used, down from the full 1.0 GiB at 19:45Z; with 13 GiB available this is not pressure.
- **Disk/inodes:** 7% of the overlay used (403G free). The virtiofs garden mount is 59% used; inodes 1%. The `/tmp` tmpfs is at 744M (10%): 2205 small scratch files plus the `/tmp/mmcheck` cache (224M) and `/tmp/jchk` (118M).
- **Uptime:** 21d04h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `e93718f2`, the origin/main2 tip. fleet/health/oros (20:17:39Z): `roll_status: deployed`, 0 of 289 units failed.
- **Units:** 0 failed garden units. `garden-monk@1..2` are running. `drain-fleet.sh status`: not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 22:02:11Z and pushed at 22:02:12Z. Status ok, 71.49M of 180M. The pushes at 20:18, 20:32, 20:48, 21:02, 21:17, 21:32, 21:46 and 22:02Z were all ok, about every 15 minutes, and spend rose monotonically.
- **State clones:** 33 `*/journal` clones. The largest are transcripts (50 packs, at the threshold), reaper (47) and screening-control (43). No tmp_pack, no `gc.log`, and no git `*.lock` older than 30 minutes. No bun/node processes older than 3h.
- **rc=124 (3h):** none in the system journal, and no `Failed with result` lines either.
- **Changed:** nothing.
- **Needs the maintainer:** nothing.

## 2026-10-22T19:45Z (oros-health-checkup-20261022-190509): healthy; deployed `edac084d` (main2 tip `e93718f2` landed after it), cleared 677M of leaked /tmp scratch

- **Load/mem:** load 2.76/2.65/2.66 at 19:40Z. 2 monks are running. 12 GiB of 15 GiB available. Swap reads 1.0 of 1.0 GiB used, but processes in this container hold only about 40 MB of it (the largest is a `claude` at 32 MB). The rest is VM-level pressure, possibly tmpfs pages. Not a problem with 12 GiB available, but worth noting because earlier runs read 0.
- **Disk/inodes:** 7% of the overlay used (403G free). The virtiofs garden mount is 59% used; inodes 1%. The `/tmp` tmpfs (RAM-backed) was at 1.4G; see Changed.
- **Uptime:** 21d02h, no reboot.
- **Deployed vs main2:** oros self-deployed `edac084d` at 19:35Z. Before that, from 19:13Z, the roll was `deferred` with `long-job monk 1 368s`, which is the gate waiting for a long job as designed. fleet/health/oros on origin (19:35:41Z): `roll_status: deployed`, 0 of 289 units failed. Origin/main2 has since moved to `e93718f2` (one commit, a journal-entry fix), so the next roll will pick it up.
- **Units:** 0 failed garden units. `garden-monk@1..2` are running and `hosts/oros` says `monks: 2`. `drain-fleet.sh status`: not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 19:32:44Z and pushed at 19:32:53Z. Status ok, 70.08M of 180M. The pushes at 18:18, 18:32, 18:48, 19:02, 19:18 and 19:32Z were all ok, about every 15 minutes, and spend rose monotonically. The local `journal/` worktree showed the 19:02 sample only because its keeper runs every 30 minutes (last fresh 19:15Z). That is expected lag, not a missed push.
- **State clones:** 33 `*/journal` clones. The largest are transcripts and gardener-scaler (48 packs) and reaper (47), all below the threshold of 50. No tmp_pack, no `gc.log`, and no git `*.lock` older than 30 minutes. No bun/node processes older than 3h.
- **rc=124 (3h):** none in the system journal, and no `Failed with result` lines either.
- **Changed:** removed three leaked mermaid-validation scratch dirs from `/tmp`: `mmcheck.rIxe` (from 10-01), `mmcheck.A9VcKz` (10-16) and `mmcheck-2299346` (10-19), about 224M of node_modules each, none in use. The tmpfs went from 1.4G to 731M. The canonical `/tmp/mmcheck` cache that `skills/mermaid-validation` reuses was left in place. `/tmp/jchk` (118M, 05:06Z, owner unknown, not in use) was also left in place.
- **Needs the maintainer:** nothing.

## 2026-10-22T16:06Z (oros-health-checkup-20261022-155009): healthy; deployed = origin/main2 `b526b1d8`, no changes

- **Load/mem:** load 3.21/2.47/2.34 at 16:04Z. 2 monks are running. 12 GiB of 15 GiB available; swap reads 0.
- **Disk/inodes:** 7% of the overlay used (403G free). The virtiofs garden mount is 58% used; inodes 1%.
- **Uptime:** 20d22h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `b526b1d8`, still the origin/main2 tip. fleet/health/oros (13:50:03Z): `roll_status: deployed`.
- **Units:** 0 failed garden units. `garden-monk@1..2` are running and `hosts/oros` says `monks: 2`. `drain-fleet.sh status`: not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 16:02:45Z and pushed at 16:02:54Z. Status ok, 65.65M of 180M. The pushes at 14:16, 14:31, 14:47, 15:03, 15:17, 15:33, 15:47 and 16:02Z were all ok, about every 15 minutes, and spend rose monotonically.
- **State clones:** 33 `*/journal` clones. The largest are reaper (47 packs), transcripts (44) and fork-watch (41), all below the threshold of 50. No tmp_pack, no `gc.log`, and no git `*.lock` older than 30 minutes. No bun/node processes older than 3h.
- **rc=124 (3h):** none in the system journal.
- **Changed:** nothing.
- **Needs the maintainer:** nothing.

## 2026-10-22T14:05Z (oros-health-checkup-20261022-125008): healthy; deployed = origin/main2 `b526b1d8`, no changes

- **Load/mem:** load 1.84/2.00/1.70 at 13:59Z. 2 monks are running. 12 GiB of 15 GiB available; swap reads 0.
- **Disk/inodes:** 7% of the overlay used (403G free). The virtiofs garden mount is 58% used; inodes 1%.
- **Uptime:** 20d20h, no reboot.
- **Deployed vs main2:** oros self-deployed `b526b1d8`, the origin/main2 tip, at 13:50Z. Before that it was on `91030eca`. From 12:46Z the roll was `deferred` with `long-job monk 2 2891s`, which is the gate waiting for a long job as designed, and it proceeded once that job ended. fleet/health/oros (13:50:03Z): `roll_status: deployed`, 0 of 289 units failed.
- **Units:** 0 failed garden units. No `Failed with result` lines in the system journal for the last 3h. `garden-monk@1..2` are running and `hosts/oros` says `monks: 2`. `drain-fleet.sh status`: not draining. No derotation marker.
- **Budget heartbeat:** the last claude-oros push was at 13:47:26Z. Status ok, 62.86M of 180M (about 35%). The pushes at 12:02, 12:18, 12:32, 12:47, 13:02, 13:18, 13:31 and 13:47Z were all ok, roughly every 15 minutes, and spend rose monotonically.
- **State clones:** 33 `*/journal` clones. The largest are worktree-sweeper and state-clone-keeper (50 packs, at the threshold), fork-watch (49) and reaper (47). No tmp_pack, no `gc.log`, and no git `*.lock` older than 30 minutes. No leaked bun/node processes.
- **rc=124 (3h):** none in the system journal.
- **Changed:** nothing.
- **Needs the maintainer:** nothing.

## 2026-10-22T11:15Z (oros-health-checkup-20261022-093509): healthy; deployed = origin/main2 `91030eca`, no changes

- **Load/mem:** load 1.56/1.79/2.23 at 11:09Z. 2 monks are running. 12 GiB of 15 GiB available; swap reads 0.
- **Disk/inodes:** 7% of the overlay used (403G free). The virtiofs garden mount is 57% used; inodes 1%.
- **Uptime:** 20d17h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `91030eca`, still the origin/main2 tip. fleet/health/oros (2026-10-21 23:58:16Z): `roll_status: deployed`, 0 of 289 units failed.
- **Units:** 0 failed garden units. The three `activating` units (repo-watcher, sysop, worktree-sweeper) had all started within the last 2 minutes. `garden-monk@1..2` are running. `hosts/oros` now says `monks: 2`, written by oros itself at 09:06:55Z (it was 3). This run did not change it. `drain-fleet.sh status`: not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 11:02:14Z and pushed at 11:02:19Z. Status ok, 61.9M of 180M (22% derived). The pushes at 09:53, 10:03, 10:18, 10:32, 10:48 and 11:02Z were all ok. At 10:03Z the reading dipped by 24k (59.86M to 59.83M, 0.04%). The `f9d731f5` re-measure still published it, so the drop was confirmed on re-measure. It is tiny and spend grew again afterwards. This is not the undercount class `f9d731f5` targets.
- **State clones:** 33 `*/journal` clones. The largest are regenerate-topics-counts (48 packs), state-clone-keeper and reaper (47), all below the threshold of 50. No tmp_pack, no `gc.log`, and no git `*.lock` older than 30 minutes in a clone's `.git`. No leaked bun/node processes.
- **rc=124 (3h):** one, a job-level timeout and not a host fault. `endojs-endo-but-for-bots-no-any-typecheck` on monk/1 at 09:16Z hit its own 2400s handler budget (`term-at-wall`, elapsed 2466s) and was classified as transient. The reaper will requeue it.
- **Changed:** nothing.
- **Needs the maintainer:** nothing.

## 2026-10-22T08:05Z (oros-health-checkup-20261022-063509): healthy; deployed = origin/main2 `91030eca`, no changes

- **Load/mem:** load 3.83/3.45/3.49 at 07:52Z. 3 monks are running. 12 GiB of 15 GiB available; swap reads 0.
- **Disk/inodes:** 7% of the overlay used (403G free). The virtiofs garden mount is 54% used; inodes 1%.
- **Uptime:** 20d14h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `91030eca`, still the origin/main2 tip. fleet/health/oros (2026-10-21 23:58:16Z): `roll_status: deployed`.
- **Units:** 0 failed garden units. `garden-monk@1..3` are running. `hosts/oros` says `monks: 3`. `drain-fleet.sh status`: not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 07:48:36Z and pushed at 07:48:47Z. Status ok, 55.7M of 180M (19% derived). The pushes at 06:32, 06:48, 07:03, 07:20, 07:33 and 07:48Z were all ok, and spend rose monotonically.
- **State clones:** 33 `*/journal` clones. The largest are repo-watcher (49 packs), reaper (47) and self-deploy (46), all below the threshold of 50. No tmp_pack, no `gc.log`, and no git `*.lock` older than 30 minutes. No leaked bun/node test daemons. The full `find` over `.garden-state` took about 3 minutes on virtiofs.
- **rc=124 (3h):** one, a job-level timeout and not a host fault. `endojs-endo-but-for-bots-pr1529-gauntlet-undraft` on monk/2 at 05:44Z hit its own 2400s handler budget (`term-at-wall`) and was classified as transient. It now sits in `jobs/plan/`. No `garden-library-link-scan` timeout this window.
- **Changed:** nothing.
- **Needs the maintainer:** nothing.

## 2026-10-22T05:10Z (oros-health-checkup-20261022-033508): healthy; deployed = origin/main2 `91030eca`, no changes

- **Load/mem:** load 2.52/2.36/2.08 at 04:50Z. 3 monks are running. 13 GiB of 15 GiB available; swap reads 0.
- **Disk/inodes:** 7% of the overlay used (403G free). The virtiofs garden mount is 53% used; inodes 1%.
- **Uptime:** 20d11h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `91030eca` (deployed 2026-10-21 23:57Z), still the origin/main2 tip. fleet/health/oros: `roll_status: deployed`.
- **Units:** 0 failed garden units and 0 `NeedDaemonReload=yes`. `garden-monk@1..3` are running. `hosts/oros` says `monks: 3`. `drain-fleet.sh status`: not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 04:48:08Z and pushed at 04:49:10Z. Status ok, 52.4M of 180M (19% derived). The pushes at 04:02, 04:17, 04:32 and 04:49Z were all ok, and spend rose monotonically.
- **State clones:** 33 `*/journal` clones. The largest are regenerate-sections-index (50 packs, at the threshold), repo-watcher (49) and library-link-check (48). No tmp_pack, no `gc.log`, and no git `*.lock` older than 30 minutes inside a clone. The flock files under `receipt-watcher/`, `ci-watcher/` and similar are persistent lockfiles, not stale git locks. No leaked bun/node test daemons.
- **rc=124 (3h):** one, `garden-library-link-scan` at 02:32Z (exceeded SELF_HEAL_HANDLER_TIMEOUT=600s with only 40s of CPU, so it stalled on I/O rather than computing). The same thing happened at 18:32Z yesterday. That is 2 of 12 hourly runs in 12h, and both self-cleared on the next run. Watch it; it does not need a fix yet.
- **Changed:** nothing.
- **Needs the maintainer:** nothing.

## 2026-10-22T00:55Z (oros-health-checkup-20261022-003508): healthy; deployed = origin/main2 `91030eca`, no changes

- **Load/mem:** load 2.26/2.78/2.78 at 00:53Z. 3 monks are running. 12 GiB of 15 GiB available; swap reads 0.
- **Disk/inodes:** 7% of the overlay used (403G free). The virtiofs garden mount is 52% used; inodes 1%.
- **Uptime:** 20d07h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `91030eca` (deployed 23:57Z), the origin/main2 tip. fleet/health/oros (23:58:16Z): `roll_status: deployed`.
- **Units:** 0 failed garden units and 0 `NeedDaemonReload=yes`. `garden-monk@1..3` are running. `hosts/oros` says `monks: 3`. `drain-fleet.sh status`: not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 00:47:37Z and pushed at 00:47:48Z. Status ok, 41.4M of 180M (14% derived). The pushes at 00:03, 00:17, 00:32 and 00:47Z were all ok, and spend rose monotonically.
- **State clones:** 33 `*/journal` clones. The largest are unblock and reaper (47 packs each), below the threshold of 50. No tmp_pack, no `gc.log`, and no git `*.lock` older than 30 minutes. No leaked bun/node test daemons.
- **rc=124 (3h):** none in the system journal. The fleet-brake ledger has 2 transient failures in 3h, far below the threshold.
- **Changed:** nothing.
- **Needs the maintainer:** nothing.

## 2026-10-21T21:45Z (oros-health-checkup-20261021-213508): healthy; deployed = origin/main2 `f9d731f5`, no changes

- **Load/mem:** load 3.17/3.17/3.04 at 21:41Z. 3 monks are running. 12.9 GiB of 15.6 GiB available. Swap is 1 GiB of 1 GiB used, full but flat (page cache).
- **Disk/inodes:** 7% of the overlay used (403G free). The virtiofs garden mount is 53% used; inodes 1%.
- **Uptime:** 20d04h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `f9d731f5` (deployed 20:17Z), the origin/main2 tip. The previous run's fix has rolled. fleet/health/oros (20:17:26Z): `roll_status: deployed`, 0 of 289 units failed.
- **Units:** 0 failed garden units and 0 `NeedDaemonReload=yes`. `garden-monk@1..3` are running. `hosts/oros` says `monks: 3`. No drain and no derotation marker.
- **Budget heartbeat:** claude-oros pushed at 21:21:35Z and 21:32:25Z on origin/journal2. Status ok, 37.5M of 180M. Every push since 19:47Z succeeded, and spend rose monotonically, with no undercount ticks since `f9d731f5` rolled. The root `journal/` worktree read 21:02Z only because `garden-journal-worktree-keeper` syncs it every 30 minutes (last 21:15Z). That is expected.
- **State clones:** 33 `*/journal` clones. The largest are reaper, producer and leader (47 packs each), below the threshold of 50. No tmp_pack, no `gc.log`, and no git `*.lock` older than 30 minutes.
- **rc=124 (3h):** none in the system journal.
- **Changed:** nothing.
- **Needs the maintainer:** nothing.

## 2026-10-21T19:25Z (oros-health-checkup-20261021-183508): healthy; deployed = origin/main2 `b577f3cd`; a fix for one-tick live-spend undercounts landed (`f9d731f5`)

- **Load/mem:** load 2.83/3.21/3.21 at 18:56Z. 3 monks are running. 12.4 GiB of 15.6 GiB available. Swap is 1 GiB of 1 GiB used, full but flat (page cache).
- **Disk/inodes:** 7% of the overlay used (403G free); inodes 1%.
- **Uptime:** 20d01h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `b577f3cd` (deployed 16:50Z), which is the origin/main2 tip at the check. It includes the previous run's `4d57b792` and `1205fd4b`. fleet/health/oros (16:51:39Z): `roll_status: deployed`, 0 of 289 units failed. This run's `f9d731f5` is pending a roll.
- **Units:** 0 failed garden units and 0 `NeedDaemonReload=yes` (289 checked). `garden-monk@1..3` are running. `hosts/oros` says `monks: 3`. No drain and no derotation marker.
- **Budget heartbeat:** claude-oros sampled at 18:48:07Z and pushed at 18:48:21Z. Status ok. Every 15-minute push since 17:18Z succeeded. **Anomaly:** the 18:32Z snapshot published spend **20.3M** between 33.4M (18:18Z) and 35.0M (18:48Z). The 2026-10-20 21:03Z snapshot published **0** between 9.0M and 11.1M. Each is a single-tick undercount of a total that only grows within the window. There is no seven-day rejection in the logs, so the entitlement cutoff did not move. A manual scan now reads 35.1M in 5.5s over 620 files, with jq/xargs exit 0. The undercount is in the permissive direction (more headroom). The root cause was not isolated; a suspect is an incomplete virtiofs readdir or a killed scan under load. 18:32Z was also when `garden-library-link-scan` hit its 600s self-heal bound. That fix is `f9d731f5`, with a test: a reading below the last published spend for the same window is re-measured once, and the larger reading is published.
- **State clones:** 81 journal clones. The largest are fork-watch and reaper (47 packs each) and regenerate-sections-index (40), all below the threshold of 50. No tmp_pack, no `gc.log`, and no git `*.lock` older than 30 minutes. The transcripts clone has no tmp_pack.
- **rc=124 (3h):** one, `garden-library-link-scan` at 18:32Z (exceeded SELF_HEAL_HANDLER_TIMEOUT=600s). That is isolated: hourly runs since 08:27Z finished in about 1 minute of CPU. None in the journal.
- **Changed:** landed `f9d731f5`. Nothing else needed on the host.
- **Pre-existing test failures (same on unmodified main2):** `budget-live-percent-label-test.sh` (the weekly-tokens commit message reads `ok` where the test expects `backoff`) and `live-budget-admission-test.sh` (4 FAILs). `budget-snapshot-publish-retry-test.sh` passes but takes 7m10s under load.
- **Needs the maintainer:** nothing.

## 2026-10-21T16:30Z (oros-health-checkup-20261021-153508): healthy; deployed = `fd6f8a87` (origin/main2 tip at the check); transcripts clone repacked 75 → 2 packs; two maintenance and config fixes landed (`4d57b792`, `1205fd4b`)

- **Load/mem:** load 3.80/3.28/3.38 at 15:40Z, and 4.25/4.14/3.94 by 16:30Z. 3 monks are running. 11 to 13 GiB of 15 GiB available. Swap is 1 GiB of 1 GiB used. It is full but flat (page cache).
- **Disk/inodes:** 7% of the overlay used (404G free). The virtiofs garden mount is 51% used; inodes 1%.
- **Uptime:** 19d22h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `fd6f8a87` (deployed 13:47Z). fleet/health/oros (13:47:55Z): `roll_status: deployed`, 0 of 289 units failed. This run's `4d57b792` and `1205fd4b` are pending a roll.
- **Units:** 0 failed garden units and 0 `NeedDaemonReload=yes`. `garden-monk@1..3` are running. `hosts/oros` says `monks: 3`. No drain and no derotation marker.
- **Budget heartbeat:** claude-oros sampled at 15:32:59Z and pushed at 15:33:09Z. Status ok, 29.9M of 180M (7%). The pushes at 14:47, 15:02, 15:17 and 15:33Z were all ok.
- **State clones:** `transcripts/clone` was at **75 packs / 3.7 GB** even after `fd6f8a87` deployed. Its repack was being killed at exactly 120s on every hourly pass. The cause is that the fleet git wrapper's `GARDEN_REPO_GIT_TIMEOUT=120` silently overrode the script's 1800s repack timeout. That is fixed in `4d57b792`, with a test. I ran the pass once by hand with the bound raised: 75 → 2 packs in 95s, now 3.5 GB. The other clones are at or below 50 packs (monitors/monk-1 is at 50). There is no tmp_pack and no `gc.log`. The leader clone's working tree is frozen at its 2026-10-18 clone, 5,792 commits behind, because that clone is only read through refs. That is expected, but three config readers fell back to that tree ahead of the root journal. That is fixed in `1205fd4b`, with a test. The current values match, so nothing was misread.
- **rc=124 (3h):** none in the journal.
- **Changed:** landed `4d57b792` and `1205fd4b`, and repacked the transcripts clone. Operator slip: I removed an `index.lock` in `decisions/journal` that had just been recreated by a live `reset --hard`. The interrupted plan-queue decision re-landed at 15:56:47Z, and the clone is clean at the tip.
- **Pre-existing test failures (not from this run, same on unmodified main2):** `kimi-opus-fallback-test.sh` (B1 re-route assertions) and `worker-spine-kinds-test.sh` (3 FAILs including `pinnedclaude_m` monk eligibility, and it exceeds 580s under load).
- **Needs the maintainer:** nothing.

## 2026-10-21T13:00Z (oros-health-checkup-20261021-123508): healthy; deployed = origin/main2 `e2d0a90b`; stale transcripts tmp_pack removed, 10 leaked test daemons killed, maintenance fix landed (`fd6f8a87`)

- **Load/mem:** load 2.69/2.92/3.11 at 12:40Z, and 1.77/2.41/2.88 by 13:00Z. 3 monks are running. 12 GiB of 15 GiB available. Swap reads 0 GiB, which is no pressure.
- **Disk/inodes:** 7% of the overlay used (404G free); inodes 1%.
- **Uptime:** 19d19h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `e2d0a90b`, which was the origin/main2 tip at the check. fleet/health/oros (2026-10-20 16:57:18Z): `roll_status: deployed`. This run's `fd6f8a87` is now the new tip and is pending a roll.
- **Units:** 0 failed garden units and 0 `NeedDaemonReload=yes`. `garden-monk@1..3` are running. `hosts/oros` says `monks: 3`. No drain and no derotation marker.
- **Budget heartbeat:** the claude-oros snapshot sampled at 12:33:00Z was written at 12:39:34Z. Status ok, 26.3M of 180M (about 7%).
- **State clones:** the largest journal clones are worktree-sweeper and reaper (47 packs each) and leader (46), below the threshold of 50. The monk clones are 11 to 49 packs, and git's auto-gc keeps cycling them. `transcripts/clone` was at **67 packs / 3.1 GB** and held another stale 171 MB `tmp_pack` (from 11:28Z, with no open fd). That is the second one in two runs, so it is recurring. I removed it. The cause is that `namespace-clone-maintenance.sh` only globbed `*/journal`. That is fixed on main2 in `fd6f8a87`, with a test. The fix adds the transcripts clone and requires each candidate to have its own `.git`. After the next roll, the hourly pass will repack this clone. The full-tree `find` for gc.log and stale locks did not finish within 10 minutes on virtiofs and was killed, so that check is incomplete this run.
- **rc=124 / errors (3h):** none in the journal.
- **Changed:** removed the stale transcripts `tmp_pack`. Killed 10 orphaned `bun` endo-daemon processes (`packages/daemon` `failure-to-start` test, 5 daemon+worker pairs, about 210 MB RSS, started 05:39 to 06:30Z). Their build worktree `project-wt-build-e-93b096c7c63f-5d2f8844` had already been torn down. Landed `fd6f8a87`.
- **Needs the maintainer:** nothing. Optional: the endo-but-for-bots daemon `failure-to-start` test leaks its daemon under bun when the test or job is killed.

## 2026-10-21T09:50Z (oros-health-checkup-20261021-092010): healthy; deployed = origin/main2 `e2d0a90b`; one daemon-reload, one stale tmp_pack removed

- **Load/mem:** load 2.01/1.78/2.28 with 3 monks (2 live `claude -p` including this job). 12 GiB of 15 GiB available. Swap is 1 GiB of 1 GiB used. It is full but flat, with no memory pressure (mostly page cache).
- **Disk/inodes:** 7% of the overlay used (404G free). The virtiofs garden mount is 51% used (227G free); inodes 1%.
- **Uptime:** 19d16h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `e2d0a90b`, the origin/main2 tip (0 behind). fleet/health/oros (2026-10-20 16:57:18Z): `roll_status: deployed`, 0 of 290 units failed.
- **Units:** 0 failed garden units. `hosts/oros` went from `monks: 4` to `monks: 3` at 08:21Z (a bot commit, not this job). The scaler applied it at 08:58Z and stopped `garden-monk@4` at 09:01Z. That left 151 garden units flagged `NeedDaemonReload=yes`. One `systemctl --user daemon-reload` cleared the flag. Not draining. No derotation marker.
- **Budget heartbeat:** claude-oros was last pushed at 09:32:06Z (about 12 minutes before this check). Status ok, 19.7M of 180M (about 11%). The pushes at 08:18, 08:33, 08:47, 09:02, 09:18 and 09:32Z were all ok.
- **State clones:** leader/journal is at 50 packs, which equals the threshold of 50 but does not exceed it. The 10:37Z namespace-clone-maintenance pass will repack it once it goes over. monks/1 has 48 and reaper has 47. No `gc.log`. There was one stale `tmp_pack` (45 MB, from 2026-10-16) in `transcripts/clone`, which namespace-clone-maintenance does not scan. No git process was using it, so it was removed. The `.lock` files older than 10 minutes are persistent flock files. The root repo has 20 packs and no `gc.log`.
- **rc=124 (3h):** none. There are no error-priority entries.
- **Changed:** ran one daemon-reload and removed the stale transcripts `tmp_pack`.
- **Needs the maintainer:** nothing.

## 2026-10-21T06:20Z (oros-health-checkup-20261021-060521): healthy; deployed = origin/main2 `e2d0a90b`, no changes

- **Load/mem:** load 3.22/3.13/3.10 with 4 monks (5 live `claude -p` including this job). 9.6 GiB of 15 GiB available. Swap is 1 GiB of 1 GiB used. It is full but flat, with no memory pressure (mostly page cache).
- **Disk/inodes:** 7% of the overlay used (403G free). The virtiofs garden mount is 51% used (230G free); inodes 1%.
- **Uptime:** 19d13h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `e2d0a90b`, the origin/main2 tip (0 behind). fleet/health/oros (2026-10-20 16:57:18Z): `roll_status: deployed`.
- **Units:** 0 failed garden units. `NeedDaemonReload=no`. `garden-monk@1..4` are running. `hosts/oros` says `monks: 4`. Not draining. No derotation marker.
- **Budget heartbeat:** claude-oros was last pushed at 06:01:52Z (about 10 minutes before this check). Status ok, 13.6M of 180M (about 8%). The pushes at 05:02, 05:17, 05:32, 05:47 and 06:01Z were all ok.
- **State clones:** the largest are monks/3 and gauntlet (49 packs each) and reaper (47), below the threshold of 50. No tmp_pack and no `gc.log`. The `.lock` files older than 10 minutes are persistent flock files, not git locks. The root repo is down to 9 packs (48 at 03:20Z), so git's automatic gc ran, and there is no `gc.log`.
- **rc=124 (3h):** two, both benign. At 04:09Z the triager for kriscendobot/endo-but-for-bots hit its 600s self-heal bound once. At 05:05Z monk/3's posted-follow-up gate blocked `build-minion-town-agent-last-active` after 930s, because the job described a follow-up but did not post it. The gate reports that as rc=124 so the job requeues. It did, and endolin claimed it at 05:43Z. There are no error-priority entries.
- **Changed:** nothing.
- **Needs the maintainer:** nothing.

## 2026-10-21T03:20Z (oros-health-checkup-20261021-030508): healthy; deployed = origin/main2 `e2d0a90b`, no changes

- **Load/mem:** load 3.62/3.19/3.17 with 4 monks (3 live `claude -p`). 12 GiB of 15 GiB available. Swap is 1 GiB of 1 GiB used. It is full but flat, with no memory pressure (mostly page cache).
- **Disk/inodes:** 7% of the overlay used (404G free). The virtiofs garden mount is 51% used (227G free); inodes 1%.
- **Uptime:** 19d9h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `e2d0a90b`, the origin/main2 tip (0 behind). fleet/health/oros (2026-10-20 16:57:18Z): `roll_status: deployed`.
- **Units:** 0 failed garden units. `NeedDaemonReload=no`, so the 00:05Z daemon-reload held. `garden-monk@1..4` are running. `hosts/oros` says `monks: 4`. Not draining. No derotation marker.
- **Budget heartbeat:** the newest claude-oros snapshot is 03:03:07Z in the state clones. The root `journal/` worktree still showed 02:32:45Z, which made it look 37 minutes stale, but that worktree only lags behind origin. Status ok, about 11.7M of 180M (about 6%). The pushes at 01:32, 01:47, 02:02, 02:18 and 02:32Z were all ok, and the scaler logged no publish warnings.
- **State clones:** the largest are monks/4 (49 packs), sysop, reaper and monitors/monk-2 (47 each), below the threshold of 50. No tmp_pack and no `gc.log`. The `index.lock` files were all live. The oldest, screening-control at about 4.5 minutes, belonged to a running `reset --hard` behind a peer's concurrent `minion-town-screening.sh status` calls, and it cleared on its own. The root repo has 48 packs (41 at 00:05Z) and no `gc.log`. Git's automatic gc should repack it at 50. `repo-locks` holds 10.4k keys, with about 700 new per day. The 7-day pruner is working: only 6 keys are older than 7 days.
- **rc=124 (3h):** none. There are no error-priority entries.
- **Changed:** nothing.
- **Needs the maintainer:** nothing.

## 2026-10-21T00:05Z (oros-health-checkup-20261020-235008): healthy; deployed = origin/main2 `e2d0a90b`; cleared a host-wide stale unit-config flag with one daemon-reload

- **Load/mem:** load 3.01/2.96/3.04. 13 GiB of 15 GiB available. Swap is 1 GiB of 1 GiB used. It is full but flat, with no memory pressure (mostly page cache).
- **Disk/inodes:** 7% of the overlay used (404G free). The virtiofs garden mount is 51% used (228G free); inodes 1%.
- **Uptime:** 19d6h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `e2d0a90b`, the origin/main2 tip (0 behind). fleet/health/oros (16:57:18Z): `roll_status: deployed`, 0 of 290 units failed.
- **Units:** 0 failed garden units. `garden-monk@1..4` are running. `hosts/oros` says `monks: 4`. Not draining. No derotation marker. Only this job's `claude -p` was live; the other monks were idle.
- **Budget heartbeat:** claude-oros was last pushed at 23:32:26Z (about 23 minutes before this check). Status ok, 11.15M of 180M (about 6%). The last 5 pushes were all ok, at 22:33, 22:48, 23:03, 23:18 and 23:32Z. Spend has been flat since 22:33 because the monks are idle, not because the meter is stuck.
- **State clones:** the largest are sysop (48 packs), reaper (47), monitors/monk-4 (46) and fork-watch (46), below the threshold of 50. No tmp_pack and no `gc.log`. The six `index.lock` files are all under 2 minutes old, so they are live. The root repo has 41 packs (up from 9 at 11:30Z) and no `gc.log`. Git's automatic gc should repack it at 50.
- **rc=124 (3h):** one, journal-contention-watch's notice delivery at 22:45Z (`action=close rc=124`, deferred). It is benign. There are no error-priority entries.
- **Changed:** every garden unit showed `NeedDaemonReload=yes` from 10:21Z. The scaler re-enabled `garden-monk@2..4` with `enable --no-reload` after the weekly window reset, and that changed the unit-directory mtime. Since then each status probe has logged 4 "changed on disk" warnings (about 2.9k lines in 24h). One `systemctl --user daemon-reload` took 15.5s and cleared the flag. I did not change the code: `--no-reload` is intentional (install-units.sh scale; run-test.sh asserts no reload per tick), so the flag will come back after the next scale-up.
- **Needs the maintainer:** nothing. Optional: decide whether the scaler should do one bounded daemon-reload after a tick that newly enables a unit. This only happens on scale-up, not every tick.

## 2026-10-20T20:40Z (oros-health-checkup-20261020-203519): healthy; deployed = origin/main2 `e2d0a90b`, no changes

- **Load/mem:** load 4.33/3.04/2.79 with 4 monks running. 12 GiB of 15 GiB available. Swap is 1023 MiB of 1 GiB used. It is full but flat, with no memory pressure (mostly page cache).
- **Disk/inodes:** 7% of the overlay used (403G free). The virtiofs garden mount is 51% used (230G free); inodes 1%.
- **Uptime:** 19d3h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `e2d0a90b`, the origin/main2 tip (0 behind). fleet/health/oros (16:57:18Z): `roll_status: deployed`, 0 of 290 units failed.
- **Units:** 0 failed garden units. `garden-monk@1..4` are running. `hosts/oros` says `monks: 4`. Not draining. No derotation marker.
- **Budget heartbeat:** claude-oros was last pushed at 20:32:45Z (about 7 minutes before this check). Status ok, 8.87M of 180M (about 5%). The last 5 pushes were all ok, at 19:32, 19:47, 20:03, 20:18 and 20:32Z.
- **State clones:** the largest are transcripts (49 packs), reaper (47) and leader (47), below the threshold of 50. No tmp_pack, no `gc.log`, and no git `.lock` files older than an hour. The root repo has 31 packs and no `gc.log`.
- **rc=124 (3h):** none. There are no error-priority entries in the system journal.
- **Changed:** nothing.
- **Needs the maintainer:** nothing.

## 2026-10-20T17:45Z (oros-health-checkup-20261020-173518): healthy; deployed = origin/main2 `e2d0a90b`, no changes

- **Load/mem:** load 2.60/2.57/2.83 with 4 monks running. 12 GiB of 15 GiB available. Swap is 1 GiB of 1 GiB used. It is full but flat, with no memory pressure (mostly page cache).
- **Disk/inodes:** 7% of the overlay used (403G free). The virtiofs garden mount is 53% used (221G free); inodes 1%.
- **Uptime:** 19d0h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `e2d0a90b`, the origin/main2 tip (0 behind). Self-deploy advanced at 16:56Z. fleet/health/oros (16:57:18Z): `roll_status: deployed`.
- **Units:** 0 failed garden units. `garden-monk@1..4` are running. `hosts/oros` says `monks: 4`. Not draining. No derotation marker.
- **Budget heartbeat:** claude-oros was last pushed at 17:32Z (about 13 minutes before this check). Status ok, 6.48M of 180M (about 4%). The last 5 pushes were all ok, at 16:32, 16:47, 17:03, 17:18 and 17:32Z.
- **State clones:** the largest are gardener-scaler (48 packs), reaper (47) and transcripts (46), below the threshold of 50. No tmp_pack, no `gc.log`, and no git `.lock` files older than an hour. The root repo has 24 packs and no `gc.log`.
- **rc=124 (3h):** none. There are no error-priority entries in the system journal.
- **Changed:** nothing.
- **Needs the maintainer:** nothing.

## 2026-10-20T14:30Z (oros-health-checkup-20261020-142008): healthy; deployed `8a2b6a63`, 1 behind origin/main2 `3bab9998` (deploy deferring behind a long job), no changes

- **Load/mem:** load 3.30/2.99/3.13 with 4 monks running. 12 GiB of 15 GiB available. Swap is 1 GiB of 1 GiB used. It is full but flat, with no memory pressure (mostly page cache).
- **Disk/inodes:** 7% of the overlay used (403G free). The virtiofs garden mount is 52% used (225G free); inodes 1%.
- **Uptime:** 18d21h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `8a2b6a63` (self-deploy advanced at 13:13Z). origin/main2 is `3bab9998`, 1 commit ahead (the weaver handler-timeout default). `upgrade-ready` was refreshed at 14:22Z. Self-deploy is deferring behind `long-job monk 3` (631s elapsed at 14:24Z). This is the normal wait, with no gate timeouts. fleet/health/oros (13:14:41Z): `roll_status: deployed`, 0 of 290 units failed.
- **Units:** 0 failed garden units. `garden-monk@1..4` are running. `hosts/oros` says `monks: 4`. Not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 14:02:59Z (about 25 minutes before this check). Status ok, 5.82M of 180M (2%). The last 5 pushes were all ok, at 13:03, 13:18, 13:32, 13:48 and 14:03Z. There is no publish-outage latch.
- **State clones:** the largest are repo-watcher (50 packs), gardener-scaler (48) and reaper (47). That is at or below the threshold of 50. No tmp_pack, no `gc.log`, and no git `.lock` files older than an hour. The root repo has 15 packs and no `gc.log`.
- **rc=124 (3h):** none. There are no error-priority entries in the system journal.
- **Changed:** nothing.
- **Needs the maintainer:** nothing.

## 2026-10-20T11:30Z (oros-health-checkup-20261020-112008): healthy; deployed = origin/main2 `d68ce6d0`, no changes

- **Load/mem:** load 2.78/3.02/2.84 (higher than at 08:30Z because 4 monks are now running). 12 GiB of 15 GiB available. Swap is 1 GiB of 1 GiB used. It is full but flat, with no memory pressure (mostly page cache).
- **Disk/inodes:** 7% of the overlay used (404G free). The virtiofs garden mount is 52% used (226G free); inodes 1%.
- **Uptime:** 18d18h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `d68ce6d0`, the origin/main2 tip (0 behind). fleet/health/oros: `roll_status: deployed`.
- **Units:** 0 failed garden units. `garden-monk@1..4` are running. `hosts/oros` says `monks: 4` (updated 10:50:34Z by oros itself, after the weekly window reset at 10:00Z). Not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 11:02:20Z (about 25 minutes before this check). Status ok. The new weekly window started at 10:00Z, and spend is 1.74M of 180M (about 1%). The last 5 pushes were all ok, at 10:02, 10:17, 10:35, 10:47 and 11:02Z.
- **State clones:** the largest are regenerate-topics-counts (49 packs), state-clone-keeper (48) and reaper (47), below the threshold of 50. No tmp_pack and no `gc.log`. The `index.lock` files in fork-watch and gardener-scaler are less than an hour old, so they are live, not stale. The root repo has 9 packs and no `gc.log`.
- **rc=124 (3h):** none. There are also no garden errors in the system journal.
- **Changed:** nothing.
- **Needs the maintainer:** nothing. The weekly quota reset at 10:00Z, so the 81% from the earlier runs is cleared.

## 2026-10-20T08:30Z (oros-health-checkup-20261020-082008): healthy; deployed = origin/main2 `d68ce6d0`, no changes

- **Load/mem:** load 2.05/2.43/2.57. 13 GiB of 15 GiB available. Swap is 1023 MiB of 1 GiB used (1018 MiB at 05:35Z). It is full but flat, with no memory pressure (13 GiB available, mostly page cache).
- **Disk/inodes:** 7% of the overlay used (404G free). The virtiofs garden mount is 50% used (232G free); inodes 1%.
- **Uptime:** 18d15h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `d68ce6d0`, the origin/main2 tip (0 behind). fleet/health/oros (07:19:59Z): `roll_status: deployed` at `d68ce6d0`.
- **Units:** 0 failed garden units. Only `garden-monk@1` is running (this check-up). `hosts/oros` says `monks: 1`. Not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 08:02:52Z (about 23 minutes before this check; the live file was rewritten at 08:15Z), status ok, 81% used (derived), the same as at 05:35Z.
- **State clones:** the largest are reaper (47 packs), regenerate-topics-counts (46), and state-clone-keeper and gardener-scaler (45 each), below the threshold of 50. The 50-pack clones from 05:35Z have been repacked. No tmp_pack and no `gc.log`. Three `index.lock` files (gardener-scaler, repo-watcher, sysop) belonged to `reset --hard` processes that were still running, so none were stale. The root repo is down to 2 packs (44 at 05:35Z) and has no `gc.log`.
- **rc=124 (3h):** none in the system journal.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `monks: 1` latency question still stands. Quota is flat at 81% of the weekly window, below the 90% policy line.

## 2026-10-20T05:35Z (oros-health-checkup-20261020-050509): healthy; deployed = origin/main2 `6761cdb0`, no changes

- **Load/mem:** load 0.90/1.56/1.84. 13 GiB of 15 GiB available. Swap is 1018 MiB of 1 GiB used (1023 MiB at 02:40Z). It is effectively full but flat, with no memory pressure (13 GiB available, mostly page cache).
- **Disk/inodes:** 7% of the overlay used (404G free). The virtiofs garden mount is 50% used (235G free); inodes 1%.
- **Uptime:** 18d12h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `6761cdb0`, the origin/main2 tip (0 behind). Self-deploy advanced at 03:05Z. fleet/health/oros (03:05:40Z): `roll_status: deployed`.
- **Units:** 0 failed garden units. Only `garden-monk@1` is running (this check-up). `hosts/oros` says `monks: 1`. Not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 05:17:55Z (about 11 minutes before this check), status ok, 81% used (derived).
- **State clones:** regenerate-sections-index and fleet-health have 50 packs each, at the threshold (the repack triggers only above 50). library-link-check has 49 and reaper 47. No tmp_pack, no `gc.log`, and no git `.lock` files older than an hour in the clones. The root repo has 44 packs and no `gc.log`.
- **rc=124 (3h):** none.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `monks: 1` latency question still stands. Quota is at 81% of the weekly window, below the 90% policy line but climbing (77% at 02:40Z).

## 2026-10-20T02:40Z (oros-health-checkup-20261020-020509): healthy; deployed `aca90c21`, 2 behind origin/main2 `6761cdb0` (deploy pending behind this job), no changes

- **Load/mem:** load 1.50/0.94/1.11. 13 GiB of 15 GiB available. Swap is 1023 MiB of 1 GiB used (874 MiB at 00:45Z), with no memory pressure (13 GiB available, mostly page cache).
- **Disk/inodes:** 7% of the overlay used (404G free). The virtiofs garden mount is 48% used (240G free); inodes 1%.
- **Uptime:** 18d09h, no reboot.
- **Deployed vs main2:** root HEAD and `.garden-state/deploy/deployed-sha` are `aca90c21` (self-deploy advanced at 01:42Z after deferring at 01:31Z behind `long-job monk 1`). origin/main2 is now `6761cdb0`, 2 commits ahead (minion-town clip changes only). `upgrade-ready` was refreshed at 02:32Z. The deploy will wait behind this check-up (monk 1) as before, with no gate timeouts. fleet/health/oros (01:42:09Z): `roll_status: deployed`, 0 of 287 units failed.
- **Units:** 0 failed garden units. Only `garden-monk@1` is running (this check-up). `hosts/oros` says `monks: 1`. Not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 02:02:52Z (about 35 minutes before this check), status ok, 77% used (derived).
- **State clones:** the largest are regenerate-sections-index, reaper and fleet-health (47 packs each), below the threshold of 50. No tmp_pack, no `gc.log`, and no git `.lock` files older than an hour. The root repo has 37 packs and no `gc.log`.
- **rc=124 (3h):** none.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `monks: 1` latency question still stands. Quota is at 77% of the weekly window, below the 90% policy line.

## 2026-10-20T00:45Z (oros-health-checkup-20261019-230509): healthy; deployed = origin/main2 `6e3755be`, no changes

- **Load/mem:** load 2.00/1.95/1.41. 13 GiB of 15 GiB available. Swap is 874 MiB of 1 GiB used (872 MiB at 20:55Z), with no memory pressure.
- **Disk/inodes:** 7% of the overlay used (404G free). The virtiofs garden mount is 48% used (242G free); inodes 1%.
- **Uptime:** 18d07h, no reboot.
- **Deployed vs main2:** `.garden-state/deploy/deployed-sha` is `6e3755be`, the origin/main2 tip (0 behind). fleet/health/oros (20:51:37Z) now says `roll_status: deployed` at `6e3755be`.
- **Units:** 0 failed garden units. Only `garden-monk@1` is running (this check-up). `hosts/oros` says `monks: 1`. Not draining. No derotation marker (`.garden-state/worker-derotate` is the state clone, not a marker).
- **Budget heartbeat:** claude-oros sampled at 00:02:01Z (about 40 minutes before this check; the live file was rewritten at 00:15Z), status ok, 77% used (derived).
- **State clones:** the largest are reaper (47 packs), regenerate-sections-index (46) and repo-watcher (45), below the threshold of 50. No tmp_pack, no `gc.log`. One `fork-watch` `index.lock` seen was transient (gone seconds later). The root repo has 30 packs and no `gc.log`.
- **rc=124 (3h):** none.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `monks: 1` latency question still stands. Quota is at 77% of the weekly window, below the 90% policy line.

## 2026-10-19T20:55Z (oros-health-checkup-20261019-195011): healthy; deployed = origin/main2 `6e3755be`, no changes

- **Load/mem:** load 1.05/1.88/2.04. 13 GiB of 15 GiB available. Swap is 872 MiB of 1 GiB used (936 MiB at 19:08Z), with no memory pressure.
- **Disk/inodes:** 7% of the overlay used (404G free). The virtiofs garden mount is 47% used (246G free); inodes 1%.
- **Uptime:** 18d03h, no reboot.
- **Deployed vs main2:** root HEAD and `.garden-state/deploy/deployed-sha` are `6e3755be`, the origin/main2 tip (0 behind). Self-deploy advanced from `becf30d3` at 20:51:33Z. It had deferred at 20:42Z (`long-job monk 1 504s`) and went through once that job finished. The fleet/health/oros record (20:42:50Z) still says `roll_status: deferred` and has not yet republished after the deploy. `deploy/leader-sha` is still `becf30d3`.
- **Units:** 0 failed garden units. Only `garden-monk@1` is running (this check-up). `hosts/oros` says `monks: 1`. Not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 20:32:45Z (20 minutes before this check, in the live worktree), status ok, 77% used (derived).
- **State clones:** the largest are reaper (47 packs), unblock (46), leader and fleet-health (44 each), below the threshold of 50. No tmp_pack, no `gc.log`. The `.lock` files over an hour old are persistent empty flock files, not stale git locks. The root repo has 22 packs and no `gc.log`.
- **rc=124 (3h):** none.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `monks: 1` latency question still stands. Quota is at 77% of the weekly window, below the 90% policy line.

## 2026-10-19T19:08Z (oros-health-checkup-20261019-165008): healthy; deployed = origin/main2 `becf30d3`, no changes

- **Load/mem:** load 0.97/0.78/0.87. 13 GiB of 15 GiB available. Swap is 936 MiB of 1 GiB used (flat since 14:45Z), with no memory pressure.
- **Disk/inodes:** 7% of the overlay used (404G free). The virtiofs garden mount is 50% used (234G free); inodes 1%.
- **Uptime:** 18d01h, no reboot.
- **Deployed vs main2:** root HEAD, `deploy/leader-sha` and origin/main2 are all `becf30d3` (0 commits behind). fleet/health/oros: `roll_status: deployed`.
- **Units:** 0 failed garden units. Only `garden-monk@1` is running (this check-up). `hosts/oros` says `monks: 1`. Not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 18:33:28Z (33 minutes before this check, in the live worktree), status ok, 75% used (derived).
- **State clones:** the largest are self-deploy (48 packs), reaper and producer (47 each), below the threshold of 50. No tmp_pack, no `gc.log`. The `.lock` files over an hour old are all persistent flock files, not stale git locks. The root repo has 16 packs and no `gc.log`.
- **rc=124 (3h):** none.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `monks: 1` latency question still stands. Quota is at 75% of the weekly window, below the 90% policy line.

## 2026-10-19T14:45Z (oros-health-checkup-20261019-133509): healthy; deployed = origin/main2 `becf30d3`, no changes

- **Load/mem:** load 1.4/1.1/1.0. 13 GiB of 15 GiB available. Swap is 939 MiB of 1 GiB used (896 MiB at 12:10Z), with no memory pressure.
- **Disk/inodes:** 6% of the overlay used (404G free). The virtiofs garden mount is 49% used (236G free); inodes 1%.
- **Uptime:** 17d21h, no reboot.
- **Deployed vs main2:** root HEAD and `deploy/deployed-sha` are `becf30d3`, the origin/main2 tip (0 commits behind). fleet/health/oros: `roll_status: deployed`.
- **Units:** 0 failed garden units. Only `garden-monk@1` is running (this check-up). `hosts/oros` says `monks: 1`. Not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 14:31:54Z (about 10 minutes before this check, in the fresher state clones; the live worktree shows 14:02:50Z), status ok, 72% used (derived).
- **State clones:** the largest are self-deploy (48 packs), reaper (47) and repo-watcher (46), below the threshold of 50. No tmp_pack, no `gc.log`, no `.lock` files over an hour old. The root repo's auto-gc has run: it is down to 6 packs (49 at 12:10Z), with no `gc.log`.
- **rc=124 (3h):** one. At 13:03Z `endojs-endo-but-for-bots-pr1498-gauntlet-undraft` ran past its own 2400s handler budget (`term-at-wall`, elapsed 2409s). It was classified as transient, and the job is now parked in `jobs/plan/`. This is a job-level deadline overrun, not a host fault.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `monks: 1` latency question still stands. Quota is at 72% of the weekly window, below the 90% policy line. The pr1498 undraft job, now parked, may need someone to look at why it outruns its 2400s budget.

## 2026-10-19T12:10Z (oros-health-checkup-20261019-103508): healthy; deployed = origin/main2 `becf30d3`, no changes

- **Load/mem:** load 1.8/1.4/1.1. 13 GiB of 15 GiB available. Swap is 896 MiB of 1 GiB used (flat since 09:45Z), with no memory pressure.
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1%.
- **Uptime:** 17d19h, no reboot.
- **Deployed vs main2:** root HEAD and `deploy/deployed-sha` are `becf30d3`, the origin/main2 tip (0 commits behind). fleet/health/oros: `roll_status: deployed`.
- **Units:** 0 failed garden units. Only `garden-monk@1` is running (this check-up). `hosts/oros` says `monks: 1`. Not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 11:32:28Z (33 minutes before this check, in the live worktree), status ok, 72% used (derived). The raw `spend` (181.4M) now exceeds the nominal `cap` (180M) while `used_percent` stays 72%, so the cap figure is not the binding limit; informational only.
- **State clones:** the largest are producer (49 packs), self-deploy (48), reaper and worktree-sweeper (47 each), below the threshold of 50. No tmp_pack, no `gc.log`, no `.lock` files over an hour old in the clone `.git` dirs. The root repo has 49 packs (43 at 09:45Z) and no `gc.log`; git's auto-gc should trigger at 50.
- **rc=124 (3h):** none.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `monks: 1` latency question still stands. Quota is at 72% of the weekly window, below the 90% policy line.

## 2026-10-19T09:45Z (oros-health-checkup-20261019-073508): healthy; deployed = origin/main2 `becf30d3`, no changes

- **Load/mem:** load 2.6/2.0/1.9. 13 GiB of 15 GiB available. Swap is 895 MiB of 1 GiB used (up slightly from 880 MiB at 06:00Z), with no memory pressure.
- **Disk/inodes:** 6% of the overlay used (404G free). The virtiofs garden mount is 49% used (238G free); inodes 1%.
- **Uptime:** 17d16h, no reboot.
- **Deployed vs main2:** root HEAD and `deploy/deployed-sha` are `becf30d3`, the origin/main2 tip (0 commits behind). fleet/health/oros: `roll_status: deployed`.
- **Units:** 0 failed. `hosts/oros` says `monks: 1` (this check-up is the running job). Not draining. No derotation marker (the `worker-derotate/journal.lock` is the persistent flock file, not a marker).
- **Budget heartbeat:** claude-oros sampled at 09:02:41Z (40 minutes before this check, in the live worktree), status ok, 71% used (174.1M of 180M).
- **State clones:** the largest are self-deploy (48 packs) and reaper (47), below the threshold of 50. No tmp_pack, no `gc.log`, no `.lock` files over an hour old in the clone `.git` dirs. The root repo has 43 packs (18 at 23:45Z) and no `gc.log`; it is nearing git's auto-gc pack limit of 50, which is expected and should self-trigger.
- **rc=124 (3h):** none.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `monks: 1` latency question still stands. Quota is at 71% of the weekly window, below the 90% policy line.

## 2026-10-19T06:00Z (oros-health-checkup-20261019-043508): healthy; deployed = origin/main2 `becf30d3`, no changes

- **Load/mem:** load 1.1/0.9/0.8. 13 GiB of 15 GiB available. Swap is 880 MiB of 1 GiB used (steady since 23:45Z), with no memory pressure.
- **Disk/inodes:** 6% of the overlay used (404G free). The virtiofs garden mount is 48% used (240G free); inodes 1%.
- **Uptime:** 17d12h, no reboot.
- **Deployed vs main2:** root HEAD and `deploy/deployed-sha` are `becf30d3`, the origin/main2 tip (0 commits behind). fleet/health/oros: `roll_status: deployed`.
- **Units:** 0 failed. `hosts/oros` says `monks: 1` (this check-up is the running job). Not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 05:32:11Z (28 minutes before this check), status ok, 68% used (170.7M of 180M).
- **State clones:** the largest are self-deploy (48 packs) and reaper (47), below the threshold of 50. No tmp_pack, no `gc.log`, no stale `.lock` files over an hour old in the clone `.git` dirs.
- **rc=124 (3h):** none.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `monks: 1` latency question still stands.

## 2026-10-19T01:50Z (oros-health-checkup-20261019-012009): healthy; deployed = origin/main2 `becf30d3`, no changes

- **Load/mem:** load 2.4/1.4/1.1. 13 GiB of 15 GiB available. Swap is 868 MiB of 1 GiB used (unchanged since 23:45Z), with no memory pressure.
- **Disk/inodes:** 6% of the overlay used (404G free). The virtiofs garden mount is 50% used (234G free); inodes 1%.
- **Uptime:** 17d8h, no reboot.
- **Deployed vs main2:** root HEAD and `deploy/deployed-sha` are `becf30d3`, the origin/main2 tip (0 commits behind). fleet/health/oros: `roll_status: deployed`.
- **Units:** 0 failed. Only monk 1 is running (this check-up). `hosts/oros` says `monks: 1`. Not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 01:32:27Z (15 minutes before this check), status ok, 66% used (164.7M of 180M).
- **State clones:** the largest are sysop and self-deploy (48 packs each) and reaper (47), below the threshold of 50. No tmp_pack, no `gc.log`. The `.lock` files over an hour old are persistent flock files (cursors, ci-watcher verify locks), not stale git locks.
- **rc=124 (3h):** none.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `monks: 1` latency question still stands.

## 2026-10-18T23:45Z (oros-health-checkup-20261018-220508): healthy; deployed = origin/main2 `3c5843b8`; removed one stale tmp_pack

- **Load/mem:** load 1.4/1.8/1.5. 13 GiB of 15 GiB available. Swap is 860 MiB of 1 GiB used (it was 0 at 21:05Z), but there is no memory pressure.
- **Disk/inodes:** 6% of the overlay used (404G free). The virtiofs garden mount is 49% used (238G free); inodes 1% (8.3M).
- **Uptime:** 17d6h, no reboot.
- **Deployed vs main2:** root HEAD and `deploy/deployed-sha` are `3c5843b8`, the origin/main2 tip, deployed at 23:28Z. Before that, self-deploy deferred every 3 minutes from about 22:50Z, behind a long job on monk 1 (over 2900s). That is the designed wait, not a failure. fleet/health/oros was last written at 23:09Z (`roll_status: deferred`, target `3c5843b8`, 0 of 287 units failed), so it had not caught up with the deploy yet.
- **Units:** 0 failed, 144 garden units active. Only monk 1 is running (this check-up). `hosts/oros` says `monks: 1`. Not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 23:02:12Z in the live worktree, 33 minutes before this check (the known live-copy lag), status ok, 65% used.
- **State clones:** the largest are sysop (49 packs), screening-control (48) and reaper (47). screening-control had an orphaned 96 MB `tmp_pack` from 21:04Z, which I deleted; the sysop `tmp_pack` was from a fetch in progress. No `gc.log`. The root repo has 18 packs and no `gc.log`. No stale `.lock` files in the clone `.git` dirs.
- **rc=124 (3h):** none new. The only one in the window is the 20:38Z `garden-gardener-scaler` self-heal bound, already noted at 21:05Z.
- **Changed:** deleted the stale screening-control `tmp_pack`.
- **Needs the maintainer:** nothing new. The `monks: 1` latency question still stands: a single monk slot running a long job blocks both the deploy and this check-up.

## 2026-10-18T21:05Z (oros-health-checkup-20261018-190508): healthy; deployed = origin/main2 `8c13456a`, no changes

- **Load/mem:** load 1.8/2.2/2.0. 13 GiB of 15 GiB available, no swap in use.
- **Disk/inodes:** 6% of the overlay used (404G free). The virtiofs garden mount is 48% used (240G free); inodes 1% (8.3M).
- **Uptime:** 17d3h, no reboot.
- **Deployed vs main2:** root HEAD is `8c13456a`, the origin/main2 tip. deploy-garden recorded it at 19:25:58Z, with a coherent release boundary (143 units active, 0 restarts deferred). fleet/health/oros (19:26Z): `roll_status: deployed`, 0 of 287 units failed.
- **Units:** 0 failed. Only monk 1 is running (this check-up). `hosts/oros` says `monks: 1`. Not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 20:41:30Z, 16 minutes before this check, status ok, 64% used (155.0M of 180M).
- **State clones:** transcripts and gardener-scaler have 50 packs and screening-control has 48, right at the threshold. A manual `git gc` left the counts unchanged, because the fleet git wrapper lock was busy. No tmp_pack, no `gc.log`. The root repo has 9 packs and no `gc.log`.
- **rc=124 (3h):** one, `garden-gardener-scaler` at 20:28 to 20:38Z: a silent 10-minute hang (32s CPU) that the self-heal bound cut off. The ticks before and after ran in about 10s. It happened once; no action taken.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `monks: 1` latency question still stands.

## 2026-10-18T17:10Z (oros-health-checkup-20261018-155009): healthy; deployed = origin/main2 `3a743ca7`, no changes

- **Load/mem:** load 2.0/1.2/1.1. 12 GiB of 15 GiB available, no swap in use.
- **Disk/inodes:** the virtiofs garden mount is 48% used (244G free); inodes 1%. /tmp is 10% used.
- **Uptime:** 16d23h, no reboot.
- **Deployed vs main2:** root HEAD is `3a743ca7` (the sysop `--no-block` fix from the previous run), which is the origin/main2 tip. fleet/health/oros (15:31Z): `roll_status: deployed`. One `deploy-garden DEFERRED` at 14:45Z (monk 1 mid-job); the roll completed afterwards.
- **Units:** 0 failed. Only monk 1 is running (this check-up). `hosts/oros` says `monks: 1`. Not draining. No derotation marker.
- **Budget heartbeat:** claude-oros sampled at 16:32:28Z in the live worktree (30 minutes before this check, the known live-copy lag), status ok, 63% used (152.3M of 180M).
- **State clones:** the largest have 48 packs (screening-control) and 47 (self-deploy, reaper), below the threshold of 50. No tmp_pack, no `gc.log`, no stale `.lock` in the clone `.git` dirs. The root repo has 48 packs and no `gc.log`.
- **rc=124 (3h):** none.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `monks: 1` latency question from the 14:21Z note still stands.

## 2026-10-18T14:21Z (oros-health-checkup-20261018-123528): healthy; claimed 1.5h late behind long gauntlet jobs; fixed a sysop wedge on main2

- **Load/mem:** load 1.8/2.3/2.2. 13 GiB of 15 GiB available.
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (167k). The virtiofs garden mount is 47% used.
- **Uptime:** 16d21h, no reboot.
- **Deployed vs main2:** root at `05d833a2`, which was the origin/main2 tip when this run started. fleet/health/oros (10:25Z): `roll_status: deployed`, 0 of 287 units failed. This run's fix moved main2 to `3a743ca7`, so the next roll will pick it up. The journal `deploy/leader-sha` still reads `b8abbe64`; the leader issue from the previous note may be unresolved.
- **Units:** 0 failed. Only monk 1 is running (this check-up). `hosts/oros` says `monks: 1`. Not draining. No derotation marker for oros.
- **Budget heartbeat:** claude-oros sampled at 14:02:48Z (producer clones), status ok, 57% used. The live worktree copy (13:32Z) is lagging, but the meter itself is not.
- **State clones:** repo-watcher has 50 packs, right at the threshold; the next largest are reaper (47) and screening-control (46). No tmp_pack, no `gc.log`. The `.lock` files older than 30 minutes are persistent flock files.
- **rc=124 (3h):** three, all `garden-sysop` at 13:33, 13:43 and 13:53Z (see below). No deploy-gate timeouts.
- **Why this run was late:** the only monk ran `minion.town-pr200-gauntlet-fix-5` (11:05 to 12:57Z) and then `pr201-gauntlet-fix-4` (12:57 to 14:02Z), so the 12:35Z slot sat in todo. At 13:21Z oros-health-watch sent `reset-failed` and then `unit restart garden-monk@1`. The restart is graceful, so it waited for fix-4 to finish (14:02Z) and this check-up was claimed at 14:03Z.
- **Bug found and fixed:** the sysop ran `unit restart` as a *blocking* `systemctl restart`. It sat out the monk's 40-minute drain, every tick was killed at the 600s self-heal bound, and the same op re-ran each time. During that window no other host op (`drain off` included) could be processed. Landed `3a743ca7` on main2: unit ops are now queued with `--no-block` (sysop-test 65/65).
- **Changed:** the main2 fix above. Nothing on-host.
- **Needs the maintainer:** with `monks: 1`, any long gauntlet job delays this check-up, and a watcher restart cannot preempt it. Raising oros's monk count is the maintainer's call. The leader-sha / endolin self-advance question from the 09:58Z note still stands.

## 2026-10-18T09:58Z (oros-health-checkup-20261018-093508): healthy on-host; deploy held because the leader stopped releasing, no changes

- **Load/mem:** load 1.4/1.8/1.8. 13 GiB of 15 GiB available (815 MiB of swap in use).
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (167k). The virtiofs garden mount is 47% used.
- **Uptime:** 16d16h, no reboot.
- **Deployed vs main2:** root at `6348060b`; origin/main2 is `05d833a2` (docs-only), and `upgrade-ready` has named it since 08:29Z. The leader (endolin-garden-ece02cb4) has not written a release token for it in about 85 minutes. The last release was 6348060b at 05:41Z, and its canary passed at 06:32Z. Since 09:33Z self-deploy has logged `leaderless ... target 05d833a2 is AHEAD of last-known-good b8abbe64; HOLDING`. That hold is correct: it never runs ahead of a leader-validated sha. **Root cause is on the leader:** endolin has been at `b8abbe64` since 2026-10-16 16:52Z. Its own advance has not landed since then, so `deploy/leader-sha` and `roll-completed` are frozen at b8abbe64, even though oros passed 4 canary releases afterwards (5b93a4d2, 46215da0, b1c49fea, 6348060b). Oros is fine; it is the leader that is about 41h behind.
- **Units:** 0 failed. Only monk 1 is running (this check-up). `hosts/oros` says `monks: 1`. Not draining. No derotation marker for oros.
- **Budget heartbeat:** claude-oros sampled at 09:47Z, status ok, 57% used (142.37M of 180M). All 5 pushes from 08:48Z to 09:47Z landed, about 15 minutes apart, and spend is monotone.
- **State clones:** the largest have 48 packs (regenerate-topics-counts) and 47 (state-clone-keeper, reaper, fleet-health), below the threshold of 50. No tmp_pack, no `gc.log`. The two `index.lock` files were seconds old (live commits).
- **rc=124 (3h):** none.
- **Changed:** nothing.
- **Needs the maintainer:** someone at endolin should check why `rolling-deploy.sh`'s leader self-advance has not landed since 10-16 16:52Z (look for a "REJECTED" marker or a long-job "did not land" loop in endolin's `garden-rolling-deploy` journal). It is also not releasing 05d833a2. The `journal-worktree-keeper/backups` retention question from 10-14 still stands.

## 2026-10-18T08:50Z (oros-health-checkup-20261018-063508): healthy (one docs commit behind main2, roll pending), no changes

- **Load/mem:** load 1.8/1.5/1.1. 13 GiB of 15 GiB available (815 MiB of swap in use).
- **Disk/inodes:** 7% of the overlay used (404G free); inodes 1% (167k). The virtiofs garden mount is 46% used.
- **Uptime:** 16d15h, no reboot.
- **Deployed vs main2:** root still at `6348060b` (`deploy/roll-completed`); origin/main2 is `05d833a2`, the docs-only commit noted by the previous run. fleet/health/oros (06:29Z): `roll_status: deployed`, 0 of 287 units failed.
- **Units:** 0 failed. Only monk 1 is running (this check-up). `hosts/oros` declares `monks: 1`. Not draining. No derotation marker for oros.
- **Budget heartbeat:** claude-oros sampled at 08:31Z in the scaler clone (08:02Z in the live worktree), status ok, 57% used (136.95M of 180M). The scaler ticked cleanly at 08:45Z.
- **State clones:** 32 namespace clones. The largest have 47 `.pack` files (fleet-health, reaper, regenerate-topics-counts), below the threshold of 50. No tmp_pack, no `gc.log`. The three `index.lock` files seen were seconds old (live commits). `self-deploy/settle` holds 348 per-target marker files: a slow leak, one tiny file per main2 tip, not urgent.
- **rc=124 (3h):** none.
- **Changed:** nothing. The scheduler claimed this run right after the 03:35Z slot's late note (08:45Z), so the two notes are near-duplicates.
- **Needs the maintainer:** nothing new.

## 2026-10-18T08:45Z (oros-health-checkup-20261018-033508): healthy (one docs commit behind main2, roll pending), no changes

- **Load/mem:** load 1.7/1.1/1.0. 13 GiB of 15 GiB available (815 MiB of swap in use).
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (167k).
- **Uptime:** 16d15h, no reboot.
- **Deployed vs main2:** root at `6348060b`. origin/main2 is `05d833a2` (a docs-only ci-runner note), which landed at 08:29Z, about 13 minutes before this check. fleet/health/oros (06:29Z): `roll_status: deployed`, 0 of 287 units failed. The next roll should pick up the new commit; this check-up is finishing quickly so it does not hold the long-job deferral.
- **Units:** 0 failed. Only monk 1 is running (this check-up). The leveling row is still `4 0`. Not draining. No derotation marker for oros.
- **Budget heartbeat:** claude-oros sampled at 08:31Z, status ok, 57% used (136.96M of 180M). All 6 pushes from 07:17Z to 08:31Z landed, about 15 minutes apart, and spend is monotone.
- **State clones:** 32 namespace journal clones. The largest have 49 packs (repo-watcher) and 47 (reaper, regenerate-topics-counts). None has a tmp_pack or a `gc.log`. The root repo has 30 packs and no `gc.log`. The `.lock` files older than 30 minutes are persistent flock files.
- **rc=124 (3h):** none.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands.

## 2026-10-18T01:30Z (oros-health-checkup-20261018-002033): healthy (deployed = origin/main2 `46215da0`), no changes

- **Load/mem:** load 1.2/1.6/1.4. 13 GiB of 15 GiB available (812 MiB of swap in use).
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (167k).
- **Uptime:** 16d8h, no reboot.
- **Deployed vs main2:** root at `46215da0`, the origin/main2 tip, deployed 01:18Z. The previous check-up finished quickly and released monk 1, which cleared the long-job deferral as that check-up intended. fleet/health/oros (01:18Z): `roll_status: deployed`.
- **Units:** 0 failed. Only monk 1 is running (this check-up). The leveling row is still `4 0`. Not draining. No derotation marker for oros.
- **Budget heartbeat:** claude-oros sampled at 01:02Z, status ok, 57% used (136.29M of 180M). All 6 pushes from 23:47Z to 01:02Z landed, about 15 minutes apart, and spend is monotone.
- **State clones:** the largest namespace clones have 47 packs (regenerate-sections-index, reaper). None has a tmp_pack or a `gc.log`. The root repo has 11 packs and no `gc.log`. No `index.lock` is older than 5 minutes.
- **rc=124 (3h):** none.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands. The scheduler started this check-up only about 10 minutes after the previous one finished (late claim of the 21:20Z slot), so two notes sit close together.

## 2026-10-18T01:20Z (oros-health-checkup-20261017-212007): healthy (one commit behind main2, deploy deferred behind long jobs), no changes

- **Load/mem:** load 1.3/1.1/1.0. 13 GiB of 15 GiB available (812 MiB of swap in use).
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (167k).
- **Uptime:** 16d8h, no reboot.
- **Deployed vs main2:** root at `5b93a4d2`, deployed 21:58Z. origin/main2 is `46215da0` (gate panels on deterministic probes), which landed at 00:56Z. `upgrade-ready` names it as of 01:12Z. fleet/health/oros (01:12Z): `roll_status: deferred`, `deferred_reason: long-job monk 1 3992s`, 0 of 287 units failed. The long job was `kriscendobot-minion.town-pr201-gauntlet-fix-2`, which ran from 00:05Z to about 01:13Z. It has finished, but this check-up claimed monk 1 right after it. Once this check-up passes 300s it trips the same long-job deferral, so it is finishing quickly to let self-deploy proceed on its next tick. The deferral is designed behavior (the conductor waits rather than failing), not a gate fault.
- **Units:** 0 failed. Only monk 1 is running (this check-up). The leveling row is still `4 0`. Not draining. No derotation marker for oros.
- **Budget heartbeat:** claude-oros sampled at 01:02Z, status ok, 57% used (136.29M of 180M). All 8 pushes from 23:17Z to 01:02Z landed, about 15 minutes apart, and spend is monotone (no repeat of the 10-17 dip). The root `journal/` worktree copy was 30 minutes behind origin, which is normal sync lag.
- **State clones:** 32 namespace journal clones. The largest have 49 packs (leader) and 47 (reaper, regenerate-sections-index). None has a tmp_pack or a `gc.log`. The root repo has 9 packs and no `gc.log`. No `index.lock` or root `.lock` is older than 5 minutes.
- **rc=124 (3h):** none.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands. Watch item: the 3-hourly check-up always lands on an otherwise idle monk and runs for more than 300s, so it can defer a pending deploy for its whole run. That costs minutes, not hours.

## 2026-10-17T20:55Z (oros-health-checkup-20261017-180508): healthy (one commit behind main2, roll pending), no changes

- **Load/mem:** load 2.0/2.6/1.8 (a panel job on monk 1 just finished). 13 GiB of 15 GiB available (814 MiB of swap in use).
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (167k).
- **Uptime:** 16d3h, no reboot.
- **Deployed vs main2:** root at `f5477a65` (pin delegated conductors to the CI-reading host), deployed 18:10Z. origin/main2 is `5b93a4d2` (defer fixer review-docket re-entry on non-green CI), which landed at 20:36Z. `upgrade-ready` names it as of 20:47Z, and self-deploy is ticking while it waits for the leader's roll release. fleet/health (18:10Z): `roll_status: deployed`, 0 of 287 units failed.
- **Units:** 0 failed. Only monk 1 is running (this check-up). The leveling row is still `4 0`. Not draining. No derotation marker for oros.
- **Budget heartbeat:** claude-oros sampled at 20:47Z, status ok, 56% used (134.0M of 180M). All 6 pushes from 19:32Z to 20:47Z landed, about 15 minutes apart. The spend dip came back, larger: 132.57M fell to 132.47M (−103k) between 19:32Z and 19:47Z, after the −33k dip on 10-16. This is probably a meter re-derivation rather than a host fault, but if it keeps recurring, someone should look at the claude-oros meter.
- **State clones:** 32 namespace journal clones. The largest has 47 packs (reaper). None has a tmp_pack or a `gc.log`. The root repo has 46 packs and no `gc.log`. The `.lock` files older than 30 minutes (receipt-watcher, verify, cursors, scholar-staging) are persistent flock files.
- **rc=124 (3h):** none. Three gauntlet jobs ran on monk 1 under their declared handler timeouts.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands. The claude-oros spend dip (above) is a watch item.

## 2026-10-17T15:25Z (oros-health-checkup-20261017-150508): healthy (deployed = origin/main2 `0359b614`), no changes

- **Load/mem:** load 1.9/2.0/2.0; 13 GiB of 15 GiB available (815 MiB of swap in use).
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (167k).
- **Uptime:** 15d22h, no reboot.
- **Deployed vs main2:** root at `0359b614` (the bearer-token juror note), the origin/main2 tip. fleet/health (15:09Z): `roll_status: deployed`, 0 of 287 units failed, 0 advisory.
- **Units:** 0 failed, none flagged `NeedDaemonReload`. Only monk 1 is running (this check-up). The leveling row is still `4 0`. Not draining. No derotation marker for oros.
- **Budget heartbeat:** claude-oros sampled at 15:03Z, status ok, 54% used (131.5M of 180M). All 8 pushes from 13:22Z to 15:03Z landed, about 15 minutes apart, and spend is monotone.
- **State clones:** 32 namespace journal clones. The largest have 49 packs (self-deploy) and 47 (reaper). None has a tmp_pack or a `gc.log`. The root repo has 31 packs and no `gc.log`. Locks older than 30 minutes are only persistent flock files.
- **rc=124 (3h):** one handler overrun. At 14:40Z `fu-kriscendobot-minion.town-pr201-gauntlet-fix-1-1` overran its handler wall-clock on oros and got a deadline hint. It has since completed (it is in `tada/`). Endolin's 14:43Z reap was a separate claim. This is job-level, not a host fault.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands.

## 2026-10-17T13:00Z (oros-health-checkup-20261017-115010): healthy (deployed = origin/main2 `63dc4d85`), no changes

- **Load/mem:** load 1.4/1.8/1.8. 13 GiB of 15 GiB available (810 MiB of swap in use).
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (167k).
- **Uptime:** 15d19h, no reboot.
- **Deployed vs main2:** root at `63dc4d85` (two-tier garden-memory design), still the origin/main2 tip. fleet/health (08:38Z): `roll_status: deployed`, 0 of 287 units failed.
- **Units:** 0 failed, none flagged `NeedDaemonReload`. Only monk 1 is running (this check-up). The leveling row is still `4 0`. Not draining. No derotation marker for oros.
- **Budget heartbeat:** claude-oros sampled at 12:48Z, status ok, 54% used (125.6M of 180M). All 12 pushes from 10:03Z to 12:48Z landed, about 15 minutes apart, and spend is monotone.
- **State clones:** 32 namespace journal clones. The largest have 47 packs (self-deploy, reaper). None has a tmp_pack or a `gc.log`. The root repo has 24 packs and no `gc.log`. Every `.lock` file older than 30 minutes is a persistent flock file. No `index.lock` is older than 5 minutes.
- **rc=124 (3h):** none on oros. At 12:47Z endolin's monk-3 hit a transient handler kill on `minion-town-ci-runner-stall-20261017` (oros posted the job), and endolin reaped it. That job runs on endolin, so it is not an oros fault.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands.

## 2026-10-17T10:00Z (oros-health-checkup-20261017-085009): healthy (deployed = origin/main2 `63dc4d85`), no changes

- **Load/mem:** load 1.6/1.5/1.5, rising to 2.3 during this check-up's own scans. 13 GiB of 15 GiB available (813 MiB of swap in use).
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (167k).
- **Uptime:** 15d16h, no reboot.
- **Deployed vs main2:** root at `63dc4d85` (the two-tier garden-memory design), the origin/main2 tip. Last run's pending roll of `c2f25a30` has landed. fleet/health (08:38Z): `roll_status: deployed`, 0 of 287 units failed.
- **Units:** 0 failed. Only monk 1 is running (this check-up). The leveling row is still `4 0`. Not draining. No derotation marker for oros.
- **Budget heartbeat:** claude-oros sampled at 09:46Z, status ok, 53% used (124.1M of 180M). All 8 pushes from 08:02Z to 09:46Z landed, about 15 minutes apart, and spend is monotone.
- **State clones:** 32 namespace journal clones. The largest have 47 packs (unblock, self-deploy, reaper). None has a tmp_pack or a `gc.log`. The root repo has 16 packs and no `gc.log`. The `index.lock` files seen in the gardener-scaler, repo-watcher, sysop and fork-watch clones were all seconds old, held by live `reset --hard` syncs, so none is stale. A recursive `find` over `.garden-state` does not finish within 60s on virtiofs; scan at depth 3 or less.
- **rc=124 (3h):** none on oros. At 09:23Z endolin reaped a stale claim, but it was endolin's own (pr1482 gauntlet-fix-4, monk 2).
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands.

## 2026-10-17T07:32Z (oros-health-checkup-20261017-055009): healthy (one commit behind main2, roll pending), no changes

- **Load/mem:** load 3.4/2.0/1.5, a brief spike from this check-up's own git fetches. 13 GiB of 15 GiB available (813 MiB of swap in use).
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (171k).
- **Uptime:** 15d14h, no reboot.
- **Deployed vs main2:** root at `3adb1686` (the git-wrapper passthrough). origin/main2 is `c2f25a30` (the safe-rebase throwaway worktree), which landed at 07:12Z. `upgrade-ready` already names it; the leader roll has not reached this host yet. fleet/health (06:51Z): `roll_status: deployed`, 0 of 287 units failed.
- **Units:** 0 failed. Only monk 1 is running (this check-up). The leveling row is still `4 0`. Not draining. No derotation marker for oros.
- **Budget heartbeat:** claude-oros sampled at 07:17Z, status ok, 50% used (123.3M of 180M). All 8 pushes from 05:32Z to 07:17Z landed, about 15 minutes apart, and spend is monotone.
- **State clones:** 32 namespace journal clones. The largest has 47 packs (reaper). None has a tmp_pack or a `gc.log`. The root repo has 9 packs and no `gc.log`. Locks older than 30 minutes are only persistent flock files.
- **rc=124 (3h):** none on oros. At 06:33Z endolin reaped a stale claim, but it was endolin's own (minion.town pr178 fix-12).
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands.

## 2026-10-17T05:20Z (oros-health-checkup-20261017-023510): healthy (deployed = origin/main2 `776cdbee`), no changes

- **Load/mem:** load 1.3/1.2/1.1; 13 GiB of 15 GiB available.
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (167k).
- **Uptime:** 15d12h, no reboot.
- **Deployed vs main2:** root at `776cdbee` (the #196 probe-draft doc), the origin/main2 tip. fleet/health (05:04Z): `roll_status: deployed`, 0 of 287 units failed.
- **Units:** 0 failed, none flagged `NeedDaemonReload`. Only monk 1 is running (this check-up). The leveling row is still `4 0`. Not draining. No derotation markers.
- **Budget heartbeat:** claude-oros sampled at 05:02Z, status ok, 50% used (119.45M of 180M). All 8 pushes from 03:16Z to 05:02Z landed, about 15 minutes apart, and spend is monotone. Last run's −33k dip has not recurred.
- **State clones:** 32 namespace journal clones. The largest has 49 packs (gardener-scaler). None has a tmp_pack or a `gc.log`. The root repo has 50 packs, no tmp_pack and no `gc.log`. Locks older than 30 minutes are only persistent flock files. `repo-locks/` holds 9,402 keys.
- **rc=124 (3h):** one handler overrun. At 02:15Z `endojs-endo-but-for-bots-pr1486-gauntlet-undraft` hit its 2400s handler budget on monk 1 (2414s). It was classified transient, stamped for early doom, and reaped at 02:33Z by endolin. It is now parked in `plan/`. This is job-level, not a host fault.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands. The pr1486 undraft job is parked after a wall-clock overrun if someone wants to look.

## 2026-10-17T00:40Z (oros-health-checkup-20261016-233509): healthy (deployed = origin/main2 `591671f0`); ran a user daemon-reload

- **Load/mem:** load 1.5/1.3/1.3; 13 GiB of 15 GiB available (789 MiB of swap in use).
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (167k).
- **Uptime:** 15d7h, no reboot.
- **Deployed vs main2:** root at `591671f0` (the minion-town guest-state doc), the origin/main2 tip. fleet/health (23:25Z): `roll_status: deployed`, 0 of 288 units failed.
- **Units:** 0 failed. After the deploy, the monk@2 enable/disable at 23:59Z touched `default.target.wants`, and systemd then flagged every garden unit `NeedDaemonReload`. Ran `systemctl --user daemon-reload`, which restarts nothing and cleared the flag.
- **Workers:** only monk 1 is running (this check-up). The host declared `monks: 1` itself at 23:51Z (budget leveling; the leveling row is still `4 0`). Not draining. No derotation markers.
- **Budget heartbeat:** claude-oros sampled at 00:32Z, status ok, 49% used (113.6M of 180M). All 15 pushes from 20:47Z to 00:32Z landed, about 15 minutes apart. The root `journal/` worktree trails by up to 30 minutes (the keeper cadence), so read the snapshot age from origin. There was one small dip, 109.73M to 109.70M (−33k) between 22:46Z and 23:03Z. Otherwise spend is monotone. Watch whether the dip recurs.
- **State clones:** 32 namespace journal clones (one new: `worker-derotate`). The largest has 47 packs (reaper). None has a tmp_pack or a `gc.log`. The root repo has 37 packs and no `gc.log`. Old `.lock` files are only persistent flock files. `repo-locks/` holds 9,399 keys.
- **rc=124 (3h):** none.
- **Changed:** `systemctl --user daemon-reload`.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands.

## 2026-10-16T22:05Z (oros-health-checkup-20261016-202040): healthy (deployed = origin/main2 `7ff6f44c`), no changes

- **Load/mem:** load 1.5/1.2/1.0; 13 GiB of 15 GiB available.
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (167k).
- **Uptime:** 15d4h, no reboot.
- **Deployed vs main2:** root at `7ff6f44c` (the builder-budget inference fix), the origin/main2 tip. Self-deploy advanced the host at 21:57Z via leader release; the 21:42Z fleet/health deferral (`long-job monk 1 3101s`, target `7ff6f44c`) has cleared. 0 of 288 units failed.
- **Units:** 0 failed. monks 1 and 2 running (leveling row `4 0`). Not draining. No derotation marker for oros.
- **Budget heartbeat:** claude-oros sampled at 21:46Z, status ok, 48% used (109.3M of 180M). All 12 pushes from 19:03 to 21:46Z landed, and spend is monotone. The longest gap was 21 minutes (20:02 to 20:23Z).
- **State clones:** 31 namespace journal clones. The largest has 50 packs (producer). None has a tmp_pack or a `gc.log`. The root repo has 28 packs and no `gc.log`. Locks older than 30 minutes are only persistent flock files. `repo-locks/` holds 9,357 keys, which the 7-day pruner is aging out.
- **rc=124 (3h):** none outside the expected 2s repo-lock skips.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands.

## 2026-10-16T17:25Z (oros-health-checkup-20261016-170509): healthy (deployed = origin/main2 `b8abbe64`), no changes

- **Load/mem:** load 2.4/2.2/2.1; 13 GiB of 15 GiB available.
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (167k).
- **Uptime:** 15d0h, no reboot.
- **Deployed vs main2:** root at `b8abbe64` (the review-docket rollup fallback), which is the origin/main2 tip. fleet/health (16:46Z): `roll_status: deployed`, 0 of 288 units failed. The deferred roll from the last two runs has landed.
- **Units:** 0 failed. monks 1 and 2 running (monk 1 on a gauntlet panel, monk 2 on this check-up; leveling row `4 0`). Not draining. No derotation marker for oros.
- **Budget heartbeat:** claude-oros sampled at 17:02Z, status ok, 44% used (102.6M of 180M). All 12 pushes from 14:18 to 17:02Z landed, and spend is monotone. The longest gap was 21 minutes (15:47 to 16:08Z).
- **State clones:** 30 namespace journal clones. The largest has 47 packs. None has a tmp_pack or a `gc.log`. The root repo has 14 packs and no `gc.log`. `repo-locks/` holds 9,297 keys, which the 7-day pruner is aging out.
- **rc=124 (3h):** none. The only timeouts were the 2s shared repo-lock skips, which are expected under contention.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands.

## 2026-10-16T14:35Z (oros-health-checkup-20261016-140509): healthy (deployed = `9fc0f740`, one behind); cleared one stale lock

- **Load/mem:** load 3.2/2.9/3.0; 13 GiB of 15 GiB available (594 MiB of swap in use).
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (169k).
- **Uptime:** 14d21h, no reboot.
- **Deployed vs main2:** root at `9fc0f740`, so the meter fix is live. origin/main2 is `9bad5343` (the watchman lock-busy skip), one ahead. fleet/health (14:21Z): `roll_status: deferred`, reason `long-job monk 1 1336s`, target `9bad5343`, 0 of 288 units failed. Working as designed; it needs a quiet moment. Nothing to unblock by hand.
- **Units:** 0 failed. monks 1 and 2 running (leveling row `4 0`, scaler hold effective 2). Not draining. No derotation marker for oros.
- **Budget heartbeat:** claude-oros sampled at 14:18Z, status ok, 42% used (95.4M of 180M). Spend is now monotone after the meter fix (91.9M → 95.4M across 13:02–14:18Z). One sample is missing at about 14:02Z (a 27-minute gap from 13:47 to 14:14Z), and it recovered on its own. That gap matches the one rc=124 below.
- **State clones:** 30 namespace journal clones. None has more than 50 packs, a tmp_pack, or a `gc.log`. The root repo has 6 packs and no `gc.log`. `repo-locks/` holds 9,201 keys, which the 7-day pruner is aging out.
- **rc=124 (3h):** one. The `garden-gardener-scaler` tick that started at 14:01:41Z went silent and was bounded by self-heal at 14:11:39Z (600s). The next tick cleared the dead holder's repo-lock metadata cleanly. The same self-heal bound fired twice yesterday (16:30Z, 16:40Z). It is rare and self-recovering, so no fix this run. Watch for it to recur.
- **Changed:** removed a 0-byte `gc.log.lock` dated 2026-10-01 from `.git/worktrees/gardener-wt-design-minion-town-mcp-resources-getting-started/`. No process held it.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands.

## 2026-10-16T11:25Z (oros-health-checkup-20261016-110509): healthy (deployed = `79cde1aa`, one behind), no changes

- **Load/mem:** load 2.1/2.1/1.7; 12 GiB of 15 GiB available.
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (166k).
- **Uptime:** 14d18h, no reboot.
- **Deployed vs main2:** root at `79cde1aa` (self-deployed 10:23Z); origin/main2 is `9fc0f740` (the usage-meter retired-transcript fix), one ahead. fleet/health (11:15Z): `roll_status: deferred`, `long-job monk 2 315s` (this check-up's own claim; earlier `long-job monk 1 1889s`), 0 of 288 units failed. Working as designed; it needs a quiet moment. Nothing to unblock by hand.
- **Units:** 0 failed, 0 need a daemon-reload. monks 1 and 2 running (leveling row `4 0`). Not draining. No derotation marker for oros.
- **Budget heartbeat:** claude-oros sampled at 11:02Z, status ok, 40% used (87.3M of 180M). Pushes on cadence (08:17 through 11:02, all 12 landed). Spend still dips slightly between samples (87.18M → 87.12M at 10:47Z) because the meter fix `9fc0f740` is not deployed yet; expect it to become monotone after the next roll.
- **State clones:** 37 namespace journal clones. None has more than 50 packs, a tmp_pack, or a `gc.log`/stale lock older than 10 minutes. The root repo has 47 packs and no `gc.log`. `repo-locks/` holds 8,746 keys, which the 7-day pruner is aging out.
- **rc=124 (3h):** none found.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands.

## 2026-10-16T09:50Z (oros-health-checkup-20261016-080509): healthy (deployed = `a130d814`, two behind) → meter undercount found; fix job posted

- **Load/mem:** load 1.1/1.5/1.8; 13 GiB of 15 GiB available.
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (166k).
- **Uptime:** 14d16h, no reboot.
- **Deployed vs main2:** root at `a130d814`; origin/main2 is `79cde1aa` (two ahead: `20ce5180`, `79cde1aa`). fleet/health (09:12Z): `roll_status: deferred`, reason `long-job monk 1`, 0 of 288 units failed. The leader released the roll, and self-deploy retries every 3 minutes. At 09:18Z the candidate gate passed in 2 minutes. Then, at 09:20:27Z, monk 1 crossed the 300s long-job threshold mid-drain, so the drain was lifted cleanly and the deploy aborted. Since then every attempt has been deferred behind a monk past 300s (gauntlet-fix jobs declare 7200s). The deploy is working as designed and needs a quiet moment. Nothing to unblock by hand, and the long-job threshold policy is not ours to change.
- **Units:** 0 failed, 0 need a daemon-reload. monks 1 and 2 running (leveling row `4 0`). Not draining. No derotation marker for oros.
- **Budget heartbeat:** claude-oros sampled at 09:32Z, status ok. Utilization is 39% per the rate_limit ledger. Pushes are on cadence (06:47 through 09:32, all 12 landed).
- **State clones:** namespace journal clones scanned. None has more than 50 packs, a tmp_pack, a `gc.log`/`gc.log.lock`, or a stale lock older than 10 minutes. The root repo has 40 packs and no `gc.log`. `repo-locks/` holds 8,486 keys, which the 7-day pruner is aging out.
- **rc=124 (3h):** none.
- **Changed:** nothing on-host. **Found a meter defect:** live `spend:` stayed flat at about 85.5M (±0.1M, not monotone) from 06:47Z to 09:32Z, while two monks ran and utilization rose 0.38 → 0.39. Cause: `monk-claude.sh` `rm`s each completed job's top-level transcript (for resume safety), and `_meter_session_total` counts only the `.jsonl` files still in `~/.claude/projects`. So finished jobs drop out of the host spend. The claim gate is unaffected because it reads utilization, but calibration, the arc and pace read a biased spend. Posted `fix-usage-meter-retired-transcript-undercount` (fixer): retire the transcripts to a meter-visible dir instead of deleting them, with tests.
- **Needs the maintainer:** nothing new. The fix will make spend figures rise toward the truth, so expect calibration inputs to shift. The `journal-worktree-keeper/backups` retention question from 10-14 still stands.

## 2026-10-16T08:50Z (oros-health-checkup-20261016-045011): healthy (deployed = `a130d814`) → spurious NeedDaemonReload root-caused; fix landed

- **Load/mem:** load 2.9/2.7/2.0; 13 GiB of 15 GiB available.
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (166k).
- **Uptime:** 14d15h, no reboot.
- **Deployed vs main2:** root at `a130d814`, which was origin/main2 until this run's fix. fleet/health (07:25Z): `roll_status: deployed`, 0 of 290 units failed. main2 is now one commit ahead (`20ce5180`, this run's fix); the next roll will pick it up.
- **Units:** 0 failed. monks 1 and 2 running (scaler-managed; leveling row is now `4 0`). Not draining. No derotation marker for oros.
- **Budget heartbeat:** claude-oros sampled at 08:01Z, status ok, 39% used (85.5M of 180M). Pushes are on cadence (06:47, 07:02, 07:17, 07:31, 07:46, 08:01 all landed).
- **State clones:** 38 namespace journal clones scanned. None has more than 50 packs, a tmp_pack, a `gc.log`/`gc.log.lock`, or a lock older than 10 minutes. The root repo has 37 packs and no `gc.log`. `repo-locks/` holds 8,202 keys, which the 7-day pruner from `1e8ccd58` will age out.
- **rc=124 (3h):** none.
- **Changed:** all 290 units again showed `NeedDaemonReload=yes`, the same as on 10-15. Root cause: `install-units.sh` created and deleted its comparison temp file inside `~/.config/systemd/user` on every deploy, so the directory mtime changed (07:25:50, the deploy) and systemd 255 marked every unit stale. Ran `systemctl --user daemon-reload` to clear it; it restarted nothing. Landed `20ce5180` on main2: renders are staged in `$TMPDIR`, and the unit dir is touched only when a unit really changes. Added a new `install-units-noop-mtime-test` (8/8; it fails on the old code); deploy-garden 224/0, enable-services 40/0 and paused-disable 11/0 also pass. The same commit documents `garden-namespace-clone-maintenance` in `context/operations/systemd-units.md`, which `systemd-unit-doc-completeness-test` had been failing on since `1c65522f`.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands.

## 2026-10-16T03:25Z (oros-health-checkup-20261016-013510): healthy (deployed = `2845917b`) → repo-locks leak found; pruner landed

- **Load/mem:** load 1.9/2.7/2.9; 13 GiB of 15 GiB available. IO pressure is low (avg300 2.4%).
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (165k).
- **Uptime:** 14d9h, no reboot.
- **Deployed vs main2:** root at `2845917b`, which was origin/main2 until this run's fix. fleet/health (01:31Z): `roll_status: deployed`, 0 of 290 units failed. main2 is now one commit ahead (`1e8ccd58`, this run's fix); the next roll will pick it up.
- **Units:** 0 failed. monks 1 to 3 running (scaler-managed; leveling row `8 0`). Not draining. No derotation marker for oros.
- **Budget heartbeat:** claude-oros sampled at 02:48Z, status ok, about 43% used (77.9M of 180M). Pushes are on cadence (01:02, 01:17, 01:32, 01:47, 02:04, 02:19, 02:33, 02:48 all landed).
- **State clones:** 43 pack dirs scanned. None has more than 50 packs, a tmp_pack, a `gc.log`, or a `gc.log.lock`. No stale index/HEAD/packed-refs lock and no gc.pid. The root repo has 23 packs and no `gc.log`.
- **rc=124 (3h):** one. monk/3 `improve-comment-source-timeout-not-fatal` overran its own 2400s budget at 01:17Z. It was classified as transient and left for the reaper.
- **Changed:** `$GARDEN_STATE/repo-locks/` held **7,687** per-repo lock-key dirs that nothing ever removed. They grow by about 2,500 a day (one per git common-dir the fleet wrapper touches, such as test fixtures and per-id clones), and they made any `*/*` scan of the state dir take about 100s on virtiofs. Landed `1e8ccd58` on main2: worktree-sweeper prunes keys idle for 7 days (every lock file free under `flock -n`, no live holder), and `_garden_lock_open` reopens a lock whose inode was pruned while it waited. Tests: repo-locks-test new case passes, worktree-sweeper-follower 6/6, namespace-clone-orphan-sweep pass. Pruned the 67 keys already older than 7 days by hand; the rest will age out over the week.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands. Separately, `repo-locks-test.sh`'s "parallel CAS writers" case already fails on main2 under oros load (a writer subshell exits non-zero while every write still lands). It is a test flake, not a regression from this run.

## 2026-10-16T00:30Z (oros-health-checkup-20261015-223508): healthy (deployed = origin/main2 `d4ef628b`) → stale root gc.log.lock removed; guard fix landed

- **Load/mem:** load 2.2/2.5/2.1; 13 GiB of 15 GiB available.
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (165k).
- **Uptime:** 14d7h, no reboot.
- **Deployed vs main2:** self-deploy moved the root to `d4ef628b` at 00:01Z, which was origin/main2 then. The 23:42Z deferral (`long-job monk 2 3420s`) cleared by itself. fleet/health (00:01Z): `roll_status: deployed`, 0 failed units. main2 is now one commit ahead (`2845917b`, this run's fix); the next roll will pick it up.
- **Units:** 0 failed. monks 1 to 3 running (scaler-managed; leveling row `8 0`). Not draining. No derotation marker for oros.
- **Budget heartbeat:** claude-oros sampled at 00:01Z, status ok, 31% used (68.0M of 180M). Pushes are on cadence (22:47, 23:01, 23:17, 23:32, 23:46, 00:01 all landed). The live `journal/` checkout lagged origin by about 15 minutes, which is benign.
- **State clones:** 33 pack dirs scanned. None has more than 50 packs, a tmp_pack, a `gc.log`, or an aged `gc.log.lock`. The only old `.lock` files are persistent flock files (ci-watcher verify-*, decisions, review-docket), which is normal. The root repo had 13 packs and no `gc.log`, but did have an empty **`.git/gc.log.lock` dated 2026-09-23**.
- **rc=124 (3h):** none.
- **Changed:** removed the stale root `gc.log.lock`; no gc was running and there was no gc.pid. While it was there, every daemonized `git gc --auto` on the shared store died on startup, so only the guard's bounded gc was maintaining the store. Landed `2845917b` on main2: root-repo-guard now sweeps a `gc.log.lock` older than `GARDEN_ROOT_GUARD_TMP_AGE_HOURS` (6h), with tests (root-repo-guard-test 78/78).
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands.

## 2026-10-15T20:40Z (oros-health-checkup-20261015-192010): healthy (deployed = origin/main2 `bf605277`), no changes

- **Load/mem:** load 2.3/2.1/2.3; 12 GiB of 15 GiB available.
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (165k).
- **Uptime:** 14d3h, no reboot.
- **Deployed vs main2:** root at `bf605277`, same as origin/main2. fleet/health (15:17Z): `roll_status: deployed`, 0 of 292 units failed.
- **Units:** 0 failed, 0 need a daemon-reload. monks 1 to 4 running (scaler-managed; leveling row `8 0`). Not draining. No derotation marker for oros.
- **Budget heartbeat:** claude-oros sampled at 20:32Z, status ok, about 33% used (60.3M of 180M). Pushes are on cadence (19:02, 19:17, 19:32, 19:47, 20:02, 20:17, 20:32 all landed).
- **State clones:** 33 pack dirs scanned. None has more than 50 packs, none has a tmp_pack, and none has a `gc.log`. No index.lock older than 10 minutes. The root repo has 3 packs and no `gc.log`.
- **rc=124 (3h):** one. monk/1 `endojs-endo-but-for-bots-pr1396-parcel-restack-20261015-r5527149922` ran past its own wall-clock budget at 19:02Z. It was classified as transient and requeued.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands.

## 2026-10-15T17:35Z (oros-health-checkup-20261015-160510): healthy (deployed = origin/main2 `bf605277`) → one daemon-reload

- **Load/mem:** load 2.5/2.6/3.0; 12 GiB of 15 GiB available.
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (165k).
- **Uptime:** 14d0h, no reboot.
- **Deployed vs main2:** root at `bf605277` = origin/main2. fleet/health (15:17Z): `roll_status: deployed`, 0 of 292 units failed.
- **Units:** 0 failed; monks 1 to 4 running (scaler-managed). Not draining. The only derotation marker is endolin-garden2's.
- **Budget heartbeat:** claude-oros sampled at 17:02Z, status ok, 19% used. Pushes are on cadence (16:18, 16:33, 16:47, 17:03, 17:17, 17:32 all landed).
- **State clones:** 45 pack dirs scanned, none over 50 packs, no tmp_pack, no `gc.log`, no index.lock older than 10 minutes.
- **rc=124 (3h):** the garden-sysop self-heal hit its 600s limit twice (16:30Z, 16:40Z). Later ticks finish in about 10–30s with nothing applied. monk/2 `endojs-endo-but-for-bots-pr1394-shepherd-20261015` overran its own 2400s budget at 17:10Z (classified transient, left for the reaper).
- **Changed:** all 292 garden units reported `NeedDaemonReload=yes` ("changed on disk"), though no unit file under `~/.config/systemd/user` had changed in 12h. One `systemctl --user daemon-reload` cleared it. It restarted nothing.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands.

## 2026-10-15T14:05Z (oros-health-checkup-20261015-125028): healthy (deploy deferred on long jobs only) → no changes

- **Load/mem:** load 2.8/2.9/2.9; 11 GiB of 15 GiB available.
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (165k).
- **Uptime:** 13d20h, no reboot.
- **Deployed vs main2:** root at `2a58e858`; origin/main2 is `0bb399c2`, one commit ahead. fleet/health (13:42Z): `roll_status: deferred` (`long-job monk 3 2301s`), 0 of 292 units failed. This is the normal long-job rule; nothing blocks it.
- **Units:** 0 failed; monks 1 to 4 running (scaler-managed, pool scaled to 4 at 13:56Z). Not draining. The only derotation marker is endolin-garden2's.
- **Budget heartbeat:** claude-oros sampled at 13:32Z, status ok, 17% used. Pushes are on cadence (12:47, 13:01, 13:17, 13:32, 13:47 all landed).
- **State clones:** no pack dir over 50 packs, no tmp_pack, no `gc.log`, no index.lock older than 10 minutes.
- **rc=124 (3h):** none.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands.

## 2026-10-15T10:20Z (oros-health-checkup-20261015-093533): healthy (deploy deferred on long jobs only) → no changes

- **Load/mem:** load 3.0/3.0/3.2; 12 GiB of 15 GiB available.
- **Disk/inodes:** 6% of the overlay used (405G free); inodes 1% (165k).
- **Uptime:** 13d17h, no reboot.
- **Deployed vs main2:** root at `ff85753d`; origin/main2 is `2a58e858`, two commits ahead. fleet/health (09:43Z): `roll_status: deferred` (`long-job monk 5 1834s`), 0 of 292 units failed. At 10:1xZ self-deploy is still deferring on long jobs (monk 2 at 1006s, then monk 1 at 1432s). This is the normal long-job rule; nothing blocks it, and no help was needed.
- **Units:** 0 failed; monks 1 to 4 running (scaler-managed). Not draining.
- **Budget heartbeat:** claude-oros sampled at 10:05Z, status ok, 15% used. Pushes are on cadence (09:03, 09:18, 09:33, 09:48, 10:05 all landed).
- **State clones:** 47 pack dirs scanned, none over 50 packs, no tmp_pack (the transcript clone included), no `gc.log`, no index.lock older than 10 minutes.
- **rc=124 (3h):** garden-sysop self-heal 600s kill ×1 (08:15Z, isolated). dependabot-watcher stop-post timeout ×1 (09:56Z). journal-contention-watch deferred its worktree_sweeper close notice 07:14–07:34Z; that notice has since been marked recovered (07:35Z). The 2s repo-lock "timeout" lines are the watch's non-blocking probes, not failures.
- **Changed:** nothing.
- **Needs the maintainer:** nothing new. Several oros lock-contention notices are still open in `inbox/maintainer/unread` (fork_watch, repo_watcher, producer push-contention, last seen 08:2x–08:5xZ); the watch closes them itself. The `journal-worktree-keeper/backups` retention question from 10-14 still stands.

## 2026-10-15T07:05Z (oros-health-checkup-20261015-062034): degraded (producer-clone journal writes take ~45s per CAS attempt, so writes lose races at only ~2 commits/min) → one stuck close notice delivered by hand; follow-up posted

- **Load/mem:** load 3.1/3.3/3.7; 12 GiB of 15 GiB available.
- **Disk/inodes:** 6% of the overlay used (405G free); inodes 1% (165k).
- **Uptime:** 13d13h, no reboot.
- **Deployed vs main2:** root at `cbef9daa`; origin/main2 is `e646acc3`, one commit ahead. fleet/health (06:47Z): `roll_status: deferred`, `long-job monk 3` (1796s), with 0 of 292 units failed. Self-deploy should land once that job ends. Nothing blocks it, so no help was needed.
- **Units:** 0 failed; monks 1 to 6 running (scaler-managed). Not draining. The only derotation marker is endolin-garden2's.
- **Budget heartbeat:** claude-oros sampled at 06:32Z, status ok, 11% used. Pushes are on cadence (05:33, 05:49, 06:04, 06:19, 06:32 all landed).
- **State clones:** 76 clones, each at or below about 50 packs (the threshold), with no tmp_pack and no `gc.log`. The transcript clone has no tmp_pack. The `*.lock` files are persistent flock inodes, not stale locks.
- **rc=124 (3h):** monk/4 `pr1393-gauntlet-clean` hit its 7200s wall clock (×1, transient). journal-contention-watch deferred notice deliveries (below).
- **Finding:**
  - From 05:18Z, journal-contention-watch failed to deliver one notice on every tick (rc=124): the close for `journal-fetch-slow-_Users_dom_garden_journal`. It was still open in `inbox/maintainer/unread`.
  - Cause: `watchdog-notice.sh` syncs the shared producer clone with `reset --hard origin/journal2`. Under current contention each reset takes 20–30s, and the resets run one at a time behind the producer repo lock. One push attempt costs about 45–60s, and a lost CAS race starts another. The watch's pre-sweep share (about 80s) cannot fit one losing round.
  - A read-only index refresh of that clone takes 1.8s, so the cost is in the reset's write path or in waiting for the lock, not in stat'ing files.
- **Same cause hits `post-job.sh`:** posting the follow-up job lost 7 races and hit its 300s deadline (rc=75) at 07:08Z, while journal2 took only 33 commits in 15 minutes. Posting succeeded with `GARDEN_POST_DEADLINE_SECS=540` (2 attempts). The bottleneck is how long each local attempt takes, not how many commits land on journal2. This is the same mechanism as the 10-01 diagnosis (heartbeat gaps from CAS losses under load). The budget heartbeat itself is unaffected, because it already uses the worktree-less CAS.
- **Changed:** delivered the close by hand with a 900s bound; it took 188s and 3 attempts, and the notice is now marked RECOVERED. The watch's next tick cleared its own pending state. Killed one orphaned `git reset` of mine (left after an earlier timeout of mine; it held the producer `index.lock` briefly).
- **Follow-up posted:** `watchdog-notice-worktreeless-cas`: port `watchdog-notice.sh` to the worktree-less CAS that `ec4cc369`, `0411ed9f`, `bdc2943c` and `ca5aa15d` used for the other producers.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands.

## 2026-10-15T05:20Z (oros-health-checkup-20261015-032033): healthy (deployed = origin/main2 `cbef9daa`) → one orphaned tmp_pack removed

- **Load/mem:** load 3.4/3.4/2.3; 13 GiB of 15 GiB available; swap 533 MiB used.
- **Disk/inodes:** 6% of the overlay used (405G free); inodes 1% (165k).
- **Uptime:** 13d12h, no reboot.
- **Deployed vs main2:** root at `cbef9daa` = origin/main2. fleet/health (04:58Z): `roll_status: deployed`, 0 of 292 units failed. Self-deploy deferred at 04:42Z (monk 4 long job, 6408s), then deployed once the job ended. No help was needed.
- **Units:** 0 failed; monks 1 to 6 running (scaler-managed). Not draining. The only derotation marker is endolin-garden2's, not oros's.
- **Budget heartbeat:** claude-oros sampled at 05:03Z, status ok, 10% used. Pushes land every 15 minutes (04:01, 04:16, 04:31, 04:46, 05:03 all landed).
- **State clones:** ≤50 packs each, no `gc.log`. Repo locks are flock files with no dead holders: the lock helper clears dead-holder metadata itself.
- **Transcript capture:** the 02:30Z repair holds. Ticks at 03:21Z and 04:20Z each captured 32 sessions in about 13s, exit 0.
- **rc=124 (3h):** journal-contention-watch notice deliveries deferred at the tick budget ×8. That is the designed behavior of `85389eda`, now deployed. monk/4 `endojs-endo-but-for-bots-pr1393-gauntlet-clean` hit its own 7214s wall clock (×1, classified transient, requeue cycle 0).
- **Changed:** deleted an orphaned 1.3 GB `tmp_pack` (01:23Z, a leftover of a pre-fix kill) from `$GARDEN_STATE/transcripts/clone`. The pack dir went from 3.7G to 2.4G.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands.

## 2026-10-15T02:30Z (oros-health-checkup-20261015-002013): degraded (transcript capture killed every hourly tick, 27 GB of orphaned tmp_packs) → repaired on-host; fix on main2 `7718822b`

- **Load/mem:** load 3.2/3.3/3.5; 13 GiB of 16 GiB available; swap 532 MiB used.
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1% (165k).
- **Uptime:** 13d8h, no reboot.
- **Deployed vs main2:** root at `8d47418e`. origin/main2 was `85389eda` at claim and is now `7718822b`. fleet/health (01:14Z): `roll_status: deployed`, 0 of 293 units failed. Self-deploy deferred at 01:58Z because monk 5 was mid-job for 1354s. That is the normal long-job rule; no drain was engaged.
- **Units:** 0 failed; monks 1 to 6 running (the scaler wants 6; the cap row is 8). No drain; no oros derotation marker.
- **Budget heartbeat:** claude-oros sampled at 01:33Z, status ok, 3% used; the file was updated at 01:45Z.
- **rc=124 (3h):** transcript-capture self-heal 600s kill on every tick (the finding below). journal-contention-watch finishes every tick but defers its notice delivery (`2s tick budget remaining`), which `85389eda` fixes when it deploys. deploy-garden ×1.
- **Finding (repaired on-host, fixed on main2 `7718822b`):**
  - Every hourly `garden-transcript-capture` tick hit the self-heal 600s handler bound before pushing, so the script's own 720s tick deadline never applied. oros has been archiving no transcripts, and 679 spool rows are backlogged.
  - The cause: each `git add` in the sparse, blob:none capture clone spent about 14s in `clear_skip_worktree_from_present_files`, and a batch is 32 adds.
  - Each kill left a 1-2 GB `tmp_pack` behind: 21 of them, 27 GB in `$GARDEN_STATE/transcripts/clone`. Earlier notes' "no tmp_pack" missed this clone.
  - On-host: set `sparse.expectFilesOutsideOfPatterns=true` on the clone (one add now takes 0.08s) and deleted the stale tmp_packs (27G → 4.1G). Also removed a stray empty `$GARDEN_STATE/tmp.1m3H4IjAaE` from 10-12.
  - Verified: the 02:20Z tick captured 32 sessions and pushed in 3 minutes. At 32 per hour, the backlog drains in about 21 hours.
  - main2 `7718822b`: sets the config in code, stages a batch with one `git add`, and sets the unit's `SELF_HEAL_HANDLER_TIMEOUT=840` (tick 720 < 840, and 840 + 20 grace < TimeoutStartSec 900). Test scenario K was added; transcript-capture-test passes 31 of 31.
- **Needs the maintainer:** nothing new. The `journal-worktree-keeper/backups` retention question from 10-14 still stands.

## 2026-10-15T01:45Z (oros-health-checkup-20261014-211624): healthy; the contention watch finishes inside its bound now but starved on a stuck notice → fix on main2 `85389eda`

- **Load/mem:** load 3.1/3.9/3.4; 13 GiB of 15 GiB available.
- **Disk/inodes:** 6% of the overlay used (405G free); inodes 1% (165k).
- **Uptime:** 13d8h, no reboot.
- **Deployed vs main2:** root at `8d47418e` = origin/main2 at claim. fleet/health (01:14Z): `roll_status: deployed`, 0 of 293 units failed. The 20:35Z fix `624ea1f3` is live.
- **Units:** 0 failed; monks 1 to 6 running (scaler-managed). No drain; derotation untouched.
- **Budget heartbeat:** claude-oros sampled at 01:18Z, status ok, 3% used, on a 15-minute cadence.
- **Root store:** 28 packs, 469M, no `gc.log`, no tmp_pack; root-repo-guard is healthy every 30m. State clones are at ≤60 pack files with no tmp_pack, and there are 0 dead-pid repo-lock holders.
- **rc=124 (4h):** journal-contention-watch TimeoutStartSec kills stopped at 23:30Z, after the deploy of `624ea1f3`. transcript-capture self-heal ×1/h is recurring.
- **Finding (fixed on main2 `85389eda`, not yet deployed):**
  - A pending `journal-contention-storm-lock-contention` close notice loses journal push races for about 200s on every tick.
  - The pre-sweep and per-clone flushes spent the whole 210s budget on it. Most ticks logged `analyzed 0`, and the cursor sat at 325 of 496 clones from 23:44Z to 00:53Z. Progress came only on the odd tick where delivery was fast.
  - Fix: delivery before and during the sweep stops at `GARDEN_CONTENTION_SWEEP_SHARE` (half the tick). A new test case fails without the fix; journal-contention-watch-test passes.
- **Watch:** the open lock-contention alerts are real. The producer, sysop, unblock, repo-watcher and scaler clones are contending, which matches the 10-01 diagnosis (CAS losses under load).
- **Changed:** nothing on-host.

## 2026-10-14T20:35Z (oros-health-checkup-20261014-170518): degraded (garden-journal-contention-watch killed by TimeoutStartSec on every tick since 10-13 19:00Z) → fix on main2 `624ea1f3`; otherwise healthy

- **Load/mem:** load 2.7/3.3/3.4; 13 GiB of 16 GiB available; swap 531 MiB used.
- **Disk/inodes:** 6% of the overlay used; inodes 1% (165k).
- **Uptime:** 13d2h, no reboot.
- **Deployed vs main2:** root at `460f0598`, behind origin/main2. `upgrade-ready` was set at 19:47Z, for `f3fa2078`, now `624ea1f3`. fleet/health: `roll_status: deployed` at `460f0598`; no roll release names oros yet.
- **Units:** 0 failed; monks 1 to 7 running. No drain. The derotate marker (`control-plane-unavailable`, 17:05Z, prior_monk 8) is untouched.
- **Budget heartbeat:** claude-oros sampled at 19:33Z, status ok, 3% used; the file was updated at 19:45Z.
- **Root store:** 7 packs, no `gc.log`. State clones are at ≤50 packs, with no tmp_pack.
- **rc=124 (30m):** journal-contention-watch ×7 (the finding below), transcript-capture ×1 (self-heal 600s, recurring).
- **Finding (fixed on main2 `624ea1f3`, not yet deployed):**
  - `garden-journal-contention-watch` has hit `TimeoutStartSec=240` on every tick since 10-13 19:00Z, about 13 per hour. With `Restart=on-failure` it re-runs after 30s, so it runs almost continuously and never analyzes a clone. It last logged at 18:28Z.
  - The cause is the clone index walk: `find $GARDEN_STATE -maxdepth 8 -type d -name .git -prune`. It prunes only `.git`, so it walks every journal checkout, dep-cache's node_modules, repo-locks, and the keeper's backups. That is about 4M entries and took 288s.
  - Fix: `jc_list_repos` stops at repositories and skips those trees. On live state it finds the identical 52 repos in 19s. A test case was added; journal-contention-watch-test passes.
- **Needs the maintainer:** `journal-worktree-keeper/backups` holds 104 lossless dirty-tree backups (since 2026-09-14, about 2.6M files) with no retention policy. Pruning them is your call.
- **Changed:** nothing else on-host. The contention watch recovers when oros deploys `624ea1f3`.

## 2026-10-14T19:30Z (oros-health-checkup-20261013-223508, reaper re-run): healthy (confirms the 19:20Z note; deployed 460f0598, one behind main2 f3fa2078, which is waiting for a leader release)

- Load 3.8/3.5/2.9; 12 GiB available; disk 6%, inodes 1%; uptime 13d2h. 0 failed units; monks 1 to 7 running. No drain; derotation untouched.
- Budget heartbeat sampled at 19:06Z, status ok, 3% used. fleet/health shows `roll_status: deployed` at `460f0598`.
- `journal/` is current again (the keeper fast-forwarded 26 commits at 19:15Z). The root store has no `gc.log`, 17 packs, 468M, and one 12-byte `tmp_pack` from 15:23Z, which the guard's gc will reap after `f3fa2078`.
- **Changed:** nothing; the 19:20Z run already did the repairs.

## 2026-10-14T19:20Z (oros-health-checkup-20261014-140506): degraded (journal/ falsely STALE for 2.5h; the root store's auto-gc was killed every tick) → repaired on-host; fix on main2 `f3fa2078`

- **Load/mem:** load 2.4/2.6/2.6; 13 GiB of 15 GiB available; swap 532 MiB used.
- **Disk/inodes:** 6% of the overlay used (405G free); inodes 1%.
- **Uptime:** 13d01h, no reboot.
- **Deployed vs main2:** root at `460f0598` = origin/main2 at claim. fleet/health (18:32Z): `roll_status: deployed`, 0 of 293 units failed.
- **Units:** 0 failed; 7 monks running. No drain marker; derotation untouched.
- **Budget heartbeat:** claude-oros sampled at 18:39Z, status ok, 3% used. Commit `77974c76` landed at 18:53Z.
- **rc=124 (3h):** journal-worktree-keeper ×4 (600s handler bound, the finding), transcript-capture ×3, library-link-scan ×1, root-repo-guard gc ×1 (16:59Z), journal-contention-watch notice deferrals ×8.
- **$GARDEN_STATE:** clones at ≤49 packs, no tmp_pack. Pruned 73 dead-pid repo-lock holder files.
- **Finding (repaired on-host, fixed on main2 `f3fa2078`):**
  - The root store had 59 packs (auto limit 50, 1.4M objects). Fleet git runs a foreground `gc --auto` on every non-fetch command, and the 120s GARDEN_REPO_GIT_TIMEOUT kills it every time, so the packs never consolidated.
  - The keeper's fast-forward landed and was then killed inside auto-gc, so it logged `STALE` / `STALE-THRESHOLD` (behind=95) every tick from 16:15Z and overran its 600s handler bound.
  - root-repo-guard's own 420s gc had failed with rc=124 on every attempt since at least 10-13 11:22Z.
  - On-host: ran root-repo-guard with a 1800s gc budget. gc succeeded in 8m12s (19:05 to 19:13Z): 59 packs → 2, `OBJSTORE-REPAIRED`. The keeper then fast-forwarded cleanly (19:17Z, ~30s).
  - Fix (`f3fa2078`): fleet git never auto-gcs the root store or its worktrees (root-repo-guard owns that gc; other repos unchanged). The guard's gc budget goes from 420s to 900s, and its unit's TimeoutStartSec from 1800s to 2700s. New test: root-store-auto-gc-test (passes, fails without the fix); root-repo-guard-test 76/76.
- **Open:**
  - oros rolls to `f3fa2078` through the normal deploy. The new TimeoutStartSec applies only after the unit re-render on deploy.
  - Pre-existing, not mine: repo-locks-test fails `CAS writer process` on unmodified HEAD (when run inside a monk); systemd-unit-doc-completeness-test flags the undocumented `garden-namespace-clone-maintenance` units.

## 2026-10-14T15:55Z (oros-health-checkup-20261014-110506): healthy (deployed af3a8456, one behind main2 82fc050e; the roll is deferred behind a long job, as designed)

- **Load/mem:** load 3.6/3.3/3.1; 13 GiB of 16 GiB available; swap 532 MiB used.
- **Disk/inodes:** 6% of the overlay used (404G free); inodes 1%.
- **Uptime:** 12d22h, no reboot.
- **Deployed vs main2:** root at `af3a8456`, so the 14:05Z roll landed. origin/main2 is `82fc050e` (1 ahead), and `upgrade-ready` is set. The roll release names oros for `82fc050e`. fleet/health (15:44Z): `roll_status: deferred`, `deferred_reason: long-job monk 4`, 0 of 293 units failed.
- **Units:** 0 failed. Monks 1 to 7 are running. No drain marker; derotation untouched.
- **Budget heartbeat:** claude-oros sampled at 15:34Z, status ok, 3% used; the file was updated at 15:45Z.
- **rc=124 (3h):** transcript-capture ×3 (hourly, recurring), library-link-scan ×1, and the already-diagnosed self-deploy kill at 13:49Z.
- **$GARDEN_STATE:** no tmp_pack. The largest clone pack dirs hold about 150 files each (monks/4, monitors/monk-2, decisions, reaper), up from a maximum of 50 at 14:05Z. That is not yet bloat; watch it. 0 dead-pid repo-lock holders (the harness cleared one at claim).
- **Deploy blocker:** monk 4 is running `oros-health-checkup-20261013-133505` (claimed at 14:56Z), the reaper-split re-run of an older check-up. It is mid-`post-plan.sh` and still progressing. Self-deploy should roll once it finishes or hits its 3600s wall at about 15:56Z. Nothing to force.
- **Changed:** nothing.
- **Open:** scratch/ has 212 entries older than 24h, and scratch/tmpexec has 1735 entries. Inodes are fine (1%); this is a slow leak for a future GC pass.

## 2026-10-14T14:05Z (oros-health-checkup-20261014-075034): degraded (the deploy to 42863eb0 advanced the tree but was killed mid-restart, so fleet/health still says roll-drained at d82f327a) → two fixes on main2 `af3a8456`

- **Load/mem:** load 2.5/2.8/2.8; 13 GiB of 16 GiB available; swap 511 MiB used.
- **Disk/inodes:** 6% of the overlay used (405G free); inodes 1%.
- **Uptime:** 12d20h, no reboot.
- **Deployed vs main2:** root at `42863eb0` (from `d82f327a`, swapped 13:21:57Z); origin/main2 is now `af3a8456`. The roll release named oros for `42863eb0`. fleet/health (13:06Z): `roll_status: roll-drained`, deployed_sha `d82f327a`, 0 of 292 units failed.
- **Units:** 0 failed. Monks 1, 2, 4, 5 and 6 are running; monks 3 and 7 are in stop-sigterm (see the finding). No drain marker; derotation untouched.
- **Budget heartbeat:** claude-oros sampled at 13:01Z, status ok, 3% used; the file was updated at 13:15Z.
- **rc=124 (3h):** transcript-capture ×3, and garden-self-deploy ×1 at 13:49Z (the finding).
- **$GARDEN_STATE:** no pack-bloated clone (max 50 packs, no tmp_pack).
- **Finding (fixed, main2 `af3a8456`):**
  - deploy-garden lifted its drain and then restarted the monks. The SIGTERM (13:22:13Z) reached monk@3 and monk@7 while each was inside claim-job.sh. bash deferred the trap, so both ran their freshly claimed jobs (this check-up claimed at 13:22:22Z).
  - `systemctl restart` waited on those jobs until self-deploy's 2400s wall clock killed deploy-garden at 13:49Z. The tree had already advanced and the drain was lifted, but the deployed-health pending marker was only written after the restart, so nothing republished `deployed`.
  - Fix: gardener.sh re-checks the stop after a claim; if set, it stamps reap-now and exits without starting the handler. deploy-garden arms the pending marker as soon as the sha is recorded. New tests: claim-stop-race-test (4/4) and a deploy-garden-test subtest for a mid-restart kill. Both fail without the fix.
- **Changed (on-host):** wrote `deploy/deployed-health-pending` = `42863eb0` (what the fixed code writes), so self-deploy's next tick republishes `deployed` for the leader's canary check.
- **Open:**
  - monk@3 and monk@7 restart onto the new code when their current jobs finish (this one ends now).
  - If the leader's canary for `42863eb0` already timed out on the stale record, the next roll (to `af3a8456`) should pass.

## 2026-10-14T10:50Z (oros-health-checkup-20261013-163508, superseded re-run): unhealthy at 08:20Z (roll-drained after 4 of 4 failed 320cfbed canaries) → fix on main2 `8eb6caec`; superseded by the 09:45Z note for the current state

- **Finding (canary blocker, fixed on main2 `8eb6caec`):**
  - Every 320cfbed probe on oros (r0 to r3, 05:32Z to 07:05Z) spent about 10.5 minutes in inbox-read and missed the leader's 600s window.
  - The leader's deadline-nudge had sent a nudge and a checkpoint to each probe at claim. Its 120s `handler-timeout` falls inside the two-tick floor.
  - The two messages force a commit, push, and replay on a fresh per-id clone. An un-nudged probe (`242f944c-r3`) finished in 70s.
  - Fix: deadline-nudge now skips `canary-probe: true` claims. deadline-nudge-test passes 68/68.
- **Open:**
  - deadline-nudge runs on the **leader**. As of 10:45Z the leader's fleet/health still names `fad05c57`, which does not contain `8eb6caec`, so oros canaries are still nudged.
  - Until the leader rolls to 8eb6caec or later, a person may need to pass oros's canary or advance the leader.
- **Changed (on-host, 08:00Z):** pruned 24 dead-pid repo-lock holder files.

## 2026-10-14T09:45Z (oros-health-checkup-20261014-045008): degraded (deployed at 320cfbed; roll to 8eb6caec has been deferred all morning behind long jobs) → one fix on main2, one follow-up job posted

- **Load/mem:** load 2.4/2.9/3.2; 13 GiB of 15 GiB available; no swap.
- **Disk/inodes:** 6% of the overlay used (405G free); inodes 1%.
- **Uptime:** 12d16h, no reboot.
- **Deployed vs main2:** root at `320cfbed`; origin/main2 is `8eb6caec`, now `6c8c058b`. fleet/health: `roll_status: deferred`. It read `long-job monk 4 5068s` at 09:10Z and `long-job monk 6` (this run) at 09:30Z. 0 of 292 units failed.
- **Units:** 0 failed; 6 monks. No drain marker; derotation untouched.
- **Budget heartbeat:** claude-oros sampled at 09:03Z, status ok, 2% used. Pushes landed at 08:05, 08:19, 08:33, 08:59 and 09:03Z, all ok.
- **rc=124:** 18 in the system journal over 3h, all self-heal 600s handler bounds: transcript-capture ×3, library-link-scan ×3, and one each for sysop, requirements-watch, reputation-reducer and journal-worktree-keeper.
- **$GARDEN_STATE:** no pack-bloated clone (max 49 packs, no tmp_pack, no stale `.lock`). 4615 repo-lock key dirs (834 untouched for more than 2 days); inodes are not under pressure, so I left them.
- **Finding 1 (fixed, main2 `6c8c058b`):**
  - monk 4's busy time ran 07:45Z to about 09:40Z for a handler that died at 08:47Z.
  - Classify took 08:47→09:00Z. The `handler-budget-overrun` maintainer alert (`watchdog-notice.sh`, up to 50 push retries on the contended producer clone) then ran from 09:02Z for more than 30 minutes, before the reaper hint was stamped (09:26Z).
  - The gardener now stamps the hint first and sends the alert detached.
  - `handler-budget-test` was also failing closed for every subtest: its pool was seeded for the retired `gardener` kind. Fixed, plus a slow-alert subtest; 14/14 pass.
- **Finding 2 (posted `fix-reaper-supersede-stale-scheduled-recurrence`):**
  - The stale check-up `oros-health-checkup-20261013-163508` (first run 00:26Z, reaped 04:33Z) was re-claimed at 07:27Z, long after three newer check-ups had been dispatched. It ran a full hour and hit its wall again.
  - Its deadline-overrun stamp now makes it eligible for a split into an orchestration, which would be a third run of a superseded check-up.
- **Changed (on-host):**
  - removed 7 orphaned per-id inbox clones (8 remain);
  - pruned 21 dead-pid repo-lock holder files older than 1h.
- **Open:**
  - oros needs a quiet window to roll to main2 (≥ `d43e3363` for the inbox-read fix; ≥ `6c8c058b` for this fix).
  - The 3600s check-ups themselves keep the deploy deferred while they run.
  - Claim to busy took 18 minutes (07:27→07:45Z) on monk 4, which is the pre-`d43e3363` inbox-read deepen.

## 2026-10-14T05:00Z (oros-health-checkup-20261014-015008): degraded (deployed at e1e898bd; roll to 320cfbed is deferring behind long jobs, not failing) → on-host pruning only, no code change

- **Load/mem:** load 4.7/3.5/3.4; 13 GiB of 15 GiB available; swap 507 MiB used.
- **Disk/inodes:** 6% of the overlay used (405G free); inodes 1%.
- **Uptime:** 12d11h, no reboot.
- **Deployed vs main2:** root at `e1e898bd`; origin/main2 is `320cfbed` (the target includes `369ca75a` and `d43e3363`). fleet/health at 04:41Z: `roll_status: deferred`, `long-job monk 3 4948s`, 0 of 292 units failed.
- **Units:** 0 failed; 6 monks running. No drain marker; derotation untouched.
- **Budget heartbeat:** claude-oros sampled at 04:34Z, status ok, 2% used; the file was updated at 04:45Z.
- **rc=124:** 11 in the system journal over 3h. One was the previous check-up `…133505`, which hit its own 3600s handler budget at 04:18Z even though it had written its log note at 03:50Z.
- **$GARDEN_STATE:** no pack-bloated clone (largest is 48 packs, no tmp_pack). 97 per-id inbox clones, 84 of them for jobs not in doin/todo/plan.
- **Finding (deploy blocker):**
  - deploy-garden defers whenever any worker has been busy longer than 300s (`GARDEN_DEPLOY_LONG_JOB_THRESHOLD`). On oros, monk 3 sat in post-timeout handling for `…133505` for about 28 minutes: classify 04:18→04:32, overrun stamp →04:46. This check-up and monk 1's gauntlet fix are also long jobs.
  - The deferral works as designed: the conductor waits rather than failing the canary. I left the drains alone, so the roll proceeds at the next quiet window or through the leader's quiesce.
  - Until `d43e3363` lands here, the first inbox-read still costs 11 minutes (seed 03:07→03:18 for `…133505`).
- **Changed (on-host):**
  - removed 79 orphaned per-id inbox clones (job no longer live, idle more than 2h, no process referencing it). 17 remain.
  - pruned 254 dead-pid repo-lock holder files older than 1h.
- **Open:**
  - `doin/` still lists the finished `oros-health-checkup-20261013-223508` and `canary-probe-…242f944cdf7d-r3` claims; the reaper should clear them.
  - The post-handler journal work after an rc=124 is slow on virtiofs (about 28 minutes), and it holds a busy marker that blocks the deploy.

## 2026-10-14T03:50Z (oros-health-checkup-20261013-133505): degraded (deployed at main2 e1e898bd, but canary validation still fails; roll-drained again since 03:37) → one fix on main2; a posted fixer job landed the second

- **Load/mem:** load 3.6/3.5/3.4; 13 GiB of 15 GiB available; swap 499 MiB used.
- **Disk/inodes:** 6% of the overlay used (405G free); inodes 1%.
- **Uptime:** 12d10h, no reboot.
- **Deployed vs main2:** root at `e1e898bd` = origin/main2 (deployed 02:31Z).
- **Units:** 0 failed; 6 monks running. One `garden-journal-contention-watch` start timed out at ~02:34Z.
- **Budget heartbeat:** claude-oros sampled at 03:03Z and 03:33Z, status ok, 0% used. Recent pushes ok.
- **rc=124:** 7 self-heal handler timeouts in 3h: transcript-capture ×3, library-link-scan ×2, regenerate-sections-index ×1, self-deploy ×1.
- **Drain:** draining since 03:37Z, `source: rolling-deploy` (canary retry 2/3 pending). I did not touch it. Derotate marker exists only for endolin-garden2.
- **$GARDEN_STATE:** 90 journal clones and no pack-bloated clone (none over 50 packs). 1720 of 1727 repo-lock holder metadata files belonged to dead pids.
- **Finding 1 (fixed):**
  - The 02:31Z deploy to `e1e898bd` succeeded, but its post-deploy fleet/health publish was still retrying when self-heal killed the deploy at the 2400s bound (02:58Z).
  - Once the tree was current, self-deploy exited before any publish, so the leader read `deferred @ 242f944c` for 50 minutes.
  - I republished it by hand at 03:21Z. The leader then posted probe r2, and monk-2 claimed it in 2 minutes; the aba64ba1/e1e898bd claim fixes work.
- **Finding 2 (open):**
  - The probe's round trip still took 14 minutes, because the first `inbox-read` built a per-id journal clone. It was seeded 03:25:55; the `--unshallow` deepen failed at 03:36 and reached the boundary at 03:39.
  - The leader failed the canary at 600s and roll-drained oros at 03:35Z. Retry r3 will hit the same thing.
- **Changed:**
  - main2 `369ca75a`: deploy-garden leaves a `deployed-health-pending` marker until its publish lands, and self-deploy republishes it on the next tick. rolling-deploy-test passes 127/127.
  - On-host: republished the fleet/health `deployed @ e1e898bd` record; pruned 1957 dead-pid repo-lock holder files older than 1h.
  - Fixer job `fix-inbox-read-deepen-canary-latency`, posted for Finding 2, landed as main2 `d43e3363` (03:55Z, endolin cleric). inbox-read no longer deepens its clone.
- **Open:**
  - oros needs the next roll (≥ `d43e3363`) to pick up both fixes. Until then, a canary still pays the first-inbox-read deepen.

## 2026-10-14T01:35Z (oros-health-checkup-20261013-163508): unhealthy (canary roll for 242f944c halted after 3/3 failed probes; host drained by rolling-deploy since 01:04) → one fix on main2; a peer landed the second

- **Load/mem:** load 2.0/5.5/5.9; 13 GiB of 15 GiB available; no swap.
- **Disk/inodes:** 6% of the overlay used (405G free); inodes 1%.
- **Uptime:** 12d8h, no reboot.
- **Deployed vs main2:** `242f944c` has been deployed since 00:18Z, and fleet/health said `deployed`. origin/main2 is now `e1e898bd`. `GARDEN_JOURNAL_CLONE_BASE` is still unset.
- **Units:** 0 failed. After an ExecStart change on disk, monk units printed "changed on disk", so I ran `daemon-reload`. Only monk 3 (this run) is up; the others exit "fleet draining". No derotation marker for oros.
- **Budget heartbeat:** claude-oros was sampled at 00:34Z: 0% used, status ok.
- **rc=124:** 33 in the last 3h.
- **$GARDEN_STATE:** 86 journal clones. I skipped the stale-lock scan because it times out on virtiofs.
- **Finding:** the leader released oros as canary for `242f944c`. Probes r1, r2 and r3 each missed their 600s deadline, so the roll drained oros at 00:33 (retry) and again at 01:04 (final). The spine itself was healthy. Two causes:
  1. **Probe posted mid-pass, never seen.** Probes go first only in the snapshot a claim pass takes when it starts. Five idle monks spent 00:18–00:42 in a single pass, losing every race on 12 aged jobs at about 2 min per attempt, so r1 and r2 were never tried.
  2. **Every claim push lost its CAS.** At 00:52–00:55 all five monks did try r2 and r3. Every push lost its CAS to unrelated journal writes and nobody won. Each attempt leaves from a tip about 90s old, because `sync_clone` resets over the whole board on virtiofs.
- **Changed (main2):**
  - `aba64ba1` (this run): a canary probe that appears mid-pass preempts the claim pass at the next candidate boundary. New test `claim-late-canary-probe-test.sh`: 3/3 pass on the fix; the old code fails the 2 preemption cases.
  - `e1e898bd` (the concurrent `oros-health-checkup-20261013-223508`): a lost probe-claim CAS is replayed onto the fresh tip. I had a broader version that replays every race claim (tested: 5/5 on the fix, 2 fails on the old code). I dropped it rather than override the peer's narrower choice.
- **Open:**
  - The roll for this target is halted and oros is roll-drained. The leader's next roll, to `e1e898bd` or later, should re-release it. I did not touch the drain.
  - Ordinary claims still starve on oros: 00:18–00:42 had 1 win in about 60 attempts, every loss a CAS. To fix it, either replay every race claim (its check reads only the paths it writes, so the existing replay CAS covers it) or recreate the container with `GARDEN_JOURNAL_CLONE_BASE`. That is a maintainer decision.
  - The deploy-gate test runs are slow and flaky here. `claim-aging-priority-test` lost one case to a virtiofs "hardlink different from source" error during a local clone, which is unrelated to the code.

## 2026-10-14T01:30Z (oros-health-checkup-20261013-223508): degraded (deployed at 242f944c, but the roll's canary probe was never claimed and the roll re-drained oros) → one fix on main2

- **Load/mem:** load 3.9/3.1/2.9; 13 GiB of 15 GiB available; swap 449 MiB used.
- **Disk/inodes:** 6% of the overlay used (405G free); inodes 1%.
- **Uptime:** 12d8h, no reboot.
- **Deployed vs main2:** fleet/health shows `deployed @ 242f944c`, 0 of 294 units failed, published at 00:18Z. origin/main2 is now `e1e898bd`, this run's fix. `GARDEN_JOURNAL_CLONE_BASE` is still unset.
- **Units:** 0 failed; 6 monks (scaler holds 6 of 6 declared). Only 2 busy, both oros check-ups (this run and the sibling `…163508`).
- **Drain:** **draining** since 01:04Z, `source: rolling-deploy`. The leader (endolin) sent a sysop drain because the canary failed: probe `…242f944cdf7d-r3` did not reach tada within 600s. Derotate markers exist only for the endolin hosts.
- **Budget heartbeat:** claude-oros was sampled at 00:34Z: 0% used, status ok. The last 3 pushes (00:02, 00:18, 00:34) were all ok.
- **rc=124:** 23 in the last 3h.
- **$GARDEN_STATE:** 38 journal clones (86 at 20:45) and no tmp_pack leftovers. The `.lock` files older than 1h are flock files, not held locks.
- **Finding:** the canary probe was never claimed, so the roll failed a healthy canary.
  - From 00:52 to 00:55Z all five idle monks tried to claim r2, then r3. Every attempt logged "lost claim race".
  - All 3967 recorded monk push failures are class `cas`. Each claim is decided at a clone tip about 90s old on virtiofs, so any peer write wins. claim-job then moves on to the next candidate instead of retrying.
- **Changed (main2):** `e1e898bd`: a canary probe's claim now replays a lost CAS onto the fresh tip without the worktree (the existing `journal_replay_head`, default 3 attempts).
  - The replay still checks the probe's own todo/ path, so a probe that a peer claimed or the roller withdrew is never claimed a second time. Ordinary claims still re-derive.
  - New test `claim-probe-replay-test.sh`: 5/5 pass on the fix; the old code fails the 2 replay cases.
  - A sibling fix landed alongside it: `aba64ba1` lets a canary probe posted mid-pass preempt the claim pass.
- **Changed (on-host):** nothing. The drain was left as it was (the roll owns it).
- **Open:** oros stays drained until the leader's roll re-releases it with a fresh probe. Once oros deploys `e1e898bd`, the probe claim should land. The root cause is still the virtiofs journal clones: the container needs to be recreated with `GARDEN_JOURNAL_CLONE_BASE` (see the 18:55 entry).

## 2026-10-13T20:45Z (oros-health-checkup-20261013-193508): degraded (deployed at 9e4b600c, but its health record never published, so the roll stalled) → one fix on main2, health record republished

- **Load/mem:** load 4.3/3.3/3.0; 12 GiB of 15 GiB available; no swap.
- **Disk/inodes:** 6% of the overlay used (405G free); inodes 1%.
- **Uptime:** 12d3h, no reboot.
- **Deployed vs main2:** `9e4b600c` has been deployed since 17:20Z (the host-local deployed-sha). origin/main2 is now `242f944c`, this run's fix. `GARDEN_JOURNAL_CLONE_BASE` is still unset.
- **Units:** 0 failed (294); 8 monks running; not drained; derotate markers exist only for the endolin hosts.
- **Budget heartbeat:** claude-oros was sampled at 19:35Z: 0% used, status ok.
- **rc=124:** 54 in the last 3h, from the system journal.
- **$GARDEN_STATE:** 86 journal clones (114 at 15:15). The bounded `du`/stale-lock scan timed out (virtiofs), so its result is unknown. The upgrade-monitor fetch of main2 fails twice every 30 min (at :17/:22 and :47/:52) and recovers each time; it stays well under its alert threshold.
- **Finding:** the 17:20 deploy of `9e4b600c` stalled after it lifted the drain.
  - Its fleet-restart wave waited on monk 5. That monk was inside a slow `claim-job.sh` pass when it got SIGTERM. Bash defers the TERM trap, so at 17:26 the monk claimed `claude-on-minion-town-press-20261013-163508` and ran it to 19:07.
  - Self-heal killed `deploy-garden.sh` at 2400s (17:43). The kill skipped `publish_fleet_health`, so `fleet/health` showed `8fd22da4` and `deploy/roll/oros` stayed released at `9e4b600c`.
- **Changed (main2):** `242f944c`: claim-job.sh abandons the claim pass, with rc=3 and nothing claimed, when the worker's own unit is `deactivating`.
  - New test `claim-stops-when-unit-stopping-test.sh`: 4/4 pass on the fix; on the old code the stopping worker claims the job.
- **Changed (on-host):** republished `fleet/health` for oros at `9e4b600c` through `publish_fleet_health`, so the leader can validate the canary.
- **Open:** `deploy-garden.sh`'s restart wave is still unbounded. A worker that is already mid-job when the drain lifts can still hold it for up to `TimeoutStopSec`. The container still needs to be recreated with `GARDEN_JOURNAL_CLONE_BASE` (see the 18:55 entry). No drains, leveling or schedules were touched.

## 2026-10-13T18:55Z (oros-health-checkup-20261013-102024, resumed after reaper requeue; first pass 12:13–13:10Z): degraded (journal clones still on virtiofs) → one fix on main2, now deployed

- **Load/mem:** load 3.5/3.3/3.1; 13 GiB of 15 GiB available.
- **Disk/inodes:** 6% of the overlay used (405G free); inodes 1%.
- **Uptime:** 12d1h, no reboot.
- **Deployed vs main2:** fleet/health is `deployed @ 8fd22da4` (16:43Z). origin/main2 `9e4b600c` is ahead by later commits only.
- **Units:** 0 failed; 7 monks running; 3 busy.
- **Budget heartbeat:** the claude-oros snapshot was sampled at 18:34Z, 0% used, status ok.
- **rc=124:** 52 since 16:00Z (rough count).
- **First pass (12:13–13:10Z):** the deploy of `f4a9a985` was deferred on `long-job monk 5`.
  - Monk 5's handler had ended at 10:05 (rc=124). It then spent about 1.5h posting one progress entry under producer-clone lock contention, and 37 min in a best-effort handler-budget-overrun `watchdog-notice`. I stopped that notice and the busy marker cleared.
  - `journal-worktree-keeper` held the root repo's EXCLUSIVE lock while it delivered fffail and stale notices, minutes each through the producer clone. That blocked every same-host fetch, push and deploy. I stopped both notices.
  - This run's own log push lost CAS races for 20+ min and was reaped (oros's symptom, first-hand).
- **Changed (main2):** `8fd22da4`: the keeper queues alerts and clears them while it holds the lock, and delivers them from an EXIT trap after `garden_repo_unlock`. The keeper test checks this: the old keeper gives 117/1, the fixed one 118/0. Deployed at 16:43.
- **Changed (on-host):** pruned 127 leaked `/var/tmp/garden-triager-pacing.*` test temps, presumably from killed deploy-gate runs.
- **Needs a person at the machine:** `f4a9a985` (hot journal clones on local storage) is **opt-in at container creation**. `GARDEN_JOURNAL_CLONE_BASE` is unset in this container, so the producer and worker clones are still on virtiofs, and claim and post-job journal writes stay slow.
  - To fix: recreate the oros container with `GARDEN_JOURNAL_CLONE_BASE=/var/tmp/garden-journal-clones ./garden` (see the `garden` launcher help).
  - No drains, leveling or schedules were touched.

## 2026-10-13T15:15Z (oros-health-checkup-20261013-042006, second rerun after reaper requeue): degraded (journal git on virtiofs still starves claims and job tails; deploy deferred) → no code change

- **Load/mem:** load 2.3/2.6/2.9; 13 GiB of 15 GiB available; swap 521M used.
- **Disk/inodes:** overlay 6% used (405G free); inodes 1%.
- **Uptime:** 11d21h, no recent reboot.
- **Deployed vs main2:** deployed `bdc2943c`; origin/main2 `8fd22da4`. fleet/health at 14:40 is `deferred`, target `8fd22da4`, reason `long-job monk 7 8923s`.
  - Monk 7's busy marker dates from 12:11. Its handler (the 10:20 health check-up, `oros-health-checkup-20261013-102024`) overran, and since 14:20 the monk has sat in a post-job `watchdog-notice.sh handler-budget-overrun-…`, waiting on the producer clone. As at 10:10, the "long job" self-deploy waits on is a journal write, not real work.
  - Monk 4 has been in `journal-entry.sh error` for 62 min, looping on `flock -w 60` for `producer/journal.lock`. The holder is a `git reset --hard origin/journal2` on the producer clone; sysop and watchdog-notice are also queued behind it.
- **Claim starvation (unchanged):** 4 monks were inside `claim-job.sh` loops for 8–20 min each. Each attempt runs `git reset --hard origin/journal2` on its own virtiofs clone. A plain `find` over `$GARDEN_STATE` timed out at 60s.
- **Units:** 0 failed (294 units); 8 monks; not drained; no derotation marker.
- **Budget heartbeat:** claude-oros was sampled at 14:35 and pushed at 14:45. The weekly window has reset: spend 0.5M, 0% used, status ok.
- **rc=124:** 62 in the last 3h, from the system journal. That is up from about 36 at 10:10.
- **$GARDEN_STATE:** 114 journal clones (87 at 10:10). Pack counts are at or below the gc auto limit of 50, with no tmp_pack. The stale-lock scan did not finish inside its bound, so its result is unknown.
- **Changed:** nothing. The fix is already on main2 but not deployed on oros.
  - `f4a9a985` adds an opt-in `GARDEN_JOURNAL_CLONE_BASE`, which puts the producer and worker checkouts on container-local disk.
  - It only takes effect when the container is created with `GARDEN_JOURNAL_CLONE_BASE=/var/tmp/garden-journal-clones ./garden create`.
  - Nothing was forced, and no drains or leveling were touched.
- **Needs a person at the machine:**
  1. Let self-deploy land `8fd22da4`, or a later commit.
  2. Then recreate the oros container with `GARDEN_JOURNAL_CLONE_BASE` set.
  
  Until then, oros keeps losing claim races and its job tails stall on the producer lock. Those stalls keep self-deploy deferred behind "long jobs", so the deploy and the fix block each other.

## 2026-10-13T10:10Z (oros-health-checkup-20261013-012006, rerun after reaper requeue): degraded (journal git on virtiofs starves claims; deploy deferred) → one fix on main2

- **Load/mem:** load 2.6/3.0/3.2; 13 GiB of 15 GiB available; IO pressure avg300 1.9%.
- **Disk/inodes:** 53% of the virtiofs share used (218G free); inodes 1%.
- **Uptime:** 11d16h, no recent reboot.
- **Deployed vs main2:** deployed `bdc2943c`. fleet/health is `deferred` at 09:43, target `614437c2`, reason `long-job monk 4 5778s`. origin/main2 is now `ca5aa15d` after this run's fix.
  - Monk 4's handler for `claude-on-minion-town-press-20261013-072006` hit rc=124 at 08:57. Since 09:11 the monk has been stuck in a post-job `journal-entry.sh progress`. That script retries sync_clone (`reset --hard` over ~68.5k files) on the shared producer clone, where three entry writers were contending. So the "long job" self-deploy waits on is a journal write, not real work.
- **Units:** 0 failed; 8 monks; not drained; no derotation marker.
- **Budget heartbeat:** the claude-oros snapshot was sampled at 09:34 and pushed at 09:45; spend 62.9M, 27% used, status ok.
- **Claim starvation:** at 10:00, 6 of 8 monks were inside `claim-job.sh`/`usage-append.sh` doing `git reset --hard origin/journal2` on their own clones.
  - A read-only `git status` on one clone took 13.5s. A claim attempt takes about 100–120s.
  - Monk 1 lost every race from 09:11 to 10:00. Monk 4 took 22 min from claim (07:45) to working (08:07).
  - This run's job was the only `claude -p` running on the host.
- **rc=124:** about 36 in the last 3h (counted from the self-heal logs; the method is rough).
- **$GARDEN_STATE:** 87 clones; none over 50 packs; no tmp_pack; no `index.lock` older than 30 min. The live locks belong to the running reset processes.
- **Changed (main2):** `ca5aa15d`: journal-entry.sh opts into `journal_replay_head` (GARDEN_JOURNAL_REPLAY_ATTEMPTS=3), like complete-job, inbox-read and send-msg. commit-replay-test asserts the opt-in. commit-replay and journal-entry argv/dedup/project tests all pass. It deploys with the next roll.
- **Still open (needs design):** claim-job.sh and usage-append.sh still do a full worktree `sync_clone` per attempt. On virtiofs that costs about 100s, so oros loses nearly every claim race to the other hosts. Two possible fixes: a worktree-free claim (graft/replay the todo→doin move), or per-worker journal clones on container-local disk (as `614437c2` did for the deploy gate). Nothing was forced, and no drains or leveling were touched.

## 2026-10-13T08:20Z (oros-health-checkup-20261013-042006): degraded (deploy stuck behind gate) → two fixes on main2

- **Load/mem:** load 3.4/3.0/3.1 at 07:44, 3.0/3.5/3.7 at 08:17; 12 GiB of 15 GiB available.
- **Disk/inodes:** 6% of the overlay used (405 GB free); inodes 1%.
- **Uptime:** 11d14h, no recent reboot.
- **Deployed vs main2:** deployed `bdc2943c`; the roll target is `548243e2`. origin/main2 is now `32099c2c` after this run's fixes.
  - 06:53 attempt: the gate passed, then the deploy deferred at 07:08 behind `long-job monk 4 3454s`. That monk was already about 2550s into its job when the gate started.
  - 07:10 attempt: rejected for total-wall-clock (terminal-handler-failure-reap and triager-pacing hit rc=124, both near the end of their output).
  - 07:30 attempt: rejected at 08:05 for total-wall-clock (codex-policy-refusal-resume hit rc=124). This run's own test runs added load during that window.
  - Self-deploy keeps retrying by itself; nothing was forced.
- **Units:** 0 failed; 8 monks running; not drained; no derotation marker.
- **Budget heartbeat:** the claude-oros snapshot was sampled at 07:06; spend is 59.5M of 180M, 22% used, status ok.
- **fleet/health:** `deferred @ bdc2943c` (target `548243e2`, reason `long-job monk 4 3454s`), unit_failures 0, as of 07:07.
- **rc=124:** 27 in the last 3h (flat).
- **$GARDEN_STATE:** 30 clones; fleet-health, self-deploy and sysop are at 50 packs each, with no tmp_pack.
  - Removed stale zero-byte `index.lock` files with no holder: `cursors/journal` (since 10-12 20:44) and `transcripts/clone` (since 09-22).
  - Removed a leaked 329M seed temp, `receipt-watcher/journal-endojs-endo-but-for-bots.seed.3950595`. Its pid has been dead since 03:11.
- **Changed (main2):**
  - `4bd91412`: deploy-garden runs the long-job defer check before the candidate gate as well as after it, so a job already past the threshold no longer wastes a 15-minute gate. New deploy-garden-test assertion; the mid-drain case now bypasses the gate so its timing is deterministic. 212/212 pass.
  - `32099c2c`: `_seed_clone_from_root` sweeps sibling `.seed.<pid>` temps whose owner is dead. New seed-from-root case; 19/19 pass.
- **Still open:** the gate budget (900s) is marginal under normal oros load: 2 of the last 3 attempts failed on total-wall-clock, with different suites timing out each time. Consider a per-host total budget or a lighter oros gate. Self-deploy's idle tick still does not republish a mismatched fleet/health record.

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
