from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-01T11:23:09Z
poison_base: minion-town-mcp-b2-first-guest-tools-gauntlet
poison_signature: deadline-overrun
notice_count: 1
first_seen: 2026-08-01T11:23:09Z
last_seen: 2026-08-01T11:23:09Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
The work is preserved at jobs/plan/minion-town-mcp-b2-first-guest-tools-gauntlet; it stays HELD until a human promotes it
(promote-plan.sh minion-town-mcp-b2-first-guest-tools-gauntlet) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
for this work, or fix what makes it run long.
Original job base: minion-town-mcp-b2-first-guest-tools-gauntlet

--- original job body ---
---
role: gardener
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-01T09:01:50Z cleared=none -->

---
role: gardener
auto_gauntlet: true
build_job: minion-town-mcp-b2-first-guest-tools
pr: https://github.com/kriscendobot/minion.town/pull/17
---

Automatic gauntlet handoff for completed feature build minion-town-mcp-b2-first-guest-tools.

The build opened https://github.com/kriscendobot/minion.town/pull/17 and it remains an OPEN draft PR. Run the full gardening
state machine now: clean, panel, fixer loop as needed, CI, then un-draft only when
the panel terminates cleanly. This handoff was posted by the build completion edge,
not inferred by a watcher.

<!-- garden-deadline-overrun: 1 -->
