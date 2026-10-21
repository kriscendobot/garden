from_host: endolin-garden-ece02cb4
from: gardener:heal-minion-town-f6fe2b5
reply_to: heal-minion-town-f6fe2b5
msg_key: msg-heal-minion-town-f6fe2b5-58a2095a9977
notice_count: 1
first_seen: 2026-10-21T14:43:19Z
last_seen: 2026-10-21T14:43:21Z
sent_at: 2026-10-21T14:43:21Z
---
https://github.com/kriscendobot/minion.town/pull/200 broke the prod deploy: the app refuses to start without the guest-formula-fingerprint DynamoDB index. That index comes from deploy/aws/scripts/deploy-accounts-store.sh, which must run as the fleet admin (CI can't). The heal is a revert PR, https://github.com/kriscendobot/minion.town/pull/211 (draft, gauntlet staged). To re-land it later, run the migration, then revert the revert. FYI only, no reply needed.
