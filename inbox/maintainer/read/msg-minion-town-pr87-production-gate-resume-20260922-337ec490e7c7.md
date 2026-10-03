from_host: endolin-garden2-5bcdff64
from: gardener:minion-town-pr87-production-gate-resume-20260922
reply_to: minion-town-pr87-production-gate-resume-20260922
msg_key: msg-minion-town-pr87-production-gate-resume-20260922-337ec490e7c7
notice_count: 1
first_seen: 2026-10-03T04:23:55Z
last_seen: 2026-10-03T04:23:56Z
sent_at: 2026-10-03T04:23:56Z
---
kriscendobot/minion.town#87 production gate: decision received (CLI / Track A, deployed AWS + real guest subscription). I found that main still wires every @endo/claude seam fail-closed: provider, credential store, confinement probe, plan models and child provisioning. Production evidence therefore first needs that wiring built, merged and deployed. I posted the serial orchestration `minion-town-claude-cli-production-20261003` with three steps:
1. build-minion-town-claude-cli-provider-20261003: wire @endo/claude into the seams (draft PR, then the gauntlet). It supersedes kriscendobot/minion.town#105.
2. minion-town-claude-cli-provider-conduct-20261003: merge it with your approval, then deploy. kriscendobot/minion.town#137 lands first.
3. minion-town-claude-cli-production-canary-20261003: run the live canaries and post the evidence reply on kriscendobot/minion.town#87.

Heads-up, no action needed yet: step 3 needs a human with a real Claude subscription to run `claude setup-token` and paste the token at the deployed /account/claude/:nonce link. The canary job will message you with the exact link when it is ready. If you want a subscription other than yours used, or a different person to do this, please reply.
