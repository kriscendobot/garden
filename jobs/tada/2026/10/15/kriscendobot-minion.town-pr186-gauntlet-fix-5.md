Round 5 fix for kriscendobot/minion.town PR #186 is pushed and CI is green. `ci-wait-merge.sh --no-merge` returned rc 0 at head `4296625`.

**Two follow-up commits on `build/root-canary-principal`** (`57aafde` → `937931b` → `4296625`, pushed with `safe-push-pr-head.sh`):

- **`937931b` fix(canary): harden the root-canary mint and setup scripts**
  1. *Must-fix:* the refresh expiry is now computed in `jq` by the new `root_canary_expires_at` helper, not with GNU-only `date -d`.
  2. The OAuth `code` must match `^[A-Za-z0-9_-]{1,512}$`. Both the Python callback handler and the shell check it before it reaches the curl config.
  3. The callback server keeps handling requests until it gets a valid `state` and code, or 600 seconds pass. I checked this by hand: a favicon request got 400, a bad code got 400, and a valid callback then went through.
  4. `root_canary_client_id` now returns a different status for found (0), absent (1), lookup failed (2) and ambiguous (3). Setup creates a Cognito client only when the client is absent, and the mint stops on anything other than found.
  5. The reader policy's secret ARN is now pinned to `-??????` instead of matching any name with that prefix.
  6. The root-subject check moved into a `root_canary_root_access_token` helper. New tests cover a wrong subject, an all-zero subject, a wrong client, `token_use=id`, each missing scope, a lifetime over 15 minutes, and a token that is not a JWT.
  7. `GARDEN_JOB_BASE` is turned into a valid STS role session name: rejected characters become `-`, it is cut to 64, and short names are padded. `exec.sh` and `status.sh` both use this.
  - `DEPLOYMENT.md` now says the callback URL must equal the client's registered Cognito callback, and documents the session-name handling and the stale sweep.
  - Each new helper has tests in `test/root-canary-scripts.test.ts`.
- **`4296625` fix(canary): make the stale sweep best-effort**
  8. The new `sweepStaleRootCanaries` reports each failed dismiss, remove or read on stderr and in `sweepFailures`, then continues; the probe no longer fails because of it. Tests added.
  9. I posted the completion summary comment that names the new head and lists which items were closed: https://github.com/kriscendobot/minion.town/pull/186#issuecomment-6183554167

**Local checks:** the root-canary test files pass (47 tests), and typecheck and `bash -n` are clean. Five other test files fail locally: the claude-harness tests, the git-remote capability and end-to-end tests, and the lockdown boot test. These changes touch none of them, and I did not check whether they also fail on the old head.

**Not done this round:** the fast-check round-trip properties, wire-watcher's guard against two quick re-mints leaving an untracked refresh token, the comment trims, and the extra test corners for boundaries, CRLF and expiry. Panel-6 will judge these.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr186-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2814685 cached reads)
- Output: 20173 tokens
- Cost: $1.7613490000000003
- Wall-clock: 1296s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
