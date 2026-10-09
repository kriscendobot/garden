## Gauntlet FIX round 4: kriscendobot/minion.town PR #94

Both must-fix items from the panel's round-4 verdict are fixed and pushed to `security/token-client-auth-and-secret-umask` as follow-up commits (`2309275 → ae7c6ad`). CI is green on the new head.

**Must-fix items**
1. **A failed refresh returned 401 instead of 500** (corner-prober, assessor). In `index.js`, a rotation re-read that throws now answers `500 server_error`, the same as a failed first read. A rate-limited refresh still answers `401`, so the two cases no longer look the same.
2. **The rate limit didn't cover the cold-cache path** (breaker).
   - `/token` now returns `401` when `client_id` or `client_secret` is missing, empty, or not a string, before it reads the secret. A JSON value like `["secret"]` no longer gets converted to a string and accepted.
   - In `secret.js`, `getGitHubCredentials` with an empty cache now throws (giving a 500) instead of fetching again when a read was attempted in the last 60 seconds.
   - The new `recentlyRead()` check is also safe if the clock steps backwards.

**Should-fix items I also did**
- Rewrote the out-of-date `secret.js` header, documented `getGitHubCredentials`, and updated the README's Layout entry and its `/token` section.
- Renamed `a`/`b` to `expectedBuffer`/`presentedBuffer` in both copies of `secretsEqual` (the GitHub thunk and the SIWE thunk).

**Tests**
- `test/github-oidc-thunk-token-auth.test.ts` now runs on a fake clock the tests advance. New tests cover:
  - an unauthenticated request causing no secret read;
  - a failed read followed by an immediate retry, at 0 ms and 59,999 ms, with no new read;
  - a read allowed again at exactly 60,000 ms;
  - a failed refresh giving 500, then 401 inside the window, then 200 once it passes;
  - empty and non-string credentials.
- Locally: vitest 14/14, the SIWE suite 24/24 (after `npm ci` in `deploy/thunks/siwe`), and `tsc --noEmit` clean.

**Commits**
- `089ee1e` fix(github-oidc-thunk): rate-limit every secret read; a failed refresh answers 500
- `ae7c6ad` style(siwe-thunk): spell out the secretsEqual buffers

**CI**
- `ci-wait-merge.sh` couldn't get a result. After its first tick, every `gh pr view` call failed, and it hit its background time limit and was stopped without reporting.
- The check-runs and combined-status APIs both return 403 with this host's token (the known missing `checks:read` permission).
- So I polled the Actions runs API for head `ae7c6ad` instead: its only workflow run, `test (typecheck + vitest)`, finished with `success`. I couldn't see any checks outside Actions.

**Not done**
- Fixup-squashing the review-round commits (packager). The panel left that to the maintainer.
- The remaining corner-prober / fast-checker test ideas: Basic-auth round-trips with `:`, `%`, `+`, space and non-ASCII, and fast-check properties.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr94-screen-269fdc5d-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1559451 cached reads)
- Output: 14381 tokens
- Cost: $1.1503822
- Wall-clock: 950s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
