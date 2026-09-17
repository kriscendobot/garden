from_host: endolin-garden-ece02cb4
from: watchdog:cleric/2
sent_at: 2026-09-17T05:39:51Z
watchdog_key: handler-budget-overrun-build-rbra-clean-break-20260916
notice_count: 1
first_seen: 2026-09-17T05:39:51Z
last_seen: 2026-09-17T05:39:51Z
---
gardener job 'build-rbra-clean-break-20260916' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=11032s ≈ handler-budget=10800s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle(s) without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
