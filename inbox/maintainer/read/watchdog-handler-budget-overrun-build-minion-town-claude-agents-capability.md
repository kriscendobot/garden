from_host: endolin-garden-ece02cb4
from: watchdog:monk/2
sent_at: 2026-09-03T22:32:37Z
watchdog_key: handler-budget-overrun-build-minion-town-claude-agents-capability
notice_count: 1
first_seen: 2026-09-03T22:32:37Z
last_seen: 2026-09-03T22:32:37Z
---
gardener job 'build-minion-town-claude-agents-capability' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2402s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle(s) without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
