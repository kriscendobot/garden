I fixed two of the three must-fix items from panel round 1 on kriscendobot/minion.town PR #94 and posted the third as a summary comment, but I declined the separate-secret option for the first. CI is green at the new head `80c6ac1`.

**Must-fix items:**
1. **One secret used for two jobs (decomplector #1): declined for this PR, with the reasoning added to the PR body.** The panel gave two options: create a separate client secret (e.g. `minion/github-thunk-client`) or state that sharing is deliberate. I did the second, but as this PR's scope decision, not as the maintainer's choice. The reasoning: Cognito's GitHub IdP already holds `minion/github-oauth-app`, so the fix needs no new production secret. Splitting the secret would mean provisioning one and changing the IdP in production, which I couldn't test, so the PR body names it as the follow-up. A later panel round may still push back on this.
2. **Two readings of the Basic credentials (decomplector #2): fixed in `80c6ac1`.**
   - The shared module `deploy/thunks/shared/client-authentication.cjs` now returns a plain list of candidate readings, and authentication is a search over that list.
   - Both readings (form-decoded and raw) are kept, because Cognito doesn't document which one it sends and I had no live observation to settle it.
   - The departure from RFC 6749 § 2.3.1 is now explained and cited in one helper, `basicReadings`.
   - Both callers are updated: the GitHub Lambda's `index.js` and the SIWE thunk's `openid.js`.
3. **Missing summary comment (scribe): done.** It covers `971365d..80c6ac1`, says it supersedes the earlier summaries, names the live gauntlet, and lists what was addressed and declined: https://github.com/kriscendobot/minion.town/pull/94#issuecomment-6104732810

**Should-fix items I also did:**
- `usesBasicScheme` is now a type guard, and `secretsEqual` and `formUrlDecode` have JSDoc types.
- The "any pair" round-trip test and the raw-pair test are now fast-check property tests, keeping the old hand-picked pairs as examples.
- The PR body now says that `/token` refusing unauthenticated callers is a breaking change.

**Still open (should-fix, listed in the summary comment):**
- The cached GitHub secret in `secret.js` is never invalidated, so rotating it still requires a redeploy.
- Nothing limits repeated Secrets Manager reads while the cache is empty.
- No test covers the Lambda's symlink packaging of the shared module.
- The 401 response still covers only half of RFC 6749 § 5.2.

**Verification:**
- The token-auth vitest file passes (25 tests), the SIWE `node --test` suite passes (28 tests), and `tsc --noEmit` is clean.
- In the full local vitest run, one test failed: `test/git-remote/capability.test.ts` ("propagates a git failure rather than reporting the ref absent"). This PR doesn't touch that file, and I didn't check whether it also fails on the base branch.
- `ci-wait-merge.sh` returned rc 0: all three CI checks passed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr94-screen-9afedef0-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (2064249 cached reads)
- Output: 15228 tokens
- Cost: $1.4383058000000002
- Wall-clock: 899s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
