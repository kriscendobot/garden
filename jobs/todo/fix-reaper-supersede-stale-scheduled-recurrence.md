---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: fixer.** Garden repo (main2). A scheduled recurring job that has already been **superseded by a newer dispatch from the same schedule** should not run again after a requeue or a deadline-overrun split.

Evidence (oros, 2026-10-14): `oros-health-checkup-20261013-163508` ran at 00:26Z and was reaped/requeued at 04:33Z. Monk 4 claimed it again at 07:27Z, hours after the newer check-ups `…223508`, `…015008` and `…045008` were dispatched. It ran a full stale check-up and hit its 3600s wall (rc=124 at 08:47Z). Its 09:26Z deadline-overrun stamp now makes it eligible for split-orchestrator decomposition, which would be a third run. Each rerun is also a long job that holds oros's deploy (`roll_status: deferred, long-job monk 4 …`).

Ask: when the reaper requeues or splits a job carrying a schedule dispatch identity (`schedule(<name>) dispatched <base>`; the base is `<name>-<YYYYMMDD-HHMMSS>`), check whether a NEWER dispatch of the same schedule exists in todo/doin/tada. If one does, retire the stale one to tada as `superseded` rather than requeueing or splitting it. Keep it deterministic, opt out for schedules whose runs are not interchangeable if any, and add a reaper test. Check for an existing mechanism first, so you don't duplicate one.
