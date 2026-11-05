# Host health: oros-studio-garden-ce242c49

Mechanic records continue the [legacy oros health log](../oros-health-log.md).
Insert completed records newest first, above the template.

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
