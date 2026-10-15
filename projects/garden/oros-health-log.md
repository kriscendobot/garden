# oros-studio-garden-ce242c49 health log

Newest first. One note per `oros-health-checkup-*` run.

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
