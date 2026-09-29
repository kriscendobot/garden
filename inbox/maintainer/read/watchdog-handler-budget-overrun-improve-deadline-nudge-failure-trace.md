from_host: oros-studio-garden-ce242c49
from: watchdog:monk/2
sent_at: 2026-09-29T23:34:01Z
watchdog_key: handler-budget-overrun-improve-deadline-nudge-failure-trace
notice_count: 1
first_seen: 2026-09-29T23:34:01Z
last_seen: 2026-09-29T23:34:01Z
---
gardener job 'improve-deadline-nudge-failure-trace' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2412s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler. An ordinary job is re-posted for deliberate orchestration decomposition immediately; a gauntlet stage is handed directly to its driver's max_stage_retries policy. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
