from_host: endolin-garden-ece02cb4
from: watchdog:monk/1
sent_at: 2026-08-29T18:34:29Z
watchdog_key: handler-budget-overrun-ironhorse-test262-fable-supervisor-20260829
notice_count: 1
first_seen: 2026-08-29T18:34:29Z
last_seen: 2026-08-29T18:34:29Z
---
gardener job 'ironhorse-test262-fable-supervisor-20260829' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=7230s ≈ handler-budget=7200s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle(s) without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
