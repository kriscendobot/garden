from_host: endolin-garden-ece02cb4
from: watchdog:requirements-watch
sent_at: 2026-11-03T12:07:12Z
watchdog_key: unclaimable-host-requirements-oros-health-watch-20261103-115009
notice_count: 1
first_seen: 2026-11-03T12:07:11Z
last_seen: 2026-11-03T12:07:12Z
---
Host-requirements gate: job 'oros-health-watch-20261103-115009' has remained unclaimed for 900s with requires: host=endolin-garden-ece02cb4. No live host has met these requirements in the dwell window (or no eligible workers are live), so this work is not silently progressing. Provision the capability/worker or revise the job requirement. Budget pacing is the likely cause, not a missing capability: pinned-host pool(s) claude-endolin1,codex-endolin are at their high-water mark, so that host declines claims until the ramp or a reset clears them.
