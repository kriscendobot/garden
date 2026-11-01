from_host: endolin-garden-ece02cb4
from: watchdog:monk/2
sent_at: 2026-11-01T13:21:03Z
watchdog_key: handler-budget-overrun-ironhorse-test262-ratchet-coverage-crank-tenth-slice-20261101
notice_count: 1
first_seen: 2026-11-01T13:21:02Z
last_seen: 2026-11-01T13:21:03Z
---
gardener job 'ironhorse-test262-ratchet-coverage-crank-tenth-slice-20261101' DETERMINISTICALLY overran its handler budget (rc=124, term-at-wall, elapsed=7202s, handler-budget=7200s, kill-grace=60s). It does not fit in a single claim-scoped handler. An ordinary job is re-posted for deliberate orchestration decomposition immediately; a gauntlet stage is handed directly to its driver's max_stage_retries policy. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
