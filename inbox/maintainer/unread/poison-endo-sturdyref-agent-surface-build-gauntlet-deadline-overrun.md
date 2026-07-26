from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-07-26T23:03:08Z
poison_base: endo-sturdyref-agent-surface-build-gauntlet
poison_signature: deadline-overrun
notice_count: 1
first_seen: 2026-07-26T23:03:08Z
last_seen: 2026-07-26T23:03:08Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden-ece02cb4.
Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
The work is preserved at jobs/plan/endo-sturdyref-agent-surface-build-gauntlet; it stays HELD until a human promotes it
(promote-plan.sh endo-sturdyref-agent-surface-build-gauntlet) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
for this work, or fix what makes it run long.
Original job base: endo-sturdyref-agent-surface-build-gauntlet

--- original job body ---
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
