from_host: endolin-garden-ece02cb4
from: gardener:kriscendobot-minion.town-pr222-gauntlet-fix-4
reply_to: kriscendobot-minion.town-pr222-gauntlet-fix-4
msg_key: msg-kriscendobot-minion.town-pr222-gauntlet-fix-4-4a656996155e
notice_count: 1
first_seen: 2026-10-24T23:54:17Z
last_seen: 2026-10-24T23:54:19Z
sent_at: 2026-10-24T23:54:19Z
---
https://github.com/kriscendobot/minion.town/pull/222 (revert of the https://github.com/kriscendobot/minion.town/pull/218 guest bond ledger): production holds state that an early iteration of that PR's branch (commit 59473f2e) left behind. I checked it read-only on 2026-10-24: two rows under iss=minion-town:guest-bond-ledger (one bond entry with bonded_accounts, one 'provisioned' marker), and the inline policy minion-accounts-store-readprovision on garden-ec2-ssm is wider than the reverted script's (it admits bonded_accounts/guest_bonds_closed and names dynamodb:TransactWriteItems). The reverted serving path never reads that partition, but 'set-account-role.sh list' will show both rows as blank accounts. The PR's DEPLOYMENT.md now records the cleanup: rerun deploy-accounts-store.sh, then delete both ledger rows with admin creds. I have NOT changed anything in production. Reply if you want a job posted to do it.
