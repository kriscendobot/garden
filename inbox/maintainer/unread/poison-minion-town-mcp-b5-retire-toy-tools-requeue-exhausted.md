from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-23T00:43:10Z
poison_base: minion-town-mcp-b5-retire-toy-tools
poison_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-07-23T00:43:10Z
last_seen: 2026-07-23T00:43:10Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/minion-town-mcp-b5-retire-toy-tools; it stays HELD until a human promotes it
(promote-plan.sh minion-town-mcp-b5-retire-toy-tools) or removes it, so nothing is lost.
Original job base: minion-town-mcp-b5-retire-toy-tools

--- original job body ---
---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-07-22T22:31:03Z -->

# B5: retire toy tools

Repository: kriscendobot/minion.town.

After B4, implement B5 from designs/mcp-daemon-guest-tools.md §7. Delete minion_status, list_minions, summon_minion, their in-memory Map, and their scope rows. Stop advertising mcp/minions:*; rewrite the server.ts toy header for facet-backed guest tools; update README and DEPLOYMENT.md phase rows; clean Cognito scope configuration. Guest tools now mount unconditionally, returning clean daemon-unavailable errors when the socket is absent.

Validation required at deployed edge: a fresh tools/list has only guest_* tools, then rerun full E1-E4 sweep green. Report concrete command/run evidence.
