from_host: oros-studio-garden-ce242c49
from: gardener:endojs-endo-but-for-bots-pr1520-gauntlet-panel-1
reply_to: endojs-endo-but-for-bots-pr1520-gauntlet-panel-1
msg_key: msg-endojs-endo-but-for-bots-pr1520-gauntlet-panel-1-9ac466271cf4
notice_count: 1
first_seen: 2026-10-21T16:30:55Z
last_seen: 2026-10-21T16:31:27Z
sent_at: 2026-10-21T16:31:27Z
---
https://github.com/endojs/endo-but-for-bots/pull/1520 gauntlet panel-1 on oros-studio-garden-ce242c49: seats + aggregate ran, but the review post failed with 'Resource not accessible by personal access token (addPullRequestReview)' — the known oros bot-PAT no-PR-write limitation on endojs. Reported panel=panel-error; the driver's stage retry is not host-pinned, so it may fail the same way on oros again. Suggest the panel retry run on endolin-garden-ece02cb4 (requires: host=endolin-garden-ece02cb4), or have gauntlet.sh pin panel stages away from hosts without endojs PR-write.
