from_host: oros-studio-garden-ce242c49
from: watchdog:monk/1
sent_at: 2026-10-17T14:41:00Z
watchdog_key: handler-budget-overrun-fu-kriscendobot-minion.town-pr201-gauntlet-fix-1-1
notice_count: 1
first_seen: 2026-10-17T14:41:00Z
last_seen: 2026-10-17T14:41:00Z
---
gardener job 'fu-kriscendobot-minion.town-pr201-gauntlet-fix-1-1' DETERMINISTICALLY overran its handler budget (rc=124, term-at-wall, elapsed=2415s, handler-budget=2400s, kill-grace=60s). It does not fit in a single claim-scoped handler. An ordinary job is re-posted for deliberate orchestration decomposition immediately; a gauntlet stage is handed directly to its driver's max_stage_retries policy. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
