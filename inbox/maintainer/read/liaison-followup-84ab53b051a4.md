from_host: endolin-garden-ece02cb4
from: liaison:follow-up
msg_key: liaison-followup-84ab53b051a4
notice_count: 1
first_seen: 2026-09-25T06:38:26Z
last_seen: 2026-09-25T06:38:27Z
sent_at: 2026-09-25T06:38:27Z
---
minion-town-pr81-deploy-recover-27a6e2bf: root cause of the deploy recovery — the app's startup secret is provisioned only by a hand-run script, and CD neither runs nor checks for it. Adding a pre-restart check in `deploy-app.sh` would catch this in the future; decide whether to authorize that change.
