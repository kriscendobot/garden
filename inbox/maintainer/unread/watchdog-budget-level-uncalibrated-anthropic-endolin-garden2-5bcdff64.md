from_host: endolin-garden-ece02cb4
from: watchdog:budget-level
sent_at: 2026-09-04T03:50:07Z
watchdog_key: budget-level-uncalibrated-anthropic:endolin-garden2-5bcdff64
notice_count: 14
first_seen: 2026-09-04T00:20:58Z
last_seen: 2026-09-04T03:50:07Z
---
WATCHDOG notice — occurrence #14 (first seen 2026-09-04T00:20:58Z, latest 2026-09-04T03:50:07Z).
The SAME condition (`budget-level-uncalibrated-anthropic:endolin-garden2-5bcdff64`) has now been observed 14 times; this is ONE
coalesced notice that updates in place, not 14 messages. Latest detail:

budget-level: pool anthropic:endolin-garden2-5bcdff64 cap=385000000 is UNCALIBRATED (provenance='none'); NOT leveling workers against a setpoint the config disclaims. Calibrate it (weekly-capacity-calibration.sh or Claude Code /usage) and set the provenance columns on config/budget-pools (calibrated-from date).
