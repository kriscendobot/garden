from_host: endolin-garden-ece02cb4
from: watchdog:claim/1
sent_at: 2026-11-14T10:36:49Z
watchdog_key: project-pause-active-minion-town
notice_count: 24393
first_seen: 2026-11-10T19:35:37Z
last_seen: 2026-11-14T10:36:49Z
---
WATCHDOG notice — occurrence #24393 (first seen 2026-11-10T19:35:37Z, latest 2026-11-14T10:36:49Z).
The SAME condition (`project-pause-active-minion-town`) has now been observed 24393 times; this is ONE
coalesced notice that updates in place, not 24393 messages. Latest detail:

PROJECT PAUSE enforced on endolin-garden-ece02cb4: refused a claimable todo job 'scholar-ingest-fudco-gist-20261105' on the board because project 'minion-town' is PAUSED (paused by kriskowal, liaison session, 2026-11-10: 'Please pause development on minion.town.').
This means work for a PAUSED project reached a chokepoint — most likely a host running
a garden OLDER than the pause directive is still producing it (the 2026-09-16/17
IronHorse-fuzz-storm shape). The chokepoints refuse it, but the fact that it was
attempted is worth seeing: check whether a host is stale and needs to deploy.
Paused scope: all minion.town development: builds, designs, fixes, presses, gauntlets, deploys, and jobs posted by the screener or CI watcher
To LIFT the pause (the only authorized way to run this work again), delete the journal
record: scripts/jobs/pause-project.sh minion-town off — and update roles/COMMON.md § Project
scope to match. This notice is COALESCED per project: one entry, a rising count, not
one message per refused job.
