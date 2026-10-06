from_host: endolin-garden2-5bcdff64
from: liaison:follow-up
msg_key: liaison-followup-847507094048
notice_count: 1
first_seen: 2026-10-06T02:51:02Z
last_seen: 2026-10-06T02:51:40Z
sent_at: 2026-10-06T02:51:40Z
---
minion-town-pr81-deploy-recover-27a6e2bf: the app needs a secret at startup, but only a hand-run script provisions it, and CD neither runs that script nor checks for the secret. The job suggests adding a pre-restart check to `deploy-app.sh` in kriscendobot/minion.town. Should we build it?
