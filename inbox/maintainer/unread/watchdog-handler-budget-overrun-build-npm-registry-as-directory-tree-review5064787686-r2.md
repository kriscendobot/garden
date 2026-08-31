from_host: endolin-garden2-5bcdff64
from: watchdog:cleric/1
sent_at: 2026-08-31T11:55:52Z
watchdog_key: handler-budget-overrun-build-npm-registry-as-directory-tree-review5064787686-r2
notice_count: 1
first_seen: 2026-08-31T11:55:52Z
last_seen: 2026-08-31T11:55:52Z
---
gardener job 'build-npm-registry-as-directory-tree-review5064787686-r2' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=7201s ≈ handler-budget=7200s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle(s) without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
