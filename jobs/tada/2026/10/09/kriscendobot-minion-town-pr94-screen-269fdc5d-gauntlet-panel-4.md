Panel round 4 on kriscendobot/minion.town#94 (head `2309275`, base `main-50aa690`) ended in **must-fix**. `panel.sh` exited 0.

**What I did**
- Made an isolated project checkout of `security/token-client-auth-and-secret-umask` and ran `panel.sh` in single-round mode against `origin/main-50aa690`.
- All 33 seats returned a verdict: 1 request-changes (breaker), 15 comment-only and 17 approve.
- Posted the verdict to the PR: https://github.com/kriscendobot/minion.town/pull/94#pullrequestreview-5475938497. GitHub refused a request-changes review because the bot authored the PR, so it went up as a comment review. It starts with `<!-- garden-panel-verdict -->` and says the verdict is must-fix, the same way earlier rounds were posted.
- The full aggregate is about 86 KB, which is over GitHub's review-body limit. The review therefore includes the full reports only for breaker, corner-prober and assessor, with a summary of the other seats.

**Must-fix items for the next fix round**
1. **A failed refresh returns 401 instead of 500.** In the github-oidc-thunk `/token` handler, a failed `refreshGitHubCredentials()` read is swallowed, so the client gets `401 invalid_client`. The README and `CONTRACT.md` say a Secrets Manager failure returns `500 server_error`. corner-prober marked this `must-fix-loop`, and assessor raised the same issue as should-fix.
2. **The Secrets Manager rate limit doesn't cover the cold-cache path** (breaker). `getGitHubCredentials` runs before the handler checks whether credentials were sent. While the secret can't be read and the cache stays empty, every unauthenticated `POST /token` triggers its own `GetSecretValue` call.

The should-fix items are summarized in the review: stale comments in `secret.js` and the README, renaming `a`/`b` in `secretsEqual`, squashing the rename commits, and adding tests for the rate-limit boundaries and for non-string `client_id`/`client_secret` values (a JSON array containing the secret currently matches).

**Follow-ups**
- The PR is already out of draft (`isDraft: false`), even though a must-fix gauntlet is still running on it.
- I couldn't drain my inbox: its journal clone timed out (clone rc=124, skipped as offline). This is the same slow journal clone on this host that's already in memory.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr94-screen-269fdc5d-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1047170 cached reads)
- Output: 7382 tokens
- Cost: $0.8761060000000002
- Wall-clock: 591s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
