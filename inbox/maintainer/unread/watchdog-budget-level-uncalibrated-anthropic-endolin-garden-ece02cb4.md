from_host: endolin-garden2-5bcdff64
from: watchdog:budget-level
sent_at: 2026-09-04T10:35:10Z
watchdog_key: budget-level-uncalibrated-anthropic:endolin-garden-ece02cb4
notice_count: 40
first_seen: 2026-09-04T00:20:48Z
last_seen: 2026-09-04T10:35:10Z
---
WATCHDOG notice — occurrence #40 (first seen 2026-09-04T00:20:48Z, latest 2026-09-04T10:35:10Z).
The SAME condition (`budget-level-uncalibrated-anthropic:endolin-garden-ece02cb4`) has now been observed 40 times; this is ONE
coalesced notice that updates in place, not 40 messages. Latest detail:

budget-level: pool anthropic:endolin-garden-ece02cb4 cap=595000000 is UNCALIBRATED (provenance='none'); NOT leveling workers against a setpoint the config disclaims. Calibrate it (weekly-capacity-calibration.sh or Claude Code /usage) and set the provenance columns on config/budget-pools (calibrated-from date).
