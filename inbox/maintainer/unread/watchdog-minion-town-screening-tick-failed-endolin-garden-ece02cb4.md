from_host: endolin-garden-ece02cb4
from: watchdog:self-heal
sent_at: 2026-11-13T05:53:05Z
watchdog_key: minion-town-screening-tick-failed-endolin-garden-ece02cb4
notice_count: 1
first_seen: 2026-11-13T05:53:04Z
last_seen: 2026-11-13T05:53:05Z
---
minion.town screening on endolin-garden-ece02cb4 has not completed for 3 consecutive proxy ticks (first failure 2026-11-13T05:42:58Z).

Failure class: github-deferred
Latest detail: gh api screen:pr-list admission refused: host-shared gh-api cooldown live (2797s left, tag dependabot:kriscendobot-garden:source <- pages:kriscendobot/garden:net; API rate limit already exceeded for user); not issued 

No screening gate was bypassed and the delegation was not resumed. The proxy will retry on its next tick and post a recovery update after a completed screen.
Runbook: context/operations/minion-town-screening.md
