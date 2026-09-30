from_host: endolin-garden-ece02cb4
from: watchdog:claim/3
sent_at: 2026-09-30T15:08:09Z
watchdog_key: budget-pool-refuse-claude-endolin1
notice_count: 2195
first_seen: 2026-09-30T11:07:45Z
last_seen: 2026-09-30T15:08:09Z
---
WATCHDOG notice — occurrence #2195 (first seen 2026-09-30T11:07:45Z, latest 2026-09-30T15:08:09Z).
The SAME condition (`budget-pool-refuse-claude-endolin1`) has now been observed 2195 times; this is ONE
coalesced notice that updates in place, not 2195 messages. Latest detail:

claim gate is FAIL-CLOSED on endolin-garden-ece02cb4: budget pool claude-endolin1 cap is UNCALIBRATED (provenance placeholder); promote a calibrated cap to admit: set-budget-pool.sh claude-endolin1 <weekly-token-cap> <calibrated-from>. No job will be claimed on this host until a calibrated cap is set.
