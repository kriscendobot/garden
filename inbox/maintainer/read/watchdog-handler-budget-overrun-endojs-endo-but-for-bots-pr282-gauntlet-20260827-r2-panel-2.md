from_host: endolin-garden2-5bcdff64
from: watchdog:cleric/2
sent_at: 2026-08-28T00:47:45Z
watchdog_key: handler-budget-overrun-endojs-endo-but-for-bots-pr282-gauntlet-20260827-r2-panel-2
notice_count: 1
first_seen: 2026-08-28T00:47:45Z
last_seen: 2026-08-28T00:47:45Z
---
gardener job 'endojs-endo-but-for-bots-pr282-gauntlet-20260827-r2-panel-2' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=7365s ≈ handler-budget=7200s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle(s) without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
