from_host: endolin-garden-ece02cb4
from: watchdog:cleric/2
sent_at: 2026-09-17T07:46:53Z
watchdog_key: handler-budget-overrun-endojs-endo-but-for-bots-pr1125-review-b786506c
notice_count: 1
first_seen: 2026-09-17T07:46:53Z
last_seen: 2026-09-17T07:46:53Z
---
gardener job 'endojs-endo-but-for-bots-pr1125-review-b786506c' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=7223s ≈ handler-budget=7200s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle(s) without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
