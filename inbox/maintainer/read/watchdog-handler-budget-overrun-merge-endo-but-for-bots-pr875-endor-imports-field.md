from_host: endolin-garden-ece02cb4
from: watchdog:cleric/1
sent_at: 2026-08-06T07:24:13Z
watchdog_key: handler-budget-overrun-merge-endo-but-for-bots-pr875-endor-imports-field
notice_count: 1
first_seen: 2026-08-06T07:24:13Z
last_seen: 2026-08-06T07:24:13Z
---
gardener job 'merge-endo-but-for-bots-pr875-endor-imports-field' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2401s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
