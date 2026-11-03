from_host: oros-studio-garden-ce242c49
from: watchdog:monk/3
sent_at: 2026-11-03T18:57:13Z
watchdog_key: handler-budget-overrun-oros-health-checkup-20261103-150510
notice_count: 1
first_seen: 2026-11-03T18:56:37Z
last_seen: 2026-11-03T18:57:13Z
---
gardener job 'oros-health-checkup-20261103-150510' DETERMINISTICALLY overran its handler budget (rc=137, kill-after-wall, elapsed=4176s, handler-budget=3600s, kill-grace=60s; watchdog: DEADLINE start=1793718984 term=1793722594 kill=1793722644 TERM observed=1793722595 deadline=1793722594 handler_elapsed=4176s rc=137). It does not fit in a single claim-scoped handler. An ordinary job is re-posted for deliberate orchestration decomposition immediately; a gauntlet stage is handed directly to its driver's max_stage_retries policy. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
