Fix round 5 on PR #94 is done: I removed the mechanism the panel kept flagging, pushed it, and CI is green (3 of 3 checks passed; `ci-wait-merge` exited 0).

**What the panel asked:** the round-5 verdict listed no specific items. It said must-fix findings kept recurring on one mechanism and asked whether that mechanism was needed at all. That mechanism is the secret re-read in the GitHub OIDC thunk (`deploy/aws/lambda/github-oidc-thunk/`). When a client presented credentials that didn't match the cached ones, the thunk read the secret again in case it had been rotated, with a limit of one read a minute. Rounds 3 and 4 both raised must-fix issues there (how errors and the rate limit behaved).

**What I changed:** I decided the re-read isn't needed and took it out. Commit `a015aab` was pushed to `security/token-client-auth-and-secret-umask` with `safe-push-pr-head.sh`.
- **`src/secret.js`** is back to the version on `main`: once a read succeeds, the credentials are cached for the life of the warm container. A failed read isn't cached, so the next request tries again. The comment now says `/token` answers 500.
- **`index.js`** no longer has the re-read branch. `/token` compares the presented credentials once, in constant time. Missing credentials still get 401 without touching Secrets Manager, a Secrets Manager failure gets 500, and wrong credentials get 401.
- **`README.md`** now says a rotated secret takes effect only once warm containers recycle, for example after a function configuration update.
- **Tests:** I removed the faked clock, the rate-limit tests and the rotation tests, and added a test that the read succeeds once an outage clears. `npx vitest run test/github-oidc-thunk-token-auth.test.ts` passes locally (11 tests).

**Decision for the maintainer:** a secret rotation no longer reaches warm containers on its own. Unless the secret deploy scripts already update the function, rotating the secret now also needs that update step to recycle containers.

The driver can now re-post panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr94-screen-e8518a2f-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 34 tokens (1058063 cached reads)
- Output: 6489 tokens
- Cost: $1.2125816
- Wall-clock: 836s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
