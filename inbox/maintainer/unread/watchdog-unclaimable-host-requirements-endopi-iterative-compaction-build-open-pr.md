from_host: endolin-garden-ece02cb4
from: watchdog:requirements-watch
sent_at: 2026-11-03T03:52:04Z
watchdog_key: unclaimable-host-requirements-endopi-iterative-compaction-build-open-pr
notice_count: 1
first_seen: 2026-11-03T03:52:04Z
last_seen: 2026-11-03T03:52:04Z
---
Host-requirements gate: job 'endopi-iterative-compaction-build-open-pr' has remained unclaimed for 1200s with requires: host=endolin-garden-ece02cb4. No live host has met these requirements in the dwell window (or no eligible workers are live), so this work is not silently progressing. Provision the capability/worker or revise the job requirement. Budget pacing is the likely cause, not a missing capability: pinned-host pool(s) claude-endolin1,codex-endolin are at their high-water mark, so that host declines claims until the ramp or a reset clears them.
