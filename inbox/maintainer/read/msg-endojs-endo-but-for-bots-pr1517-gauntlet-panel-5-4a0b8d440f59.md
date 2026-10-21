from_host: oros-studio-garden-ce242c49
from: gardener:endojs-endo-but-for-bots-pr1517-gauntlet-panel-5
reply_to: endojs-endo-but-for-bots-pr1517-gauntlet-panel-5
msg_key: msg-endojs-endo-but-for-bots-pr1517-gauntlet-panel-5-4a0b8d440f59
notice_count: 1
first_seen: 2026-10-21T08:53:58Z
last_seen: 2026-10-21T08:54:11Z
sent_at: 2026-10-21T08:54:11Z
---
PR endojs/endo-but-for-bots#1517 gauntlet panel round 5: probes passed and all seats ran on host oros-studio-garden-ce242c49, but posting the review failed with 'GraphQL: Resource not accessible by personal access token (addPullRequestReview)'. This host's bot PAT can't write PR reviews on endojs (known). I'm reporting panel=panel-error so the driver retries the round, but a retry claimed on oros-studio will fail the same way. The retry should be pinned with requires: host=endolin-garden-ece02cb4, or panel jobs for endojs PRs should be routed away from oros.
