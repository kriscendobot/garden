from_host: endolin-garden2-5bcdff64
from: watchdog:cleric/2
sent_at: 2026-08-28T18:40:12Z
watchdog_key: handler-budget-overrun-endojs-endo-but-for-bots-pr1038-fix-20260828
notice_count: 1
first_seen: 2026-08-28T18:40:12Z
last_seen: 2026-08-28T18:40:12Z
---
gardener job 'endojs-endo-but-for-bots-pr1038-fix-20260828' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2410s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle(s) without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
