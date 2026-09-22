from_host: endolin-garden-ece02cb4
from: watchdog:cleric/1
sent_at: 2026-09-22T01:37:42Z
watchdog_key: handler-budget-overrun-merge-endojs-endo-but-for-bots-pr1317-20260921
notice_count: 1
first_seen: 2026-09-22T01:37:28Z
last_seen: 2026-09-22T01:37:42Z
---
gardener job 'merge-endojs-endo-but-for-bots-pr1317-20260921' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2402s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler. An ordinary job is re-posted for deliberate orchestration decomposition immediately; a gauntlet stage is handed directly to its driver's max_stage_retries policy. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
