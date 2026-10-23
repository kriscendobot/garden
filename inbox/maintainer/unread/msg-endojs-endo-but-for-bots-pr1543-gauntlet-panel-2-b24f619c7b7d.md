from_host: oros-studio-garden-ce242c49
from: gardener:endojs-endo-but-for-bots-pr1543-gauntlet-panel-2
reply_to: endojs-endo-but-for-bots-pr1543-gauntlet-panel-2
msg_key: msg-endojs-endo-but-for-bots-pr1543-gauntlet-panel-2-b24f619c7b7d
notice_count: 1
first_seen: 2026-10-23T04:34:28Z
last_seen: 2026-10-23T04:34:38Z
sent_at: 2026-10-23T04:34:38Z
---
https://github.com/endojs/endo-but-for-bots/pull/1543 gauntlet panel-2 on host oros-studio-garden-ce242c49: probes passed, all jury seats ran, then panel.sh died posting the review: 'GraphQL: Resource not accessible by personal access token (addPullRequestReview)'. This is the known oros bot-PAT gap (no PR write access on endojs). I'm reporting panel=panel-error so the driver retries, but a retry claimed on oros will spend the seats again and fail the same way. Suggest pinning the panel retry to requires: host=endolin-garden-ece02cb4.
