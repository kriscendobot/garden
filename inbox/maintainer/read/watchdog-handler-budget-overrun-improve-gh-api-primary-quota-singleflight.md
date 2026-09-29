from_host: oros-studio-garden-ce242c49
from: watchdog:monk/1
sent_at: 2026-09-29T20:54:01Z
watchdog_key: handler-budget-overrun-improve-gh-api-primary-quota-singleflight
notice_count: 1
first_seen: 2026-09-29T20:53:07Z
last_seen: 2026-09-29T20:54:01Z
---
gardener job 'improve-gh-api-primary-quota-singleflight' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2405s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler. An ordinary job is re-posted for deliberate orchestration decomposition immediately; a gauntlet stage is handed directly to its driver's max_stage_retries policy. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
