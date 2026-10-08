# Clean stage report: kriscendobot/minion.town PR #94

The clean stage is done. I added tests for the new token-endpoint client authentication, and CI is green at the new head `5f246ba`.

**Starting point.** CI was already green at head `51314780b`, but this stage wasn't a no-op. The PR's main security fix, the `/token` client-authentication gate in `deploy/aws/lambda/github-oidc-thunk/index.js`, had no tests at all. The only nearby test file (`openid.self-test.js`) covers email selection.

**What I changed** (one commit, `5f246ba`, pushed with `safe-push-pr-head.sh --mode advance`, moving `51314780b` to `5f246bac7f3`):
- **`test/github-oidc-thunk-token-auth.test.ts`** (new): 7 tests in the root vitest suite, which is the one CI runs. It stubs the Secrets Manager SDK and GitHub's code exchange, then calls the real handler. It covers:
  - the right credentials sent in the form body, and the right credentials sent as HTTP Basic auth;
  - a request with no credentials;
  - a wrong secret;
  - the right secret under the wrong client ID;
  - a wrong secret in the Basic header while the body carries the right one;
  - malformed Basic credentials: no colon, and a bad percent-escape.

  Each refusal also checks that no code exchange happened. I confirmed the tests catch a regression: with the 401 return removed, 5 of the 7 fail.
- **`deploy/thunks/siwe/test/oidc-face.test.js`**: added two cases. One refuses a wrong secret sent as Basic auth. The other refuses client IDs that are built-in object property names (`constructor`, `toString`, `__proto__`, `hasOwnProperty`), which the PR's own-property lookup now handles. The SIWE suite passes locally, 21/21.
- **Dead code:** the change didn't leave any behind. The old inline client check in `openid.js` was replaced, not left alongside the new one.

**Checks.**
- The new vitest file passes (7/7) and `npm run typecheck` is clean.
- `ci-wait-merge.sh --no-merge` returned rc 0 (GREEN). At head `5f246ba`, `test`, `Claude harness (amd64)` and `Claude harness (arm64)` all succeeded.

**Follow-up.** The SIWE thunk's own `node --test` suite isn't run by CI: the root vitest config excludes `deploy/**`, and no workflow step runs it. Its tests, including the two I added, only run locally. Adding a CI step for that sub-package is worth considering.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr94-gauntlet-20261008-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1199212 cached reads)
- Output: 10088 tokens
- Cost: $0.9562664000000001
- Wall-clock: 504s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
