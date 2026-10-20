from_host: oros-studio-garden-ce242c49
from: gardener:minion-town-review-queue-clip-20261019
reply_to: minion-town-review-queue-clip-20261019
msg_key: msg-minion-town-review-queue-clip-20261019-5e6e365c18a8
notice_count: 1
first_seen: 2026-10-20T01:23:01Z
last_seen: 2026-10-20T01:23:13Z
sent_at: 2026-10-20T01:23:13Z
---
minion.town review queue: ranking is built, but the clip is not published yet. This host has no AWS credential for the minion.town MCP bridge, so publishing moved to minion-town-review-queue-clip-20261019-publish (requires: aws). That job will send you the URL.

Ranking (snapshot 2026-10-20T01:22Z, main dc3240231cf1, last main deploy green):
1. kriscendobot/minion.town#144 coupons design: merge. Unblocks kriscendobot/minion.town#199, the coupons phase-1 remainder build, and the flip. Panel is converging.
2. kriscendobot/minion.town#199 coupons (default-off): merge after kriscendobot/minion.town#144, or grant 2 rounds. Unblocks the flip. Converging; what's left is docs and length.
3. kriscendobot/minion.town#198 landing + waitlist: merge or revise. Unblocks the flip and kriscendobot/minion.town#200, which is stacked on it. Findings churn in wording but none persist. Open question: keep the waitlist CSV mode?
4. Go ahead on minion-town-coupon-admission-flip-20261019 once 1-3 are merged and deployed.
5. Run `bash deploy/aws/scripts/deploy-accounts-store.sh` as the fleet admin. kriscendobot/minion.town#200 needs it before it can deploy.
6. kriscendobot/minion.town#200 settings: revise, don't merge. Churning, with real defects (failure partway through account deletion, recovery-bond handling).
7. kriscendobot/minion.town#207: no action. A tiny Firefox flake fix the screening conductor already has queued.
8. kriscendobot/minion.town#201 New Clip: merge. Converging. Unblocks kriscendobot/minion.town#202, which is stacked on it.
9. kriscendobot/minion.town#202 Chat: revise after kriscendobot/minion.town#201. One must-fix concurrency defect is still open.
10-16. kriscendobot/minion.town#37 and kriscendobot/minion.town#142 designs each unblock a parked build. kriscendobot/minion.town#151 is the root of the JS-migration stack. kriscendobot/minion.town#180 and kriscendobot/minion.town#178 git-remote are out of rounds and churning: grant more, revise, or park. kriscendobot/minion.town#171 unblocks the node-interpreter probe. kriscendobot/minion.town#183's parked fix job is doomed: re-scope it or close.
Housekeeping: withdraw heal-minion-town-cfafabe (production is green again) and kriscendobot-minion-town-pr148-gauntlet-viability (kriscendobot/minion.town#148 already merged).

Scrub, enforced in build.py: no tokens, keys/ARNs, account ids, host names, home paths, emails, IPs, secrets, or exploit wording. Review hints are topics only.
Refresh: scripts/jobs/minion-town-review-queue/publish.sh
