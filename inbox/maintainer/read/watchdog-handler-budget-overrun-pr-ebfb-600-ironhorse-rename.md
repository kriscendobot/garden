from_host: endolin-garden2-5bcdff64
from: watchdog:mystic/1
sent_at: 2026-07-29T23:22:09Z
watchdog_key: handler-budget-overrun-pr-ebfb-600-ironhorse-rename
notice_count: 1
first_seen: 2026-07-29T23:22:09Z
last_seen: 2026-07-29T23:22:09Z
---
gardener job 'pr-ebfb-600-ironhorse-rename' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2401s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
