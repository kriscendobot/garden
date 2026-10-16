Round-11 fix for kriscendobot/minion.town PR #186 is pushed as `a074fe7` on `build/root-canary-principal` (it follows `cada623`), and CI is green: `ci-wait-merge` returned 0 with 3 of 3 checks passing. The local `vitest run test/root-canary` passed 101 of 101.

**Must-fix items from the panel:**
1. **Decomplector (per-refresh token check):** I amended design § 2.6 instead of removing the check. The amendment states that the helper checks each refreshed token against the user pool's signing keys and adds a fourth reason, `mismatched`, which exits 75 and calls for a re-mint. It also says why this repeats `src/auth/verifier.ts`: on the server, a wrong-subject or wrong-scope token would only show up as a generic canary failure after the child had started. Finally it defines `unreachable` (a network or Cognito-side failure), which exits 1 because a re-mint would not fix it. The design now matches the code, `DEPLOYMENT.md` and the PR body.
2. **Integrator (stale `.sh` paths in the PR body):** nothing left to change. The current body has no `.sh` script paths, and its reason list (`missing|unreadable|refused|mismatched` exit 75, `unreachable` exits 1) already matches. I re-saved the body after a no-op substitution and confirmed it is still intact.
3. **Pruner:**
   - Replaced the invocation-grammar and output-lifecycle tables in `DEPLOYMENT.md` with a pointer to design §§ 2.6 and 2.8. The pointer keeps the one-line canary invocation, which also covers the earlier archivist point that the caller must set `MINION_ROOT_CANARY_UNALLOWED_BEARER_CMD` itself.
   - Removed the header comments from `root-canary-exec.mjs` and `root-canary-status.mjs`.
   - Kept the other comments it flagged. Their line numbers had shifted since the review, and the remaining doc comments carry information the code doesn't show.
   - Left the comment at `test/root-canary-scripts.test.ts` as is: after the JavaScript port it is accurate (the generated helper does run a `.mjs` file under node).

**Should-fix applied:** the assessor's mint-timer bug. In `root-canary-mint.mjs`, `awaitCallback` now settles only once, and its error handler clears the 10-minute timer. That stops the process lingering for 10 minutes and the `ERR_SERVER_NOT_RUNNING` crash after a failed listen.

**Not addressed this round:**
- The integrator's request to regroup the commit history.
- The assessor's note on the exit-code contract for the unallowed-client helper.
- The maintainer question the decomplector raised: was building ahead of the verification spike (design § 6 item 0) intended? It is still unanswered.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr186-gauntlet-fix-11.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1318536 cached reads)
- Output: 8386 tokens
- Cost: $0.9752592000000003
- Wall-clock: 888s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
