---
handed-off: endojs-endo-but-for-bots-pr1116-review-replies-f7b82cb
deliverable-complete: false
---
I revised the #1116 design to answer every point in kriskowal's review and pushed it. The replies to the review threads and the follow-up questions are **not posted yet**. This host's GitHub token gets a 403 on PR comments for endojs, so I handed that part to a job pinned to the endolin host.

**Design revision**, pushed to `design/guest-native-invitations` as `f7b82cba0`:
- I first merged current `llm` into the branch (`6136cae92`). In the `designs/README.md` conflict I took `llm`'s side and re-added this design's rows as In Progress. That touches the totals: In Progress goes from 83 to 84 and indexed records from 240 to 241.
- **Reconciliation with what landed since:** a new *Implementation status* section records:
  - What merged: #1305 (guest `invite`), #1306 (per-agent pins), and #1310 (guest `accept`). #1310 also makes host `accept` use the same helper, so no guest is minted on either side anymore.
  - A table of the places where the landed code differs from the design.
  - Two in-flight PRs: #1277 (retention labels) and #399 (deep-link invitations).
- The six inline comments, as recorded in the design:
  1. Any agent can accept any agent's invitation. A newcomer who opens a link gets a guest provisioned to accept with (new *Onboarding a newcomer* part of section 2).
  2. The minted `@pins/guest-*` pin is removed and per-agent pins replace it. #1277 still assumes a per-invitation pin and has to be reconciled with this.
  3. When two agents redeem each other's invitations at the same time, the tie is broken by comparing invitation formula ids, as with CapTP crossed hellos. Recovery after a crash is re-driven from the stored state.
  4. The invitation state machine is stored in the formula store so invitations survive a restart (section 7). This replaces #1310's in-memory serialization and its "outcome unknown" error.
  5. `remove` of the last reference revokes an invitation through prompt collection. `rename` is not revocation, and redemption binds at the invitation's current name. The old reject guard is dropped.
  6. Rate limiting is out of scope, and the follow-up job is posted (below).
- I added a `revoked` status to the outcome record. Only one item stays open: #1310 throws errors, while the design asks for a returned `{ status }` record.
- Prettier passes on both changed files. It's a docs-only change, so nothing else was run.

**Jobs posted** (both confirmed in `jobs/todo/` on `journal2`):
- `design-minion-town-guest-coupons`: a designer job for the guest-account coupons kriskowal described (an invitation can carry a coupon, the root holds a growable pool, coupon books are air-dropped, and unused coupons expire back to the pool).
- `endojs-endo-but-for-bots-pr1116-review-replies-f7b82cb`: pinned to `endolin-garden-ece02cb4`. It posts the six thread replies and a top-level comment with two questions for kriskowal:
  - Keep the returned `{ status }` record as remaining work, or accept #1310's thrown errors?
  - Should #1277 drop its per-invitation `hostPins` lifecycle now that the pin is removed?

**For later:** #1277 needs updating once kriskowal answers the second question. The implementation work left for a builder is the formula-store state machine, the returned status record, and revocation by collection, which needs collection turned on by default.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1116-review-70b9d56c.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (5185354 cached reads)
- Output: 31043 tokens
- Cost: $2.777330799999999
- Wall-clock: 3694s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
