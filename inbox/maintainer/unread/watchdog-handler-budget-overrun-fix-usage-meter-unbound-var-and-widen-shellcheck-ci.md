from_host: endolin-garden2-5bcdff64
from: watchdog:gardener/1
sent_at: 2026-08-23T17:34:11Z
watchdog_key: handler-budget-overrun-fix-usage-meter-unbound-var-and-widen-shellcheck-ci
notice_count: 1
first_seen: 2026-08-23T17:34:11Z
last_seen: 2026-08-23T17:34:11Z
---
gardener job 'fix-usage-meter-unbound-var-and-widen-shellcheck-ci' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2403s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle(s) without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
