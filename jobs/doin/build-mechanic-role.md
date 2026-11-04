---
role: builder
tier: mentor
posted_at: 2026-11-04T22:15:15Z
handler-timeout: 3600
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-04T22:30:06Z cleared=none -->

---
role: builder
handler-timeout: 3600
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: builder.** **Build the `mechanic` role as designed** (maintainer: "post the design and build whatever is designed; we can improve it with use", kriskowal, 2026-11-04). The design job `design-mechanic-role` (first child of this orchestration) has landed `designs/mechanic-role.md` on `main2`; read it and implement exactly what it specifies, nothing broader.

Expected artifacts (the design is authoritative where it differs): `roles/mechanic/AGENT.md`; any skill(s) under `skills/<name>/SKILL.md` the design names (for example a host-repair playbook); the CLAUDE.md `Current inventory` role list entry; a pointer from `context/operations/health.md` or `host-operations.md`; any scripts under `scripts/jobs/` the design calls for, with tests; and rewrites of the recurring `oros-health-checkup` / `oros-health-watch` schedule bodies to use the mechanic role if the design says to (via `scripts/jobs/set-schedule.sh`, per the schedule skill).

Garden conventions: land direct to `main2` (no PR for the garden's own repo), roles reference skills by path and never inline them, keep files short, match surrounding style. Run the repo's relevant script tests before pushing. If the design left an open question that blocks the build, build the unblocked part and report the rest rather than guessing.


<!-- garden-annotation: key=36f79c57d270 by=producer at=2026-11-04T22:15:51Z -->

SCOPE AMENDMENT (maintainer, 2026-11-04): the mechanic role is general to all leaders and followers and any mechanical host failure; implement the design's full host scope, not oros alone.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-11-04T22:31:36Z
