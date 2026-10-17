The clean pass on PR #199 is finished, but CI on the new head was still queued at the one-hour deadline, so this stage reports still-pending (`ci-wait-merge` rc 4).

**Before:** PR #199 (`feat/guest-coupons`, draft) was green at d9d481e, but no coverage pass had been done, so this stage was not a no-op.

**Coverage pass** (isolated checkout; I installed `@vitest/coverage-v8` locally without saving it, so `package.json` and the lockfile are unchanged):
- `src/coupons/dynamodb.ts`, the DynamoDB adapter for the coupon ledger, was at 44% line coverage. I added 10 tests to `test/coupon-ledger-dynamodb.test.ts`. They cover reading pool counters, paged scans and book sort order, recording the identifier index, lease (including repeat calls with the same nonce and lost races), complete/revoke/expire, attach-once, book create/append/mark-sent, and errors that aren't condition failures being rethrown. One more test covers choosing the memory store. The adapter is now at 99%.
- `issuer.ts` went from 80% to 98% and `root-ctl.ts` from 89% to 97%. That comes from one new test in `test/web/guest-coupons-http.test.ts` for the `coupon-books`, `coupon-list` and `coupon-revoke-book` commands. It also checks the refusals: unknown book, unknown run id, a bad ttl, `airdrop active`, each command's usage error, and a call made without a coupon ledger.
- `daemon-socket.ts` and `wiring.ts` still show low coverage locally. They are tested only by the real-daemon suite (`guest-coupons-daemon.test.ts`), which CI runs and which is skipped without an Endo checkout.
- **Dead code:** none. Every unused export is either a type that's part of the module's API or is used inside its own module.
- **Checks:** `npm run typecheck` is clean. The full suite gave 1195 passed and 1 failed. The failure is `git-remote/capability.test.ts` ("propagates a git failure"), which fails on garden hosts because of the git wrapper; it isn't in the PR's files.

**Push:** commit 94c4943 (`test(coupons): cover the DynamoDB ledger adapter and the book root verbs`), advanced onto the PR head d9d481e → 94c4943 with `safe-push-pr-head.sh --mode advance`.

**CI:** minion.town CI is running on a single self-hosted runner that takes one run at a time. At 10:39Z "Claude harness (amd64)" had passed, while "test" and "Claude harness (arm64)" had sat queued since 09:42Z. Our run was waiting behind one in progress (`feat/chat-clip`) and one queued (`feat/new-clip-inventory`). Nothing has failed. The driver should re-post this stage with a fresh budget.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr199-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2599360 cached reads)
- Output: 17338 tokens
- Cost: $1.620488
- Wall-clock: 3658s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
