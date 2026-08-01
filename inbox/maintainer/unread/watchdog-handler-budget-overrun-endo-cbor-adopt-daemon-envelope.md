from_host: endolin-garden-ece02cb4
from: watchdog:cleric/1
sent_at: 2026-08-01T06:30:47Z
watchdog_key: handler-budget-overrun-endo-cbor-adopt-daemon-envelope
notice_count: 3
first_seen: 2026-07-29T02:29:11Z
last_seen: 2026-08-01T06:30:47Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-07-29T02:29:11Z, latest 2026-08-01T06:30:47Z).
The SAME condition (`handler-budget-overrun-endo-cbor-adopt-daemon-envelope`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

gardener job 'endo-cbor-adopt-daemon-envelope' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2402s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
