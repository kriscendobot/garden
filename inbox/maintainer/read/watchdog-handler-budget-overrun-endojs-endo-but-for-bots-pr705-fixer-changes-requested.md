from_host: endolin-garden-ece02cb4
from: watchdog:gardener/2
sent_at: 2026-07-28T23:03:35Z
watchdog_key: handler-budget-overrun-endojs-endo-but-for-bots-pr705-fixer-changes-requested
notice_count: 1
first_seen: 2026-07-28T23:03:35Z
last_seen: 2026-07-28T23:03:35Z
---
gardener job 'endojs-endo-but-for-bots-pr705-fixer-changes-requested' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2406s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
