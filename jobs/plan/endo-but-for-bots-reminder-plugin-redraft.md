---
gate: go-ahead
priority: normal
posted_by: designer
posted_at: 2026-07-12T20:16:29Z
---

---
role: designer
---

Redraft the endoclaw-timer mechanism as a NEW unconfined plugin `@endo/reminder`,
per kriskowal's CHANGES_REQUESTED review on endojs/endo-but-for-bots#609
(2026-07-10). This supersedes the daemon-formula approach of #609 and forces
Phase 2 (endojs/endo-but-for-bots#617, daemon mail tick delivery) and Phase 3
(endojs/endo-but-for-bots#619, daemon startup recovery) to be reworked or closed —
they are built ON the daemon integration kriskowal is asking to remove.

kriskowal's asks, verbatim intent:
1. Name/document the mechanism clearly as a "message scheduler" — it is NOT a
   generalized scheduler; it produces messages on various schedules.
2. Push persistence down to the platform. The current filePowers/file-system
   coupling is "undue"; durable state could be a database or a VIRTUAL FILE
   SYSTEM (vfs), not node fs.
3. OPERATIVE: "this particular feature does not particularly benefit from deep
   integration into the daemon and could be an unconfined PLUGIN... Please redraft
   this change as a new plugin `@endo/reminder`." The wake-on-restart / live-
   reference narrative (retaining a live ref so it re-arms on daemon restart, akin
   to `@pins`) should be handled out-of-band by a particular integration (the
   Familiar app or online Gateway), with LESS coupling to the lowest parts.

Design pass should produce: the `@endo/reminder` package shape (unconfined
plugin), the vfs-backed durable persistence seam, the `@pins`-style liveness/
retention narrative and which integration owns it, and a migration plan for the
already-built Phase 1/2/3 logic (interval-scheduler.js + tests) — start-to-start
ticks, resolve/reschedule with backoff, tick-timeout auto-resolve, host limits,
pause/resume/revoke, startup recovery with missed-tick coalescing all carry over
in substance. Then decompose into builder PR(s) and reconcile #609/#617/#619.

Context: prior fixer job 'endojs-endo-but-for-bots-pr609-message-scheduler-review-fixups'
was scoped as a mere rename; that scope could not clear the review (a rename
neither matches the requested `@endo/reminder` name nor removes the daemon
coupling) and would churn the formula-type wire identifier that #617/#619 share.
It escalated this decision to the maintainer inbox (20260712T200620Z-92c4b0) and
parked this plan job. Promote it to run path B; if instead only the incremental
naming/doc clarification is wanted, re-post a small fixer job instead.
