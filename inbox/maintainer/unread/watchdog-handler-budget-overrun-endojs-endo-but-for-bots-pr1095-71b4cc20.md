from_host: endolin-garden-ece02cb4
from: watchdog:cleric/3
sent_at: 2026-08-31T04:55:15Z
watchdog_key: handler-budget-overrun-endojs-endo-but-for-bots-pr1095-71b4cc20
notice_count: 1
first_seen: 2026-08-31T04:55:15Z
last_seen: 2026-08-31T04:55:15Z
---
gardener job 'endojs-endo-but-for-bots-pr1095-71b4cc20' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2423s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle(s) without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
