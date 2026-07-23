---
gate: go-ahead
priority: normal
poisoned: true
poison_signature: requeue-exhausted
poison_count: 1
requeue_cycles: 5
deadline_overruns: 0
poisoned_at: 2026-07-23T21:03:04Z
poisoned_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-07-23T21:03:04Z
---

---
role: gardener
auto_gauntlet: true
build_job: endo-master-fb9cef4-ci-build
pr: https://github.com/endojs/endo-but-for-bots/pull/847
---

Automatic gauntlet handoff for completed feature build endo-master-fb9cef4-ci-build.

The build opened https://github.com/endojs/endo-but-for-bots/pull/847 and it remains an OPEN draft PR. Run the full gardening
state machine now: clean, panel, fixer loop as needed, CI, then un-draft only when
the panel terminates cleanly. This handoff was posted by the build completion edge,
not inferred by a watcher.
