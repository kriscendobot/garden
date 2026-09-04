---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-03T00:04:37Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Implement recommendation 8 of `designs/cybernetics-audit.md` § 7 [correct but
couples badly]: send scheduled dispatch through the fleet's one admission
gate. A garden self-improvement job (`skills/self-improvement/SKILL.md`).

Changes to `scripts/jobs/scheduler.sh`:
1. Build the job body, then post via `post-job.sh` — inheriting budget-hold
   routing (`post-job.sh:210-232` routes to `plan/ --budget-hold` when all
   bounded pools are at high water) and the identity index — instead of
   writing `jobs/todo/` directly (`scheduler.sh:403-404`; grep confirms it
   never calls `budget_fleet_status`).
2. Add an occupancy option for RECURRING schedules: skip or carry forward
   when the previous instance is still live — the check the `once:` path
   already performs (`scheduler.sh:396`). Today the basename is
   unconditionally timestamped (`scheduler.sh:425`), so a schedule whose job
   outlives its cadence accumulates one instance per period (the
   `endo-*-press-*` families observed four generations concurrently alive on
   2026-09-01).
3. Decide the scheduler's drain posture EXPLICITLY rather than by omission
   (it has no `fleet_draining` gate; audit § 1.3 names it one of only two
   producers that keep producing under drain). Posting into a drained board
   may well be the intended semantic (schedules should not be lost) — but
   decide and document it. If this turns out to be a genuine open maintainer
   question, use the design-with-open-questions PR carve-out for that part
   instead of landing bare.

Evidence: audit § 3.4; `designs/live-budget-admission.md:174` records the
same bypass class in `gauntlet.sh`/`auction.sh` stage posts (out of scope
here — this job is the scheduler only).

Take care that dispatch stays exactly-once per cadence: the current stamp
and post happen in one CAS commit (`scheduler.sh` § 1.2 of the audit's loop
table) — whatever routing change you make must preserve
stamp-and-post atomicity so a crash cannot double-dispatch or lose a period.

Verify with `skills/local-verify/SKILL.md` + `skills/pre-push-gates/SKILL.md`
(scheduler tests must pass); land bare on `main2` per CLAUDE.md
§ Conventions.


<!-- garden-reaped: 1 -->

<!-- garden-transient-elapsed: kind=signature through=1 values=2,2 -->
<!-- garden-elapsed-constancy: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-03T20:03:40Z
