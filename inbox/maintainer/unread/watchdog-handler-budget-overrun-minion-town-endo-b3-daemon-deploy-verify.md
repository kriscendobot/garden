from_host: endolin-garden-ece02cb4
from: watchdog:cleric/1
sent_at: 2026-09-02T01:16:26Z
watchdog_key: handler-budget-overrun-minion-town-endo-b3-daemon-deploy-verify
notice_count: 2
first_seen: 2026-08-09T18:34:06Z
last_seen: 2026-09-02T01:16:26Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-08-09T18:34:06Z, latest 2026-09-02T01:16:26Z).
The SAME condition (`handler-budget-overrun-minion-town-endo-b3-daemon-deploy-verify`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

gardener job 'minion-town-endo-b3-daemon-deploy-verify' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2411s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle(s) without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
