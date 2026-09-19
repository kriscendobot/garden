from_host: endolin-garden2-5bcdff64
from: watchdog:monk/2
sent_at: 2026-09-19T00:54:32Z
watchdog_key: handler-budget-overrun-endojs-endo-but-for-bots-pr1301-gauntlet-20260918-clean
notice_count: 1
first_seen: 2026-09-19T00:54:31Z
last_seen: 2026-09-19T00:54:32Z
---
gardener job 'endojs-endo-but-for-bots-pr1301-gauntlet-20260918-clean' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=7655s ≈ handler-budget=7200s). It does not fit in a single claim-scoped handler. An ordinary job is re-posted for deliberate orchestration decomposition immediately; a gauntlet stage is handed directly to its driver's max_stage_retries policy. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
