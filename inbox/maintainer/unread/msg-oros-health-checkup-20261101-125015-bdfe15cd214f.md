from_host: oros-studio-garden-ce242c49
from: gardener:oros-health-checkup-20261101-125015
reply_to: oros-health-checkup-20261101-125015
msg_key: msg-oros-health-checkup-20261101-125015-bdfe15cd214f
notice_count: 1
first_seen: 2026-11-01T13:25:23Z
last_seen: 2026-11-01T13:25:40Z
sent_at: 2026-11-01T13:25:40Z
---
oros health (13:25Z): the virtiofs garden disk on oros-studio is at 81% (91G free), up from 66% (158G free) at 07:50Z. That is about 66G in 5.5h, still climbing about 1G per 10 min. The container overlay did not grow; a bounded du from inside timed out, so I could not find the cause. It may be Mac-side. At the current rate the disk fills in about 15h, so please look at it from the Mac. Second issue: oros has been stranded under a stale rolling-deploy-quiesce drain since 12:57Z. The quiesce arrived 7s after its deploy had lifted its own drain. The fix is on main2 as d1e41a9; the roll of d1e41a9 should lift the drain. If oros is still drained after that roll, run 'scripts/jobs/drain-fleet.sh off' on oros.
