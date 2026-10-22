from_host: oros-studio-garden-ce242c49
from: watchdog:monk/1
sent_at: 2026-10-22T09:20:44Z
watchdog_key: handler-budget-overrun-endojs-endo-but-for-bots-no-any-typecheck
notice_count: 1
first_seen: 2026-10-22T09:20:43Z
last_seen: 2026-10-22T09:20:44Z
---
gardener job 'endojs-endo-but-for-bots-no-any-typecheck' DETERMINISTICALLY overran its handler budget (rc=124, term-at-wall, elapsed=2466s, handler-budget=2400s, kill-grace=60s). It does not fit in a single claim-scoped handler. An ordinary job is re-posted for deliberate orchestration decomposition immediately; a gauntlet stage is handed directly to its driver's max_stage_retries policy. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
