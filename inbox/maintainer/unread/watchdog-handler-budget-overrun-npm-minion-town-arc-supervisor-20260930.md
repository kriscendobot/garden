from_host: endolin-garden-ece02cb4
from: watchdog:monk/1
sent_at: 2026-09-30T04:22:52Z
watchdog_key: handler-budget-overrun-npm-minion-town-arc-supervisor-20260930
notice_count: 1
first_seen: 2026-09-30T04:22:52Z
last_seen: 2026-09-30T04:22:52Z
---
gardener job 'npm-minion-town-arc-supervisor-20260930' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2407s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler. An ordinary job is re-posted for deliberate orchestration decomposition immediately; a gauntlet stage is handed directly to its driver's max_stage_retries policy. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
