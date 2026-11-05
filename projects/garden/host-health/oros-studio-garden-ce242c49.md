# Host health: oros-studio-garden-ce242c49

Mechanic records continue the [legacy oros health log](../oros-health-log.md).
Insert completed records newest first, above the template.

## 2026-11-05T07:33Z - oros-health-checkup-20261105-072053

- Verdict: healthy
- Target / role / mode: oros-studio-garden-ce242c49 / follower (leader marker: endolin-garden-ece02cb4) / local
- Trigger: schedule/oros-health-checkup
- Evidence: fleet/health 07:11:32Z roll_status deployed, unit_failures 0 of 291, advisory 0; 0 failed units locally at 07:27Z; no local draining marker; deploy/roll, deployed SHA, and origin/main2 all d1453f822b8, so no pending release and no early exit; canary probe done 07:19Z; budget claude-oros status ok, 25% (sample 07:03Z); disposition 3h 20 claims, 17 completions, 4 terminal, 1 transient, report tip 13952af3f373; load 2.05, 12G memory available, swap 1.0G of 1.0G full with si/so 0 over vmstat; virtiofs 94% used, 30G free, 4% inodes; /tmp 18%; up 34 days; contention probe outage_skips=0, latch off, checker heartbeat 87s, last watcher tick partial-poll with 4 clones deferred; 8 latched contention/fetch-slow alert files, 0 notices pending; root .git 6 packs, 560M, no gc.log; largest namespace clones 49 packs, 0 tmp; newest sysop record 20261105T063504Z-280db5 rolling-deploy-quiesce drain applied, since lifted. rc=124 in the 3h journal: garden-gardener-scaler over its 600s self-heal bound once (05:40Z), backfill-receipt-rollup-20261105 at its 2400s wall (05:57Z), three contention-notice deliveries deferred (06:44, 06:47, 06:59Z). The scratch-tree du did not finish within 240s and was stopped, so scratch size is unmeasured; stale lock-holder liveness was not individually checked (the same command was stopped before reporting it fully).
- Cause: no host failure established. All 4 terminal hints are on one job, kriscendobot-minion.town-pr199-land-20261104-gauntlet-wait: handler rc=76 at 04:46, 05:10, 05:36, 06:17Z and rc=75 at 07:15Z, on all three monks, reclaimed again at 07:14Z. rc=76 is the gardener's unverified-handoff exit, so the repeats are job behavior; why that job exits this way was not traced. Six system run-u*.service starts failed on a missing environment file at 06:04Z (GUEST_RECOVERY_KEY check); these are not garden-* units, did not recur, and their source job was not traced.
- Actions: none. No sysop operation, worker-count change, drain change, or code change.
- Final state: heartbeat current, 3 monks active and claiming after deploy (07:14, 07:17, 07:21, 07:26Z), deployed d1453f822b8 equal to origin/main2, undrained, 0 failed units.
- Maintainer: none
- Next mechanic: virtiofs free space keeps falling (36G at 23:24Z, 32G at 01:43Z, 31G at 04:51Z, 30G now) and needs an owner if it passes below 20G; measure scratch with a bounded du. Check whether the pr199 wait job is still cycling; it holds a monk slot each cycle. Root packs fell from 127 to 6, so that earlier growth concern is closed. Orphan-check .garden-state/receipts-backfill-20261105 (824M, its alert dated 07:06Z; the successor job ran on endolin).

## 2026-11-05T04:58Z - oros-health-watch-20261105-042023

