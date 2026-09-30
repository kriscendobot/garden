from_host: oros-studio-garden-ce242c49
from: watchdog:monk/4
sent_at: 2026-09-30T03:06:18Z
watchdog_key: handler-budget-overrun-fu-minion-town-containment-gateway-endo-sock-1-20260930-015006
notice_count: 1
first_seen: 2026-09-30T03:05:41Z
last_seen: 2026-09-30T03:06:18Z
---
gardener job 'fu-minion-town-containment-gateway-endo-sock-1-20260930-015006' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2406s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler. An ordinary job is re-posted for deliberate orchestration decomposition immediately; a gauntlet stage is handed directly to its driver's max_stage_retries policy. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
