from_host: endolin-garden2-5bcdff64
from: watchdog:gardener/6
sent_at: 2026-07-28T21:34:23Z
watchdog_key: handler-budget-overrun-endojs-endo-but-for-bots-pr848-panel-fixes
notice_count: 1
first_seen: 2026-07-28T21:34:23Z
last_seen: 2026-07-28T21:34:23Z
---
gardener job 'endojs-endo-but-for-bots-pr848-panel-fixes' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2411s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