- Verdict: healthy
- Target / role / mode: oros-studio-garden-ce242c49 / follower (leader marker: endolin-garden-ece02cb4) / controller
- Trigger: schedule/oros-health-watch
- Evidence: the paired local mechanic completed at 04:57:36Z after inspecting at 04:51Z and landing its standard record at 04:54:19Z; it found 0 failed or advisory units out of 291, no local drain marker, current budget and fleet heartbeats, 3 active monks, load 3.03, 12G memory available, 31G virtiofs headroom, contention latch off, and no root gc.log. Fleet health at 04:51:26Z remained deferred with deployed f4dcb3c044e and current release target d4f21341dcc. The 3h disposition report at journal tip 64e1321fd8b4 showed 23 claims, 17 completions, 4 terminal hints, 1 transient kill, and 3 in flight; the local run traced the terminal hints to two job-specific bases. Newest sysop record 20261105T021102Z-61948f applied a roll-owned drain that is now lifted.
- Cause: no host failure established. Deployment is normally deferred behind endojs-endo-but-for-bots-pr1648-fix-2 on monk 2; the repeated pr199 gauntlet-wait exits are job-specific and not evidence of a host fault.
- Actions: observed only; no sysop operation, worker-count change, drain change, or code change. The active rolling-deploy workflow retains ownership of the release.
- Final state: heartbeat current, 3 monks active and claiming/completing, deployed f4dcb3c044e with d4f21341dcc pending, undrained, and 0 failed/advisory units.
- Maintainer: none
- Next mechanic: confirm deployed SHA reaches d4f21341dcc after monk 2 finishes; check whether pr199 gauntlet-wait's repeated cycle delays rolls. Recheck root pack growth (65 at 23:24Z, 127 at 04:51Z) and virtiofs free-space decline (36G to 31G) on the next unobstructed local run.

## 2026-11-05T04:51Z - oros-health-checkup-20261105-042023

- Verdict: healthy
- Target / role / mode: oros-studio-garden-ce242c49 / follower (leader marker: endolin-garden-ece02cb4) / local
- Trigger: schedule/oros-health-checkup
- Evidence: fleet/health 04:36:39Z unit_failures 0 of 291, advisory 0, roll_status deferred; no failed units locally; no local draining marker; deploy/roll names 7b151b7149f, deployed f4dcb3c044e (matches leader-sha), origin/main2 d4f21341dcc, 3 commits ahead per upgrade-ready 04:47Z; deploy/deferred names long job monk 2, 4603s at 04:36Z, which is endojs-endo-but-for-bots-pr1648-gauntlet-fix-2, claimed 03:19Z; budget claude-oros status ok, 23% (sample 04:32Z); disposition 6h 50 claims, 41 completions, 4 terminal, 1 transient, 3 in flight; load 3.03, 12G memory available, swap 1.0G of 1.0G full with si/so 0 over a 3s vmstat; virtiofs 94% used, 31G free, 4% inodes; /tmp 18%; up 34 days; contention probe tail outage_skips=0, latch off, checker heartbeat 131s; root .git 127 packs, 596M, no gc.log; newest sysop record 20261105T021102Z-61948f drain accepted-and-applied, since lifted (no marker).
- Cause: no host failure established; the deferral is the normal long-job deferral on an active roll release. All 4 terminal-failure hints are job-specific: 3 on kriscendobot-minion.town-pr199-land-20261104-gauntlet-wait (03:43, 04:06, 04:31Z, reclaimed on monk 1 at 04:40Z) and 1 on kriscendobot-minion.town-pr237-gauntlet-20261105 (03:10Z). Cause of those handler failures not traced; the wait job's brief does expect unsignaled exits while its gauntlet is active, which may account for its three.
- Actions: none. Exited early for the active roll release, per the recurrence rule; rc=124 and lock-holder liveness not checked.
- Final state: heartbeat current, 3 monks active, deployed f4dcb3c044e with 7b151b7149f released at inspection (the companion reports the target advanced to d4f21341dcc at 04:50Z), undrained, claims and completions advancing. The deferral itself is unchanged in shape: a roll has advanced since 01:43Z (36a2080657e to f4dcb3c044e).
- Maintainer: none
- Next mechanic: confirm deployed SHA reaches the release once monk 2 finishes; check whether pr199 gauntlet-wait's repeated cycle is delaying rolls. Root packs were 65 at 23:24Z and are now 127, unrepacked and with no gc.log, so recheck growth; virtiofs free space is 31G, down from 32G at 01:43Z and 36G at 23:24Z.

## 2026-11-05T01:43Z - oros-health-checkup-20261105-010527

