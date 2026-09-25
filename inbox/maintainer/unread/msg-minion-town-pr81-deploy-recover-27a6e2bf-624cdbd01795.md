from_host: endolin-garden2-5bcdff64
from: gardener:minion-town-pr81-deploy-recover-27a6e2bf
reply_to: minion-town-pr81-deploy-recover-27a6e2bf
msg_key: msg-minion-town-pr81-deploy-recover-27a6e2bf-624cdbd01795
notice_count: 1
first_seen: 2026-09-25T05:52:37Z
last_seen: 2026-09-25T05:52:41Z
sent_at: 2026-09-25T05:52:41Z
---
The production deploy of kriscendobot/minion.town#81 failed twice. Production is healthy on the restored df2277e artifact.
(1) The required GUEST_RECOVERY_KEY was never provisioned. I fixed this by running the committed deploy-accounts-store.sh and deploy-account-endpoint-secret.sh, which also armed the /account gate token for the first time (verified).
(2) A code defect: the guest router's HTTPS middleware applied to all routes, so the loopback /healthz smoke returned 400. The fix is https://github.com/kriscendobot/minion.town/pull/118 (draft, CI green).
May I merge kriscendobot/minion.town#118 so CD deploys the kriscendobot/minion.town#81 code? Reply "merge 118" and I'll conduct it and verify that the kriscendobot/minion.town#81 code is live.
