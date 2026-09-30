---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---

# Post review replies on endojs/endo-but-for-bots#1116 (handoff from oros-studio, 403 on PR writes)

The design revision answering kriskowal's review
https://github.com/endojs/endo-but-for-bots/pull/1116#pullrequestreview-5360612317
is ALREADY PUSHED to `design/guest-native-invitations` as commit f7b82cba0 (job
endojs-endo-but-for-bots-pr1116-review-70b9d56c). Do NOT edit the design. Your only
task is to post the replies below. Host oros-studio-garden-ce242c49 cannot write
PR comments on endojs (403).

First, check each thread for an existing kriscendobot reply that mentions f7b82cba0
and skip any that is already there (idempotency). Then, for each item, run:
  gh api -X POST repos/endojs/endo-but-for-bots/pulls/1116/comments/<ID>/replies -f body=<TEXT>

- 4140105233: Done in f7b82cba0. Open Question 1 is resolved. Section 2 now says any agent can accept any agent's invitation, whether the inviter is a host or a guest. It also adds *Onboarding a newcomer*: the service that receives the link provisions a guest through its host's `provideGuest`, and that guest accepts as itself. #1310 already routes `EndoHost.accept` through the shared helper, so no guest is minted.
- 4140113515: Done in f7b82cba0. Open Question 2 now says to remove the pin, and that per-agent pins (#1306) replace it. #1310 already removed the `@pins/guest-*` mint on both facets. One conflict: draft design #1277 (retention labels) proposes a lifecycle for a per-invitation `hostPins` pin key. That conflicts with this decision, so I've flagged it for reconciliation before #1277 lands. Should #1277 drop the invitation-pin parts?
- 4140124743: Thanks, that helps. Open Question 3 now says: the inviter-side formula-store transition is the only commit point, and after a restart the daemon re-drives the acceptor's `accepting` record. For crossed invitations (two agents redeeming each other's invitations at the same time), both daemons compare the two invitation formula ids, and the lower id wins. The losing invitation resolves as `already-joined` and is cancelled. Please say if the tie-break should use handle ids instead.
- 4140131034: Done in f7b82cba0. Section 7 now records the invitation state machine in the formula store. On the inviter: `pending` → `accepted(handle)` | `revoked`. On the acceptor: `accepting` → `joined`, re-driven after a restart. This replaces the in-memory serialization and the outcome-unknown error from #1310.
- 4140142232: Done in f7b82cba0. `remove` of the last reference now revokes: the formula becomes unreachable, is collected promptly, and its incarnation is cancelled. `rename` keeps the invitation pending, and redemption binds at the invitation's current name instead of the path captured at mint. The reject guard is gone. Collection is still off by default (`ENDO_GC`), so until it is on, the formula-store state refuses redemption and `cancel()` stays the explicit verb.
- 4140186381: Posted follow-up job `design-minion-town-guest-coupons` for guest-account coupons carried by invitations: a growable root pool, air-dropped coupon books, and expiry back to the pool. Open Question 6 records that this design does not depend on it.

Then post one top-level PR comment (gh pr comment 1116 -R endojs/endo-but-for-bots):
"@kriskowal Addressed review 5360612317 in f7b82cba0, reconciled against what has landed since (#1305, #1306, #1310) and against in-flight #1277 and #399. The new *Implementation status* section records each place where the landed code differs from the design. Two questions: (1) #1310 throws errors, but section 1 asks for a returned `{ status }` record (now including `revoked`) because a thrown tag does not survive CapTP. Keep the returned record as remaining work, or accept the thrown errors? (2) Should #1277 drop its per-invitation `hostPins` lifecycle, now that the pin is removed?"
