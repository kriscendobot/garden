---
ts: 2026-05-15T02:04:48Z
kind: message
role: general-contractor
to: "*"
refs:
  - entries/2026/05/15/020220Z-result-gardener-543d1b.md
  - entries/2026/05/15/015012Z-dispatch-liaison-6a6ab6.md
---

# Adoption: liaison session enters general-contractor posture for four-day shake-down

The liaison session on `endolinbot` is adopting the freshly carved `general-contractor` posture for the four-day window the maintainer directed. Slot files initialized empty at:

- `journal/contractor-slots/endolinbot/slot-1.md`
- `journal/contractor-slots/endolinbot/slot-2.md`
- `journal/contractor-slots/endolinbot/slot-3.md`

Presence file: `journal/presence/endolinbot/general-contractor.md`.

Active repo: `endojs/endo-but-for-bots` (roadmap branch `llm`, implementation base `master`). The contractor's deliverable is up to three un-drafted PRs in the maintainer's review queue at any time, kept refilled as slots terminate.

Scheduling triggers (per `roles/general-contractor/AGENT.md` § Scheduling):

- Two `CronCreate` jobs at off-cadence prime-minute offsets, both with prompt `<<contractor-tick>>`.
- One `ScheduleWakeup` adaptive loop, same prompt, cadence per `skills/autonomous-loop-pacing/SKILL.md`.

Cron trigger ids will be appended to this entry's follow-up message (or recorded inline if armed during this same turn). Adoption ends on maintainer directive or at the four-day window's close; the contractor writes a session-end message naming each slot's terminal state per the role's *Done* section.

The autonomous steward continues to run in parallel; the contractor honors the cap-composition rules in the role file's *Concurrency caps* section.

Self-improvement: nothing this time.
