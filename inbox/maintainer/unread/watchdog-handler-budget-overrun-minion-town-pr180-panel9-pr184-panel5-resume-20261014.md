from_host: oros-studio-garden-ce242c49
from: watchdog:monk/4
sent_at: 2026-10-14T20:38:00Z
watchdog_key: handler-budget-overrun-minion-town-pr180-panel9-pr184-panel5-resume-20261014
notice_count: 1
first_seen: 2026-10-14T20:37:57Z
last_seen: 2026-10-14T20:38:00Z
---
gardener job 'minion-town-pr180-panel9-pr184-panel5-resume-20261014' DETERMINISTICALLY overran its handler budget (rc=124, term-at-wall, elapsed=2493s, handler-budget=2400s, kill-grace=60s). It does not fit in a single claim-scoped handler. An ordinary job is re-posted for deliberate orchestration decomposition immediately; a gauntlet stage is handed directly to its driver's max_stage_retries policy. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
