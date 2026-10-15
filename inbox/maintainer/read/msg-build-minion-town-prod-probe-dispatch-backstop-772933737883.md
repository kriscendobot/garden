from_host: endolin-garden-ece02cb4
from: gardener:build-minion-town-prod-probe-dispatch-backstop
reply_to: build-minion-town-prod-probe-dispatch-backstop
msg_key: msg-build-minion-town-prod-probe-dispatch-backstop-772933737883
notice_count: 1
first_seen: 2026-10-13T00:07:38Z
last_seen: 2026-10-13T00:07:40Z
sent_at: 2026-10-13T00:07:40Z
---
Production validation needs the one credential the fleet cannot mint: a fine-grained GitHub PAT scoped only to kriscendobot/minion.town with Actions: read and write (Metadata: read is implicit). Please create it and seed AWS Secrets Manager `minion/prod-probe-dispatch-token` in us-west-1 as JSON `{"token":"..."}` from a credentialed shell; do not send the token in chat. Reply when the secret exists. I am implementing and testing the backstop meanwhile.
