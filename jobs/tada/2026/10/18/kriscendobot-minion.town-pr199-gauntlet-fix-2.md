I applied the round-2 panel fixes to PR #199 and pushed them, but CI has not finished: the main `test` check passed, and the two `Claude harness` checks were still pending when the one-hour deadline ran out. `ci-wait-merge` returned rc 4 (still pending), so the driver should re-post this stage. The `test` run sat queued for about 55 minutes before a runner picked it up, which looks like the known ci.minion.town runner stall rather than anything in this PR.

**Pushed** with `safe-push-pr-head.sh`, which moved `feat/guest-coupons` from `4c239f9` to `ba87842` as three follow-up commits:

1. **`73f8278` fix(coupons), DynamoDB adapter.** This covers the assessor must-fix and the should-fixes on the same code.
   - A cancelled transaction (`TransactionCanceledException`) now counts as a lost condition check only when one of its `CancellationReasons` is `ConditionalCheckFailed`. A transaction conflict or throttling cancel is now rethrown, so it can no longer show up as "pool exhausted", a 403, or a false return.
   - `complete`, `revoke` and `expire` now only write if the row is unchanged since they read it (`AND #row = :row`). On a lost race they re-read and decide again, so a write from `recordIdentifier` or `attach` that happened in between is kept.
   - `recordIdentifier` now throws when its retries run out instead of returning silently.
   - A corrupt stored row now names its `pk` in the error.
   - New tests cover the conflict cancel, the re-read after a lost race, and the corrupt row.
2. **`9936dc9` fix(coupons), operator arguments and router.** This covers the corner-prober must-fix (an empty recipient list) and should-fixes from saboteur, locksmith and corner-prober.
   - `coupon-airdrop` removes duplicate recipients and refuses an empty list.
   - `coupon-issue` refuses empty path segments and paths under `coupons/issued` or `coupons/outbox` before it reserves anything. The README's `coupons/probe` smoke check still works.
   - The sweep skips unbound rows younger than `BIND_GRACE_MS` (15 minutes), and the service skips a sweep tick instead of running two at once.
   - The web router now gets a frozen object holding only `redeem` and `attachForHolder`, not the whole issuer.
   - `guest.js` keeps the redemption nonce in memory for the page's lifetime, so retries reuse one nonce when `localStorage` fails.
   - Two new tests cover these changes.
3. **`ba87842` docs(coupons).** This covers the archivist must-fix and the pruner cuts.
   - The README and `config.ts` now say that `COUPON_STORE=off` mounts no issuer or sweep and that `POST /api/guest/coupon` answers 404.
   - The README now lists the `ID#` index row and the `coupon-capacity` verb.
   - The comment on the coupon field in `invitation-envelope.ts` now says the "no existing guest" check happens in `guest.js`.
   - I cut the repeated comments the pruner flagged in `store.ts`, `dynamodb.ts`, `http.ts`, `minion-mcp.service`, `test.yml` and two test comments.

Locally, typecheck is clean and the coupon, config and envelope suites pass. The full suite has one failure, `test/git-remote/capability.test.ts`, in a file this PR doesn't touch. I didn't check whether it also fails on the base commit.

**Left for the maintainer or a later round** (all should-fix or comment-only):
- The locksmith asked that spending a coupon from the web depend on holding the coupon rather than on who the caller is. That changes the design.
- The assessor asked that partially filled air-drop books not be marked `sent`, so a resume can top them up.
- Source comments point to `designs/guest-coupons.md`, which isn't on this branch; it would need to land or the pointers be removed.
- The pruner's PR-body cuts.
- The corner-prober's extra boundary tests (expiry at the exact tick, TTL limits, malformed redeem request bodies).

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr199-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (4224757 cached reads)
- Output: 21256 tokens
- Cost: $2.213647400000001
- Wall-clock: 4395s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
