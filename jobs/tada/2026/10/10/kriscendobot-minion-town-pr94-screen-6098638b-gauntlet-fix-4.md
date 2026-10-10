# Fix round 4 for kriscendobot/minion.town PR #94

I applied the four must-fix items from the round-4 panel verdict (review 5478732079, head `adfaefd`) and two of its should-fix items. The rewritten head `971365d` has green CI: `ci-wait-merge.sh` returned rc 0 with all 3 checks passing.

**Must-fix items:**
- **spec-keeper (RFC 6749 § 5.2):** a refused `/token` request from a client that used `Authorization: Basic` now gets a `WWW-Authenticate: Basic realm="token", charset="UTF-8"` header.
  - A new helper, `invalidClientHeaders`, in the shared `client-authentication.js` builds the header. Both the GitHub thunk (`index.js`) and the SIWE thunk (`openid.js`) use it on their 401 responses.
  - `CONTRACT.md` now records the header.
  - New assertions in both test suites check that the header is present for Basic clients and absent for `client_secret_post` clients.
- **archivist:** both READMEs claimed a 401 `invalid_client` shows up "in the thunk's logs", but neither thunk logs it. They now say the thunk does not log a refused `/token` and name what an operator can actually see instead.
- **pruner:**
  - Cut the PR body from 343 to 196 words.
  - Removed four of the five places that restated "one shared implementation"; the module header keeps it.
  - Dropped the history paragraph from the GitHub thunk README, the two duplicate "Streams…" comments, the "Pattern from…" provenance comment, the test comment that just narrated the deploy script, the duplicated "Authenticated, so…" test comment, the JSDoc opener that repeated the function name, and the CONTRACT parenthetical.
- **packager:**
  - The PR title and body now name both concerns: the `/token` client authentication and the deploy-script secret staging.
  - I squashed the 19 commits, including the fixups and the work a later commit reverted, into 2 commits, one per concern: `e170a95` (secret streaming) and `971365d` (`/token` client authentication, including the deploy-thunk preflight).
  - I pushed with `safe-push-pr-head.sh --mode rewrite`.
  - Before the squash I committed the finished tree as a temporary commit and compared it with the squashed tree; they are identical.

**Should-fix items:**
- **assessor and migrator:** the IdP preflight in `deploy-thunk.sh` now fails closed. A new `preflight_read` function skips the check only on `ResourceNotFoundException` and stops the deploy on any other AWS error. I ran it against stubbed commands and added a test asserting the fail-closed shape. The error message for a mismatch now also mentions the possibility that Cognito masked the secret.
- **migrator:** `pipefail` is now scoped to each secret-fetch pipeline (run in its own subshell) in `deploy-account-endpoint-secret.sh` and `deploy-billing-secrets.sh`. It no longer covers the whole remote script and the helpers it pulls in.

**Local checks:**
- The two affected vitest files pass (64 tests), as do SIWE `node --test` (27), `npm run typecheck` and the esbuild bundle.
- The full vitest run has 1 failure, in `test/git-remote/capability.test.ts`. This PR doesn't touch that file, and CI's `test` job passed.

**Follow-ups (not done):** I did not split the PR into two PRs. Naming both concerns in the title and body was the alternative packager offered. Comment-level suggestions from the panel are also left as they were: PKCE for public clients and consuming the code only after the client check (locksmith), and type-predicate JSDoc (typist).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr94-screen-6098638b-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (3383730 cached reads)
- Output: 20386 tokens
- Cost: $1.9758419999999999
- Wall-clock: 1040s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
