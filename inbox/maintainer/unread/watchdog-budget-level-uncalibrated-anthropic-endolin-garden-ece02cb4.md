from_host: endolin-garden2-5bcdff64
from: watchdog:budget-level
sent_at: 2026-09-04T07:20:07Z
watchdog_key: budget-level-uncalibrated-anthropic:endolin-garden-ece02cb4
notice_count: 27
first_seen: 2026-09-04T00:20:48Z
last_seen: 2026-09-04T07:20:07Z
---
WATCHDOG notice — occurrence #27 (first seen 2026-09-04T00:20:48Z, latest 2026-09-04T07:20:07Z).
The SAME condition (`budget-level-uncalibrated-anthropic:endolin-garden-ece02cb4`) has now been observed 27 times; this is ONE
coalesced notice that updates in place, not 27 messages. Latest detail:

budget-level: pool anthropic:endolin-garden-ece02cb4 cap=595000000 is UNCALIBRATED (provenance='none'); NOT leveling workers against a setpoint the config disclaims. Calibrate it (weekly-capacity-calibration.sh or Claude Code /usage) and set the provenance columns on config/budget-pools (calibrated-from date).
