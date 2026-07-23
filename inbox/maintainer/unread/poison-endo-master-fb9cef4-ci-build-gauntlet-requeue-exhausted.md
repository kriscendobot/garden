from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-23T21:03:08Z
poison_base: endo-master-fb9cef4-ci-build-gauntlet
poison_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-07-23T21:03:08Z
last_seen: 2026-07-23T21:03:08Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/endo-master-fb9cef4-ci-build-gauntlet; it stays HELD until a human promotes it
(promote-plan.sh endo-master-fb9cef4-ci-build-gauntlet) or removes it, so nothing is lost.
Original job base: endo-master-fb9cef4-ci-build-gauntlet

--- original job body ---
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
