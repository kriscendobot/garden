---
gate: go-ahead
priority: normal
poisoned: true
poison_signature: deadline-overrun
poison_count: 1
requeue_cycles: 1
deadline_overruns: 1
poisoned_at: 2026-07-26T23:03:04Z
poisoned_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-07-26T23:03:04Z
---

---
role: gardener
auto_gauntlet: true
build_job: endo-sturdyref-agent-surface-build
pr: https://github.com/endojs/endo-but-for-bots/pull/871
---

Automatic gauntlet handoff for completed feature build endo-sturdyref-agent-surface-build.

The build opened https://github.com/endojs/endo-but-for-bots/pull/871 and it remains an OPEN draft PR. Run the full gardening
state machine now: clean, panel, fixer loop as needed, CI, then un-draft only when
the panel terminates cleanly. This handoff was posted by the build completion edge,
not inferred by a watcher.

<!-- garden-deadline-overrun: 1 -->