- Verdict: healthy
- Target / role / mode: oros-studio-garden-ce242c49 / follower (leader marker: endolin-garden-ece02cb4) / local
- Trigger: schedule/oros-health-checkup
- Evidence: fleet/health 01:36:20Z unit_failures 0 of 291, roll_status deferred; no failed units locally; no local draining marker; deploy/roll/oros-studio-garden-ce242c49 names a4d206f4d3f (origin/main2 tip), deployed 36a2080657e; deploy/deferred names long job monk 2, elapsed 2201s at 01:42Z; budget claude-oros used 21% (sample 01:32Z); disposition 6h 27 claims, 23 completions, 0 terminal, 0 transient, 3 in flight; load 2.15, 12G memory available, / 7%, /tmp 18% by df; virtiofs 94% used, 32G free, 4% inodes; contention probe outage_skips=0, latch off; newest sysop record 20261104T235002Z-66539f drain accepted-and-applied.
- Cause: none; the deferral is the normal long-job deferral on an active roll release.
- Actions: none. Exited early for the active roll release, per the recurrence rule. Carried-forward report of a stray 2026-11-04 pkill of a du process needed no action.
- Final state: heartbeat current, 3 monks active, deployed 36a2080657e with a4d206f4d3f pending, undrained, claims and completions advancing.
- Maintainer: none
- Next mechanic: confirm deployed SHA reaches a4d206f4d3f once monk 2 finishes; the pack-growth observations named by the 01:34Z record stay unchecked (exited early for the roll); virtiofs has 32G free.

## 2026-11-05T01:34:00Z - oros-health-watch-20261105-010527

- Verdict: degraded
- Target / role / mode: oros-studio-garden-ce242c49 / follower / controller
- Trigger: schedule/oros-health-watch
- Evidence: the paired local run remained in `jobs/todo/oros-health-checkup-20261105-010527.md` through 01:33:21Z and requirements-watch reported it unclaimed for 901s at 01:22:09Z; the target nevertheless published an `ok` claude-oros budget sample at 01:18:15Z, reported 0/291 failed and 0 advisory units at 00:11:33Z, and claimed work on all three configured monks as recently as 01:23:54Z; the 3h disposition report at journal tip `ba01b556be31` showed 25 claims, 21 completions, 0 terminal failures, 0 transient kills, and 3 in flight; the recovered canary-stuck notice at 00:14:05Z records release and deployed `36a2080657ec`, and the recovered canary-failed notice cleared at 00:20:26Z.
- Cause: the local check did not complete because all three configured monk slots were occupied; no host failure is established. The target is present and processing jobs, but controller evidence cannot replace the queued local load, memory, disk, swap, lock, and journal inspection.
- Actions: observed only; no sysop operation, worker-count change, drain change, or code change. The existing pinned local mechanic remains queued, so no duplicate was dispatched.
- Final state: heartbeat fresh at 01:18:15Z; last unit health 0/291 failed; deployed `36a2080657ec` (one commit behind `origin/main2` at the 01:26 fetch); no active release file; three monks claiming/completing, with the paired local check waiting for a slot.
- Maintainer: none
- Next mechanic: `oros-health-checkup-20261105-010527` owns the missing local inspection when a monk slot frees; first verify its completion and fresh host-health evidence, then recheck the open disk/pack-growth observations from the 23:24Z legacy health note.

## Record template

```markdown
## <UTC timestamp> - <job base>

- Verdict: healthy | degraded | unhealthy | operator-held | unreachable
- Target / role / mode: <GARDEN> / leader|follower / controller|local
- Trigger: <watchdog key, schedule, or maintainer request>
- Evidence: <health record times, sysop msgids/outcomes, narrow log citations>
- Cause: <established cause, or unknown with what is missing>
- Actions: <operations with acks and code commits, or none>
- Final state: <heartbeat, units, deployed SHA, drain, workers claiming/completing>
- Maintainer: <exact requested decision or "none">
- Next mechanic: <remaining condition, owner, and first evidence to check>
```
