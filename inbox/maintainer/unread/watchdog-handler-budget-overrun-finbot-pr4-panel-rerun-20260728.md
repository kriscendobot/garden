from_host: endolin-garden2-5bcdff64
from: watchdog:cleric/1
sent_at: 2026-07-29T13:12:17Z
watchdog_key: handler-budget-overrun-finbot-pr4-panel-rerun-20260728
notice_count: 1
first_seen: 2026-07-29T13:12:15Z
last_seen: 2026-07-29T13:12:17Z
---
gardener job 'finbot-pr4-panel-rerun-20260728' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2413s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
