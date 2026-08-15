from_host: endolin-garden-ece02cb4
from: watchdog:gardener/1
sent_at: 2026-08-15T04:31:07Z
watchdog_key: handler-budget-overrun-ironhorse-js-26-ci-iterator-set-map
notice_count: 1
first_seen: 2026-08-15T04:30:12Z
last_seen: 2026-08-15T04:31:07Z
---
gardener job 'ironhorse-js-26-ci-iterator-set-map' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2407s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle(s) without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
