Fix round 1 for kriscendobot/minion.town PR #94 is done: I fixed both of the panel's must-fix items in commit `50620ce`, pushed it to the PR head, and CI is green on that commit (3 of 3 checks; the CI wait script exited 0).

**Must-fix 1: callers that don't authenticate now get 401.** The GitHub OIDC thunk's `/token` endpoint now rejects callers that don't present the GitHub OAuth App credentials, and the PR didn't say so. Cognito is the only expected caller. Its GitHub login setup is registered by `deploy-cognito-github-idp.sh` with credentials read from the same `minion/github-oauth-app` secret the thunk now checks against. A Cognito set up by that script should therefore keep working. I added a rollout section to the thunk README and the PR body:
1. Rerun `deploy-cognito-github-idp.sh`.
2. Run `deploy-thunk.sh`.
3. Sign in once through GitHub. A `401 invalid_client` in the thunk's logs means Cognito's credentials and the secret disagree, so rerun step 1.

The README also gives the same steps for rotating the secret.

**Must-fix 2: the credential-checking code was copied in two places.** The GitHub thunk and the SIWE thunk each had their own copy, and the copies had already drifted apart.
- There is now one module, `deploy/aws/lambda/github-oidc-thunk/src/client-authentication.js`, which both thunks use.
- It is CommonJS so the GitHub thunk, which is zipped with no install step, carries it in its `src/` folder. The SIWE thunk imports it by relative path, and its esbuild bundle builds with it.
- The rules are now decided once: a public client may leave out `client_secret` (treated as an empty secret), credentials must be strings, and a client name like `__proto__` can't match.
- The GitHub thunk still rejects an empty secret before it reads Secrets Manager.

**Smaller changes:**
- A JSON body of `null` now gets `401` instead of `400`.
- `deploy/thunks/CONTRACT.md` now says public clients may leave out `client_secret`.
- New tests cover Basic-header encode/decode, the public-client rule, and rejection of names like `__proto__`.
- I rewrote the out-of-date PR body and posted a fix summary comment covering this commit and the earlier unsummarized `6098638`: https://github.com/kriscendobot/minion.town/pull/94#issuecomment-6094423213

**Local checks:** the thunk auth tests pass (17/17), the SIWE tests pass (27/27), `tsc --noEmit` is clean, and the SIWE bundle builds. The full vitest suite had one failure, in `test/git-remote/capability.test.ts`. This PR doesn't touch that code, but I didn't confirm it also fails without my change.

**Not done (should-fix items, listed in the PR comment):**
- Giving Cognito its own secret instead of the GitHub app's. This needs a new secret and a Cognito change, so it is a separate follow-up.
- A shared shell helper for the three deploy scripts that install secrets.
- Moving the credential cache out of the auth check.

I did not re-run the panel; the gauntlet driver posts round 2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr94-screen-6098638b-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2807088 cached reads)
- Output: 18716 tokens
- Cost: $1.6882176
- Wall-clock: 939s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
