from_host: endolin-garden-ece02cb4
from: watchdog:self-heal
sent_at: 2026-11-10T02:39:09Z
watchdog_key: minion-town-screening-tick-failed-endolin-garden-ece02cb4
notice_count: 12
first_seen: 2026-11-07T22:03:41Z
last_seen: 2026-11-10T02:39:09Z
---
WATCHDOG notice — occurrence #12 (first seen 2026-11-07T22:03:41Z, latest 2026-11-10T02:39:09Z).
The SAME condition (`minion-town-screening-tick-failed-endolin-garden-ece02cb4`) has now been observed 12 times; this is ONE
coalesced notice that updates in place, not 12 messages. Latest detail:

minion.town screening on endolin-garden-ece02cb4 has not completed for 3 consecutive proxy ticks (first failure 2026-11-10T02:29:02Z).

Failure class: github-deferred
Latest detail: gh api screen:pr-list admission refused: host-shared gh-api cooldown live (2808s left, tag receipt:kriscendobot-moddable:PR source:primary-quota <- pages:kriscendobot/garden:net; API rate limit already exceeded for user); not issued 

No screening gate was bypassed and the delegation was not resumed. The proxy will retry on its next tick and post a recovery update after a completed screen.
Runbook: context/operations/minion-town-screening.md
