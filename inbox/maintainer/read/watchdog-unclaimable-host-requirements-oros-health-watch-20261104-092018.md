from_host: endolin-garden-ece02cb4
from: watchdog:requirements-watch
sent_at: 2026-11-04T09:37:55Z
watchdog_key: unclaimable-host-requirements-oros-health-watch-20261104-092018
notice_count: 2
first_seen: 2026-11-04T09:37:55Z
last_seen: 2026-11-04T09:37:55Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-11-04T09:37:55Z, latest 2026-11-04T09:37:55Z).
The SAME condition (`unclaimable-host-requirements-oros-health-watch-20261104-092018`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Host-requirements gate: job 'oros-health-watch-20261104-092018' has remained unclaimed for 915s with requires: host=endolin-garden-ece02cb4. No live host has met these requirements in the dwell window (or no eligible workers are live), so this work is not silently progressing. Provision the capability/worker or revise the job requirement. Budget pacing is the likely cause, not a missing capability: pinned-host pool(s) claude-endolin1,codex-endolin are at their high-water mark, so that host declines claims until the ramp or a reset clears them.
