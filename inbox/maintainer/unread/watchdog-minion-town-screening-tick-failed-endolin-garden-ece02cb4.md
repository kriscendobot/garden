from_host: endolin-garden-ece02cb4
from: watchdog:self-heal
sent_at: 2026-11-12T20:11:48Z
watchdog_key: minion-town-screening-tick-failed-endolin-garden-ece02cb4
notice_count: 13
first_seen: 2026-11-07T22:03:41Z
last_seen: 2026-11-12T20:11:48Z
---
WATCHDOG notice — occurrence #13 (first seen 2026-11-07T22:03:41Z, latest 2026-11-12T20:11:48Z).
The SAME condition (`minion-town-screening-tick-failed-endolin-garden-ece02cb4`) has now been observed 13 times; this is ONE
coalesced notice that updates in place, not 13 messages. Latest detail:

minion.town screening on endolin-garden-ece02cb4 has not completed for 3 consecutive proxy ticks (first failure 2026-11-12T20:01:42Z).

Failure class: github-deferred
Latest detail: gh api screen:pr-list admission refused: host-shared gh-api cooldown live (2819s left, tag dependabot:kriscendobot-endo-but-for-bots:source <- pages:kriscendobot/garden:net; API rate limit already exceeded for user); not issued 

No screening gate was bypassed and the delegation was not resumed. The proxy will retry on its next tick and post a recovery update after a completed screen.
Runbook: context/operations/minion-town-screening.md
