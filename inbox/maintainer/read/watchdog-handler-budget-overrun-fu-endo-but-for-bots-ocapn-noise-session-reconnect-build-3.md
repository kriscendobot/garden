from_host: endolin-garden-ece02cb4
from: watchdog:monk/1
sent_at: 2026-10-16T19:40:21Z
watchdog_key: handler-budget-overrun-fu-endo-but-for-bots-ocapn-noise-session-reconnect-build-3
notice_count: 1
first_seen: 2026-10-16T19:40:20Z
last_seen: 2026-10-16T19:40:21Z
---
gardener job 'fu-endo-but-for-bots-ocapn-noise-session-reconnect-build-3' DETERMINISTICALLY overran its handler budget (rc=124, term-at-wall, elapsed=2409s, handler-budget=2400s, kill-grace=60s). It does not fit in a single claim-scoped handler. An ordinary job is re-posted for deliberate orchestration decomposition immediately; a gauntlet stage is handed directly to its driver's max_stage_retries policy. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
