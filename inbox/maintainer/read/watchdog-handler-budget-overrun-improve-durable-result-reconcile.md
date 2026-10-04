from_host: endolin-garden2-5bcdff64
from: watchdog:monk/1
sent_at: 2026-10-04T06:32:57Z
watchdog_key: handler-budget-overrun-improve-durable-result-reconcile
notice_count: 1
first_seen: 2026-10-04T06:32:56Z
last_seen: 2026-10-04T06:32:57Z
---
gardener job 'improve-durable-result-reconcile' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2407s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler. An ordinary job is re-posted for deliberate orchestration decomposition immediately; a gauntlet stage is handed directly to its driver's max_stage_retries policy. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
