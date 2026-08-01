from_host: endolin-garden-ece02cb4
from: watchdog:cleric/1
sent_at: 2026-08-01T07:11:47Z
watchdog_key: handler-budget-overrun-ebfb-llm-lint-warnings
notice_count: 2
first_seen: 2026-07-30T00:13:53Z
last_seen: 2026-08-01T07:11:47Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-07-30T00:13:53Z, latest 2026-08-01T07:11:47Z).
The SAME condition (`handler-budget-overrun-ebfb-llm-lint-warnings`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

gardener job 'ebfb-llm-lint-warnings' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2412s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
