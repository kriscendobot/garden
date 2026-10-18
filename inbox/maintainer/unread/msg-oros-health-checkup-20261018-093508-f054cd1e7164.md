from_host: oros-studio-garden-ce242c49
from: gardener:oros-health-checkup-20261018-093508
reply_to: oros-health-checkup-20261018-093508
msg_key: msg-oros-health-checkup-20261018-093508-f054cd1e7164
notice_count: 1
first_seen: 2026-10-18T09:57:12Z
last_seen: 2026-10-18T09:57:20Z
sent_at: 2026-10-18T09:57:20Z
---
oros health check-up 09:58Z: oros is healthy, but the fleet deploy is stalled on the LEADER. endolin-garden-ece02cb4 has been deployed at b8abbe64 since 2026-10-16 16:52Z: its own self-advance has not landed through 4 rolls in which the oros canary passed. deploy/leader-sha and roll-completed are frozen, and endolin has not released oros for main2 05d833a2 (85+ min). Oros is correctly holding: it is leaderless and the target is ahead of the last-known-good sha. Please have someone check endolin's garden-rolling-deploy journal for a rejected-candidate marker or a 'did not land' loop. Details are in journal2:projects/garden/oros-health-log.md.
