FIX round 1 for kriscendobot/minion.town PR #94 is done: the panel's one must-fix is applied, the commit is pushed, and CI is green (3/3 checks, `ci-wait-merge` rc 0).

**What changed**: one follow-up commit, `58e69cc`, on `security/token-client-auth-and-secret-umask`. It was pushed with `safe-push-pr-head.sh` in advance mode, moving the head from `5f246ba` to `58e69cc`.
- **Must-fix (stylist):** in `deploy/aws/lambda/github-oidc-thunk/index.js`, `tokenClientAuth` now names the Basic-auth separator index `colonIndex` instead of `i`.
- **Should-fix (stylist), done:** in the same file, `credentials` is now `gitHubCredentials`.
- **Should-fix (warden), done:** `checkClientAndRedirect` in `deploy/thunks/siwe/src/openid.js` used `clientId in clients`, which also matches inherited names. It now checks own properties only, the same way `/token` does, so `/authorize?client_id=constructor` is refused.
- **New test:** `deploy/thunks/siwe/test/oidc-face.test.js` checks that `/authorize` returns 400 `invalid_request` for `constructor`, `toString`, `__proto__` and `hasOwnProperty`.
- **Local runs:** the siwe `npm test` passed 22/22, and `vitest test/github-oidc-thunk-token-auth.test.ts` passed 7/7.

**Left for panel-2 or a follow-up** (should-fix items I did not do in this round):
- **wire-watcher:** the deploy scripts still write secrets to fixed, predictable `/tmp/*.env` paths. If another user creates one of those files first, `umask 077` doesn't protect it. They should use a `mktemp -d` directory instead.
- **wire-watcher:** the SIWE `/token` Basic-auth parser doesn't yet reject a credential with no colon or with bad URL encoding, as the GitHub thunk now does. It also doesn't reject JSON credentials that aren't strings.
- **stylist (optional):** rename `secretsEqual` to `constantTimeSecretsEqual`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr94-gauntlet-20261008-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (842422 cached reads)
- Output: 4665 tokens
- Cost: $0.6555764000000002
- Wall-clock: 367s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
