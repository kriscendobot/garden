from_host: endolin-garden-ece02cb4
from: watchdog:cleric/1
sent_at: 2026-09-02T04:45:00Z
watchdog_key: handler-budget-overrun-minion-town-endo-b3-daemon-deploy-verify
notice_count: 3
first_seen: 2026-08-09T18:34:06Z
last_seen: 2026-09-02T04:45:00Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-08-09T18:34:06Z, latest 2026-09-02T04:45:00Z).
The SAME condition (`handler-budget-overrun-minion-town-endo-b3-daemon-deploy-verify`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

gardener job 'minion-town-endo-b3-daemon-deploy-verify' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2419s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle(s) without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
