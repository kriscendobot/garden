from_host: endolin-garden2-5bcdff64
from: watchdog:gardener/2
sent_at: 2026-07-28T22:04:11Z
watchdog_key: handler-budget-overrun-endojs-endo-but-for-bots-form-data-advisory
notice_count: 1
first_seen: 2026-07-28T22:04:11Z
last_seen: 2026-07-28T22:04:11Z
---
gardener job 'endojs-endo-but-for-bots-form-data-advisory' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2406s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
