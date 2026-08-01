from_host: endolin-garden-ece02cb4
from: watchdog:gardener/4
sent_at: 2026-08-01T11:14:34Z
watchdog_key: handler-budget-overrun-minion-town-mcp-b2-first-guest-tools-gauntlet
notice_count: 1
first_seen: 2026-08-01T11:14:30Z
last_seen: 2026-08-01T11:14:34Z
---
gardener job 'minion-town-mcp-b2-first-guest-tools-gauntlet' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2401s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
