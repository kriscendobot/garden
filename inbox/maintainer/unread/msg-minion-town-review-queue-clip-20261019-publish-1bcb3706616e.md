from_host: endolin-garden-ece02cb4
from: gardener:minion-town-review-queue-clip-20261019-publish
reply_to: minion-town-review-queue-clip-20261019-publish
msg_key: msg-minion-town-review-queue-clip-20261019-publish-1bcb3706616e
notice_count: 1
first_seen: 2026-10-20T02:33:40Z
last_seen: 2026-10-20T02:33:41Z
sent_at: 2026-10-20T02:33:41Z
---
minion.town review-queue clip published:
https://tdqbaf4dj7yp44dx72ovmpwh7gfkpq7fhguawk6bvz45kjqrtqxq.ocap.site/

Generated 2026-10-20T02:33:14Z · minion.town main ea08cf055085 (last main deploy success at that commit) · 54 open PRs. A snapshot, not live. Ask for a fresh one with scripts/jobs/minion-town-review-queue/publish.sh.

Ranking (what each one unblocks):
1. kriscendobot/minion.town#144 coupons design: unblocks kriscendobot/minion.town#199, the coupons phase-1 remainder build, and the closed-beta flip. Approve and merge.
2. kriscendobot/minion.town#199 coupons build: unblocks the flip and the remainder build. Merge after kriscendobot/minion.town#144 (default-off), or grant 2 rounds.
3. kriscendobot/minion.town#198 waitlist/landing: unblocks the flip and kriscendobot/minion.town#200. Merge or revise; you decide whether to keep the CSV mode.
4. Job minion-town-coupon-admission-flip-20261019: the closed beta itself. Say go ahead once kriscendobot/minion.town#144, kriscendobot/minion.town#199 and kriscendobot/minion.town#198 are merged and the deploy is green.
5. The accounts-store migration: unblocks deploying kriscendobot/minion.town#200. Only you can run it, as the fleet admin.
6. kriscendobot/minion.town#200 log out/account deletion: soft flip precondition. Revise rather than merge; grant 2 rounds after the migration.
7. kriscendobot/minion.town#201 name rules: unblocks kriscendobot/minion.town#202 Chat. Merge, or 2 rounds for the cleanup.
8. kriscendobot/minion.town#202 Chat: a leaf. Revise after kriscendobot/minion.town#201 (one must-fix concurrency item).
9. kriscendobot/minion.town#37 ocap-mailboxes design: unblocks the parked mailboxes build. Approve or reject.
10. kriscendobot/minion.town#142 gutter design: unblocks the parked gutter build. Approve or reject.
11. kriscendobot/minion.town#151 the JS-only scripts stack (kriscendobot/minion.town#152–154): land it bottom-up or close all four.
12. kriscendobot/minion.town#180 git-remote: unblocks kriscendobot/minion.town#181. 16 rounds spent and still churning. Decide: grant rounds, revise by hand, or park.
13. kriscendobot/minion.town#178 resource caps: same decision as kriscendobot/minion.town#180 (12 rounds spent).
14. kriscendobot/minion.town#171: unblocks the node-interpreter probe. Merge or close.
15. kriscendobot/minion.town#183 Endo pin + credentials: its fix job ran out of retries. Re-scope, merge as is, or close.
Dropped since the predecessor's draft: kriscendobot/minion.town#207 (merged 2026-10-20T01:26Z).

Scrub checklist (enforced by build.py's SCRUB list, which passed; I also re-checked the published file by hand): no GitHub tokens, no AWS keys or ARNs, no 12-digit account ids, no garden host names, no home paths, no email addresses, no IP addresses, no bearer/secret/password strings, no exploit wording. Review hints are topic-level only: the security-adjacent ones on kriscendobot/minion.town#200 and kriscendobot/minion.town#180 are stated as topics, not findings. No comment text from outside parties. No maintainer-private matters. The word "secrets" appears only inside two public PR titles (kriscendobot/minion.town#183, kriscendobot/minion.town#191).

I checked the page at 390px in light and dark, with no horizontal overflow. The first publish overflowed by about 30px because a long SHA didn't wrap. I fixed the CSS (main2 6761cdb0d0c), republished, and unpublished the superseded clip, which now returns 404.
