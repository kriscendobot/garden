from_host: endolin-garden2-5bcdff64
from: watchdog:cleric/3
sent_at: 2026-08-09T21:33:45Z
watchdog_key: handler-budget-overrun-minion-town-weblet-powers-reference-build-20260809
notice_count: 1
first_seen: 2026-08-09T21:33:45Z
last_seen: 2026-08-09T21:33:45Z
---
gardener job 'minion-town-weblet-powers-reference-build-20260809' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=7202s ≈ handler-budget=7200s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
