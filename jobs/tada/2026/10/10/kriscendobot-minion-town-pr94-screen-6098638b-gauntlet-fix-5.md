Fix round 5 for kriscendobot/minion.town PR #94: I applied all three round-5 must-fix items, pushed, and CI is green (`ci-wait-merge.sh` rc=0, 3 of 3 checks passed).

**Pushed to the PR head** (`971365d..9afedef`, branch `security/token-client-auth-and-secret-umask`) as two follow-up commits:

1. **`3735878`: credentials are validated once, and the shared module moved** (decomplector items 1 and 2, curator).
   - `presentedClientCredentials` now returns a validated `ClientCredentials` value or `undefined`. A predicate checks it once while parsing, so `clientAuthenticated` only compares. `wellFormedClientCredentials` is no longer exported.
   - The GitHub Lambda pre-check is now `!presented || !presented.clientSecret`. SIWE checks `!presented ||` before it authenticates.
   - The module moved to `deploy/thunks/shared/client-authentication.cjs`. SIWE imports it directly, and its esbuild bundle builds.
   - The Lambda reaches the module through a tracked symlink at `src/client-authentication.cjs`. The `deploy-thunk.sh` zip step follows the link, and I checked that the archive holds the real file and loads.
   - New tests cover rejection at parse time, and that the Lambda's symlink and the shared file are the same module.
2. **`9afedef`: one `install_secret` helper** (decomplector item 3, assessor).
   - New `deploy/aws/scripts/lib/install-secret.sh` replaces the five pasted fetch / install `.new` / `mv` blocks. It is inlined via `$INSTALL_SECRET` from `common.sh`, the same way `$CADDY_ENVIRONMENT_SYNC` is.
   - pipefail is scoped to the helper's subshell, so `deploy-oauth2-proxy.sh` no longer switches it on and off around a block.
   - On any failure, including an empty result, the live file is left untouched and `.new` is deleted.
   - New behavioral tests run the helper with `sudo` stubbed: success with the right mode, a fetch that fails mid-stream, and an empty result. The static checks on the deploy scripts were updated to match.

**Local checks:**
- The two touched vitest files pass (69 tests). The SIWE `node --test` suite passes (27), and `npm run typecheck` is clean.
- The full `npm test` has one failure, in `test/git-remote/capability.test.ts` ("propagates a git failure rather than reporting the ref absent"). That file is outside this diff, and the same suite passed in CI.

**Not done (should-fix, not must-fix):**
- The prover's point that the Lambda outage tests depend on test order.
- The migrator's worry that the step-0 preflight fails every deploy if Cognito hides `client_secret`.

`shellcheck` warns that `install-secret.sh` has no shebang. The file is inlined into SSM scripts, not run directly.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr94-screen-6098638b-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2523509 cached reads)
- Output: 22565 tokens
- Cost: $1.8218258
- Wall-clock: 2017s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
