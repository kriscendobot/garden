from_host: endolin-garden-ece02cb4
from: watchdog:requirements-watch
sent_at: 2026-11-04T06:12:05Z
watchdog_key: unclaimable-host-requirements-diag-issue-inbox-gap-20261104-endolin
notice_count: 1
first_seen: 2026-11-04T06:12:05Z
last_seen: 2026-11-04T06:12:05Z
---
Host-requirements gate: job 'diag-issue-inbox-gap-20261104-endolin' has remained unclaimed for 1196s with requires: host=endolin-garden-ece02cb4. No live host has met these requirements in the dwell window (or no eligible workers are live), so this work is not silently progressing. Provision the capability/worker or revise the job requirement. Budget pacing is the likely cause, not a missing capability: pinned-host pool(s) claude-endolin1,codex-endolin are at their high-water mark, so that host declines claims until the ramp or a reset clears them.
