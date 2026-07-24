from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-22T20:59:10Z
poison_base: minion-town-mcp-b2-first-guest-tools-gauntlet
poison_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-07-22T20:59:10Z
last_seen: 2026-07-22T20:59:10Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/minion-town-mcp-b2-first-guest-tools-gauntlet; it stays HELD until a human promotes it
(promote-plan.sh minion-town-mcp-b2-first-guest-tools-gauntlet) or removes it, so nothing is lost.
Original job base: minion-town-mcp-b2-first-guest-tools-gauntlet

--- original job body ---
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
