# FIX round 5: kriscendobot/minion.town PR #199

I applied the round-5 panel fixes (review 5563908936) as three follow-up commits and pushed them to `feat/guest-coupons` (`478fb7f9` → `9dfd43ed`). CI is green on all three checks: `test` (including the live-daemon suites), Claude harness amd64 and Claude harness arm64. I did not re-run the panel.

**Commits**
- `5048d919` fix(coupons):
  - **Resume (assessor):** a resume now replaces every undelivered coupon that can no longer be redeemed: revoked, expired or missing. Before, it only replaced expired ones.
  - **Repeated sends (breaker, saboteur, engine-realist):** air-drop delivery is now stated and tested as "at least once per book." If a send reaches the guest but its confirmation is lost, the resume sends the same coupons again under the same `bookId`. The message now names the `bookId`, and a coupon still redeems only once, so the duplicate admits no extra guest. I also corrected the comment in `wiring.ts` that claimed a send "is not repeated."
  - **Book size (saboteur):** a book is capped at `MAX_BOOK_COUPONS` = 1000 coupons, checked before any coupon is reserved. This keeps a book under DynamoDB's 400 KB item limit.
  - **Book paths (breaker):** every path segment must now pass the daemon's pet-name check, so `.`, `..`, `@name`, NUL and segments over 255 characters are refused up front.
  - **Redemption index (wire-watcher):** `redeem` uses the `ID#` index entry only when the coupon row records the same identifier.
  - **Smaller items:** export docs on `makeCouponIssuer` and `makeCouponLedger` (archivist), the `methodArguments` rename (stylist), and boundary tests and fast-check properties (corner-prober, fast-checker).
  - I updated the live-daemon test's expected message text to include the `bookId`.
- `e2d424bf` fix(guest-page):
  - **Parser divergence (spec-keeper, wire-watcher, purist):** the browser page's fragment parser in `guest.js` now follows the same rules as the server's `parseFragment`.
  - Under test, the browser page script no longer runs its page setup on import, so the parser can be tested. A new property test (`test/web/guest-fragment-parity.test.ts`) checks that the two parsers agree.
- `9dfd43ed` fix(deploy):
  - **Deletion protection (saboteur):** `deploy-coupon-store.sh` no longer hides failures with `|| true`. It turns deletion protection on only when it is off, and stops with an error if it can't.
  - **Spelling (orthographer):** cancelled → canceled.

**Other changes**
- Retitled the PR "feat(guest): default-off coupon admission for a future closed beta" (integrator).
- Updated the running fix-summary comment (#issuecomment-6250666807) with the round-5 fixes, what I declined, and how I verified.

**Declined or deferred**
- **IAM permission (archivist):** declined. IAM has no `dynamodb:TransactWriteItems` action; a transaction is authorized through the actions it contains, which the policy already grants ([AWS docs](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/transaction-apis-iam.html)). I briefly added the permission, then removed it before committing.
- **Capability-based coupon attachment (locksmith):** deferred to design PR #144, because it changes the guest-side protocol.
- **Design alignment (integrator):** the PR stays draft until #144 settles.
- **Scan cost and benchmark (engine-realist #2, benchmarker):** deferred, same as round 4.
- **Changeset (releaser):** declined; this repo has no changeset tooling.
- **pruner, duality-auditor, procurer:** their findings were comment-only, so I left them.

**Verification:** the type check (`tsc --noEmit`) is clean. Locally, `npm test` had 1240 passing, 12 skipped and 1 failing; the failure is `git-remote/capability.test.ts`, the known local git-wrapper false failure. The first CI wait (`ci-wait-merge.sh`) hit the background time limit and was stopped about 1150s in, so I restarted it with a 2400s deadline. It finished green (rc 0).

**Follow-up:** delivering each book exactly once would need the recipient to send back a receipt; that would be a separate design change.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr199-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 96 tokens (5552743 cached reads)
- Output: 32858 tokens
- Cost: $2.8830911000000006
- Wall-clock: 2329s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
