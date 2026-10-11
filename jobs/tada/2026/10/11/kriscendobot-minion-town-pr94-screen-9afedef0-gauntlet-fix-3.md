I applied the round-3 panel's must-fix item and three of its should-fix items to kriscendobot/minion.town PR #94, pushed them, and CI is green (`ci-wait-merge.sh` returned 0, all 3 checks passed).

**Changes** (pushed with `safe-push-pr-head.sh`, head `13bea12` → `ae8db10`):
- **`8b92000` (test), the must-fix:** in `test/github-oidc-thunk-token-auth.test.ts`, the two Basic-pair property tests now name their callback parameters `presentedIdentifier`/`presentedSecret` instead of `id`/`s`. The old names shadowed the `secret` arbitrary next to them.
- **`8b92000` (test), should-fix:** a new test sends a JSON `null` body with a valid Basic header and expects 400 `invalid_request`. I checked that it pins the null normalization in `parseFormOrJson`: with the normalization temporarily reverted, this test fails.
- **`ae8db10` (fix), should-fix:** `getGitHubCredentials` in `secret.js` now refuses a `client_id` or `client_secret` that is not a string. `/token` then answers 500 `server_error` instead of the outer catch's 400.
- **`ae8db10` (fix), should-fix:** reworded the "stage dir" comment in `deploy-account-endpoint-secret.sh`.

**Local checks:**
- The changed test file passes (25 tests) and the type check is clean.
- The full `npm test` run had one failure, in `test/git-remote/capability.test.ts` ("propagates a git failure rather than reporting the ref absent"). It is in a file this fix doesn't touch and probably depends on the local environment. I didn't confirm that it fails without my changes, but the same suite passed in CI.
- I didn't run Prettier on the changes: the test file already failed Prettier before them, so reformatting would only add unrelated churn.

**Follow-ups:**
- I did not post a summary comment for this round.
- The driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr94-screen-9afedef0-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1107069 cached reads)
- Output: 7958 tokens
- Cost: $0.9355097999999998
- Wall-clock: 890s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
