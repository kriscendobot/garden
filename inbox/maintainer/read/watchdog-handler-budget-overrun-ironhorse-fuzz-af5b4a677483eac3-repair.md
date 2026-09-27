from_host: endolin-garden2-5bcdff64
from: watchdog:cleric/1
sent_at: 2026-09-27T13:59:21Z
watchdog_key: handler-budget-overrun-ironhorse-fuzz-af5b4a677483eac3-repair
notice_count: 1
first_seen: 2026-09-27T13:59:21Z
last_seen: 2026-09-27T13:59:21Z
---
gardener job 'ironhorse-fuzz-af5b4a677483eac3-repair' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=7210s ≈ handler-budget=7200s). It does not fit in a single claim-scoped handler. An ordinary job is re-posted for deliberate orchestration decomposition immediately; a gauntlet stage is handed directly to its driver's max_stage_retries policy. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
