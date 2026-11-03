**Clean stage for PR #199 is done: CI is green at the new head `ff114545db3`, and the PR is still a draft for the panel stage.** The Actions runs `test (typecheck + vitest)` and `clip frame browser gate` both passed. The token can't read the status rollup, so `ci-wait-merge.sh` (rc 0) judged from the Actions runs API only; commit statuses and non-Actions checks weren't visible.

CI was already green when I picked this up, but no coverage pass had been done, so this wasn't a no-op. I measured coverage across the full suite and intersected it with the lines this PR adds under `src/`.

## Pushed
Both commits went up through `safe-push-pr-head.sh`, moving the head from `90e41d68` to `ff114545db3`.

**`c33fd43b`: tests**
- **New `test/web/guest-coupons-app.test.ts`:** boots the coupon settings through `createApp` with the real config, issuer and router; only the store is replaced. It covers:
    - the default-off state, where the redemption route returns 404
    - coupon admission, where `POST /api/guest` returns 403
    - production settings booting with no daemon up
    - the sweep timer skipping overlapping ticks, logging failures and continuing
- **Daemon connection:** reconnecting after a failed connect or a failed close, and `connectCouponIssuer` refusing to start without a socket.
- **Air-drop and guest creation:** a book that goes stale during an air-drop stops at its target, and a failed guest creation can be retried.
- **DynamoDB ledger:** `get`/`getBook` had no tests at all. Also added: `setCapacity` success, giving up after losing every race, and the `ensureBook` paths.
- **Invitation fragments:** refusing a malformed coupon, and the startup decision for a bare coupon.

**`ff114545`: dead code**
- Removed a guard in `mountCouponIssuer` that could never run. `createApp`'s only caller passes `loadConfig`'s result, and that already refuses the same combination; `test/config.test.ts` covers that refusal.

## Evidence
- **Mutation check:** I broke the source in six places, and each break failed the intended new test.
- **Local results:** typecheck passes. The last full-suite run had 1714 passed, 1 failed and 14 skipped; it came before one small `ensureBook` assertion, after which I re-ran only that test file (27 passed).
- **Added lines still uncovered locally:**
    - `src/coupons/daemon-socket.ts`: only the real-daemon suite reaches it, and that suite skips locally. CI's log shows `guest-coupons-daemon.test.ts` passing.
    - `src/coupons/issuer.ts:88-89`: a defensive rethrow in a narrow catch, which I kept on purpose.
- **Not measured:** `deploy/aws/www/home.js` isn't in the coverage report. Its pure functions have direct tests in `test/home-page.test.ts`, but the click handlers are only checked by reading the source.

## Local test failures (none in files this PR touches)
- `test/git-remote/capability.test.ts` ("propagates a git failure") fails every time on this host, including when run alone, but it passed in CI at this head. I didn't check it against the base commit, so "host-specific" is my inference.
- `test/endo-guest-lockdown.test.ts` and `test/deploy-www-staging.test.ts` each failed once during full-suite runs. Both passed when run alone, so I read them as load flakes.

## Follow-ups
None for this stage. The coverage provider was installed with `--no-save`, so `package.json` and the lockfile are unchanged. The PR's existing evidence gap still stands: DynamoDB conditions are checked against a scripted client, not DynamoDB Local.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr199-gauntlet-20261103-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1855002 cached reads)
- Output: 34495 tokens
- Cost: $2.0990364
- Wall-clock: 1126s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
