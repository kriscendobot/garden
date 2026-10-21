Fix round 6 for kriscendobot/minion.town#210 is pushed and CI is green, but the decomplector's two must-fix items are not fixed. They need a redesign decision from the maintainer, so I sent them the question. There was no pre-pass block for this round, so I worked from the latest panel review (#5598603906, 2026-10-21T10:55Z).

**What I fixed**
- **Migrator must-fix (`25455f3`):** `set-account-role.sh list` now leaves out the guest-agent activity rows (`iss = urn:minion-town:guest-agent-activity`), since they are not accounts. `DEPLOYMENT.md` now says so under Retention. I looked for other code that reads the whole table and found only the waitlist store, which uses a different table.
- **Pruner items:**
  - **#1, #4–#6 (`67f2856`):** the deploy-script header now points to the runbook instead of repeating it, and its "Release ordering" comment is gone. I deleted the redundant granularity JSDoc and shortened the `touch` and web-seam JSDoc.
  - **#2:** the PR body is down from 366 to 177 words and points to the runbook.
  - **#3:** this was already done at `fa7781e`, so nothing changed.
- **Checks:** `tsc --noEmit` is clean, and the activity and guest-web tests pass locally (38 passed, 3 skipped).
- **Push and CI:** pushed with `safe-push-pr-head.sh` (`fa7781e` → `67f2856`). `ci-wait-merge.sh` returned rc 0 (green). The first watcher run was killed by the background time limit, so I restarted it with a 2400 s deadline. I posted the dispositions as a PR comment (issuecomment-6314916314).

**What's still open**
- **Decomplector must-fix, both items.** The maintainer's #199 ask was "based on any use of the agent/guest exo", but the PR stamps at the app's two entry points and stores the stamps in the shared accounts table. A guest used directly through its OCapN locator is never stamped. The juror said to get maintainer confirmation before another round, so I sent the maintainer three options:
  1. Record activity inside the daemon, on the guest formula. This matches the #199 ask but is the biggest rewrite.
  2. Move the stamps to a dedicated table where the app can only update.
  3. Keep the current design and accept that some guest use goes unstamped.
- **Next round:** panel-7 will likely raise these two items again until the maintainer answers. Their reply will come to this job's inbox; if it arrives after this job closes, it becomes a new job.
- **Suggestions from jurors, not acted on:** the migrator suggested one loud log line on the first `AccessDeniedException`, and the assessor suggested a backoff after a failed write. The decomplector also asked (should-fix) that the PR say how a reader will use these rows. Its X-decomplector probe also matched a test-only `.listen(` call, a false positive.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr210-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1860889 cached reads)
- Output: 11159 tokens
- Cost: $1.1785098
- Wall-clock: 1856s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
