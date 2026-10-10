Fix round 3 on kriscendobot/minion.town PR #94 is pushed, and CI is green on the new head `adfaefd`.

**What the panel asked for:** the round-3 verdict at head `34f8606` had one seat requesting changes (migrator), with two must-fix items. Both are about rolling the change out without breaking existing `/token` callers.

**What I changed:** two follow-up commits on top of `34f8606`, pushed with `safe-push-pr-head.sh`.

1. **`9a19ebd` docs(siwe-thunk)** (must-fix 1): `deploy/thunks/siwe/README.md` gets a new "`/token` client authentication" section and a "Rollout: the caller's configuration lands first" subsection.
   - It lists the calls that used to be accepted and are now refused:
     - a `+` in a Basic header now decodes to a space;
     - a non-string or empty `client_id`, or a non-string `client_secret`, is rejected;
     - a Basic header with no colon is rejected.
   - It says a secret with `+` or other reserved characters must be sent percent-encoded.
   - It notes that the deployed Cognito SIWE relying party is unaffected, because `deploy-siwe-thunk.sh` mints its secret as base64url, which never contains `+`.
2. **`adfaefd` fix(deploy-thunk)** (must-fix 2): `deploy/aws/scripts/deploy-thunk.sh` now checks the rollout order itself instead of relying on README prose.
   - **Before deploying (step 0):** it compares the client ID and secret held by Cognito's GitHub identity provider with the `minion/github-oauth-app` secret. On a mismatch it stops and says to run `deploy-cognito-github-idp.sh` first. If either the secret or the identity provider doesn't exist yet, it logs that and continues. `SKIP_IDP_PREFLIGHT=1` overrides the check.
   - **After deploying (step 6):** it expects a `401` from an unauthenticated `/token` call and stops otherwise.
   - The GitHub thunk README's rollout step 2 now mentions both checks.
   - Two script-text tests in `test/github-oidc-thunk-token-auth.test.ts` assert that both checks are present and in the right order. That file passes locally (19/19).

As the verdict directed, I made these fixes in the README and `deploy-thunk.sh` and did not restore the migration paragraph to the PR body.

**CI:** `ci-wait-merge.sh` returned 0. `test`, `Claude harness (amd64)` and `Claude harness (arm64)` all passed.

**Not done:**
- The new checks in `deploy-thunk.sh` have not been run against AWS; only the script-text tests and `bash -n` passed.
- I didn't address migrator's three should-fix items: the remaining 400-vs-500 `server_error` mismatch, adding the rotation step to a runbook, and confirming the bundling of the cross-tree import. I did check the last one: `deploy-siwe-thunk.sh` builds the SIWE thunk with esbuild, which should bundle the relative import.
- The PR body is still 343 words, over the panel's 300-word concision limit. That was not a must-fix item.
- Panel round 4 is the driver's next step.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr94-screen-6098638b-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1774335 cached reads)
- Output: 10300 tokens
- Cost: $1.219755
- Wall-clock: 843s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
