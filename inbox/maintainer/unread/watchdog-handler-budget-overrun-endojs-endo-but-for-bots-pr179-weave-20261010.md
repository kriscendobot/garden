from_host: endolin-garden-ece02cb4
from: watchdog:monk/2
sent_at: 2026-10-10T08:39:03Z
watchdog_key: handler-budget-overrun-endojs-endo-but-for-bots-pr179-weave-20261010
notice_count: 2
first_seen: 2026-10-10T06:44:24Z
last_seen: 2026-10-10T08:39:03Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-10T06:44:24Z, latest 2026-10-10T08:39:03Z).
The SAME condition (`handler-budget-overrun-endojs-endo-but-for-bots-pr179-weave-20261010`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

gardener job 'endojs-endo-but-for-bots-pr179-weave-20261010' DETERMINISTICALLY overran its handler budget (rc=124, term-at-wall, elapsed=2408s, handler-budget=2400s, kill-grace=60s). It does not fit in a single claim-scoped handler. An ordinary job is re-posted for deliberate orchestration decomposition immediately; a gauntlet stage is handed directly to its driver's max_stage_retries policy. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
