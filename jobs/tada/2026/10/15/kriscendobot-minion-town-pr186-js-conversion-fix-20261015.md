I didn't push anything: fix round 10 had already done the work this job asks for, and the review is now running again as panel round 11.

This job was posted from the panel-10 verdict, which reviewed head `d6f4e64`. Fix round 10 then pushed `1c7abcd` (journal `jobs/tada/2026/10/15/kriscendobot-minion.town-pr186-gauntlet-fix-10.md`), and that commit already does all four things. A fifth round of edits would just churn a head that is already in the right shape. I checked each item against `1c7abcd` in an isolated checkout:

1. **Shell to JavaScript:** No `.sh` or inline `node -e` is left in the canary path. The seven `root-canary-*.sh` scripts are now `.mjs` entry points that share `deploy/aws/scripts/root-canary-common.mjs`. Token checks use `jose`'s `jwtVerify` against the pool's signing keys, and the token requests use `fetch`. The only `.sh` mentions left in the canary files are two comments in `root-canary-common.mjs` and a table row in the design doc for an unrelated script.
2. **Helper output checked before use:** `unallowedTokenProblem` (`deploy/probe/root-canary.mjs:70`) runs before the gate at line 221. It rejects a token that is not a JWT, names another issuer, is not an access token, has expired, names no client, or comes from the root canary's own client. An empty or malformed token now fails the gate.
3. **Gate actually tests the allowlist:** `unallowedClientIsRejected` (`root-canary.mjs:88`) passes only on a 401 whose `www-authenticate` header contains "is not in the allowed set". That is the server's allowlist refusal in `src/auth/verifier.ts:81`, so a 401 for any other reason fails.
4. **`DEPLOYMENT.md` isolation claims:** The doc now says `env -i` only stops a child's environment from redirecting the secret by accident. It states plainly that this is not a boundary against a hostile child running as the same user.

**CI:** The PR is still a draft at `1c7abcdb`, and both `test (typecheck + vitest)` runs on that commit passed. I read them from the Actions runs API because the bot's token can't read the PR's checks list.

**Gauntlet resumed:** I ran `gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr186-gauntlet panel --add-rounds 2`. It reports panel round 11 in flight on `1c7abcd`. The gauntlet and the proxy screen still own un-drafting; I didn't un-draft or merge anything.

**Follow-ups:** Round 10 left two gaps that still apply:
- `root-canary-mint.mjs` and the full `deploy-client` provisioning path have no end-to-end test, because they need real AWS and Cognito.
- Revoking every stored token version assumes Cognito accepts a revoke on a token that is already revoked. The revocation drill should confirm that.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr186-js-conversion-fix-20261015.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (513229 cached reads)
- Output: 3508 tokens
- Cost: $0.5879578
- Wall-clock: 151s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
