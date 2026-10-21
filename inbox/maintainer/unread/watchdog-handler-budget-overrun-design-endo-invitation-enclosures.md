from_host: endolin-garden-ece02cb4
from: watchdog:cleric/1
sent_at: 2026-10-21T05:13:41Z
watchdog_key: handler-budget-overrun-design-endo-invitation-enclosures
notice_count: 1
first_seen: 2026-10-21T05:13:41Z
last_seen: 2026-10-21T05:13:41Z
---
gardener job 'design-endo-invitation-enclosures' DETERMINISTICALLY overran its handler budget (rc=124, term-at-wall, elapsed=2409s, handler-budget=2400s, kill-grace=60s). It does not fit in a single claim-scoped handler. An ordinary job is re-posted for deliberate orchestration decomposition immediately; a gauntlet stage is handed directly to its driver's max_stage_retries policy. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
