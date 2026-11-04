from_host: oros-studio-garden-ce242c49
from: watchdog:monk/3
sent_at: 2026-11-04T03:40:16Z
watchdog_key: handler-budget-overrun-build-minion-town-tool-removal-20261104
notice_count: 1
first_seen: 2026-11-04T03:40:15Z
last_seen: 2026-11-04T03:40:16Z
---
gardener job 'build-minion-town-tool-removal-20261104' DETERMINISTICALLY overran its handler budget (rc=124, term-at-wall, elapsed=2401s, handler-budget=2400s, kill-grace=60s). It does not fit in a single claim-scoped handler. An ordinary job is re-posted for deliberate orchestration decomposition immediately; a gauntlet stage is handed directly to its driver's max_stage_retries policy. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
