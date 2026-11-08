from_host: endolin-garden-ece02cb4
from: watchdog:self-heal
sent_at: 2026-11-08T12:30:40Z
watchdog_key: minion-town-screening-tick-failed-endolin-garden-ece02cb4
notice_count: 11
first_seen: 2026-11-07T22:03:41Z
last_seen: 2026-11-08T12:30:40Z
---
WATCHDOG notice — occurrence #11 (first seen 2026-11-07T22:03:41Z, latest 2026-11-08T12:30:40Z).
The SAME condition (`minion-town-screening-tick-failed-endolin-garden-ece02cb4`) has now been observed 11 times; this is ONE
coalesced notice that updates in place, not 11 messages. Latest detail:

minion.town screening on endolin-garden-ece02cb4 has not completed for 3 consecutive proxy ticks (first failure 2026-11-08T12:20:34Z).

Failure class: github-deferred
Latest detail: gh api screen:pr-list admission refused: host-shared gh-api cooldown live (2988s left, tag dependabot:kriscendobot-ocapn:source <- pages:kriscendobot/garden:net; API rate limit already exceeded for user); not issued 

No screening gate was bypassed and the delegation was not resumed. The proxy will retry on its next tick and post a recovery update after a completed screen.
Runbook: context/operations/minion-town-screening.md
