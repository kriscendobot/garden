**Fix round 1 for kriscendobot/minion.town PR #200: CI never started within the 1-hour deadline, so the result is still-pending.**

The fixes are pushed: the PR head moved from `bfd0d8b` to `c4ebb83`. All three CI checks (`test`, `Claude harness` amd64 and arm64) were still queued at the deadline. The minion.town repo has one self-hosted runner. It was online and busy for the whole hour, with jobs from other branches and the `main` prod probes queued ahead of this one. The final `ci-wait-merge.sh --no-merge` call returned rc 4 (pending=3/3). My polling also used up the bot's GitHub API rate limit (HTTP 403 at 12:10 UTC), so I stopped. I did not re-run the panel.

**What I fixed, against the panel's round-1 findings:**
- **Deletion order (corner-prober must-fix, wire-watcher should-fix):** in `DELETE /api/guest`, the guest is now added to the deleted-guests list before its recovery bonds are removed.
  - If writing that list fails, nothing is deleted: the guest stays live with its bonds and the error is audited.
  - If bond removal fails afterwards, the guest is still deleted and refused on every route. The leftover bond can only recover a credential that is already refused, and the audit records `bondCleanup: "failed"`.
  - I rewrote the existing "bonds cannot be removed" test to match and added a test for the failed-list-write case.
- **Deploy order (migrator must-fix):** `DEPLOYMENT.md` now says to re-run `deploy-accounts-store.sh` before deploying this app build, and what goes wrong if the app goes first. The script now also waits for the new index to become ACTIVE, which closes the migrator's should-fix that it only waited for the table.
- **Comment cuts (pruner):** I trimmed the `settings.js` header and deleted its four section-label comments, the duplicate coupon-count comment in `http.ts`, and the JSDoc lines that only restated their signatures.
- **PR body (pruner):** cut from 1676 to 729 words. I kept the data-removal table, the choices for the maintainer to veto, and the deploy notes. The table is most of the remaining length.
- **Extra corner tests:** only the exact confirmation text deletes (case, whitespace, non-string and non-JSON bodies are all refused), and a crash that tears the last line of the deleted-guests file keeps every complete line.

The changes are in three commits: the deletion-order fix with its tests, the deploy doc and script, and the comment cuts. Locally, typecheck is clean and the 15 deletion tests, the settings-menu tests and the DynamoDB bond tests pass. The full suite has one failure, in `test/git-remote/capability.test.ts`. The PR body already reports that failure as environmental (the host's git wrapper), and it is outside this change.

I did not address the other comment-level panel items: concurrent deletes, DynamoDB paging edge cases, multi-name daemon results, the invitation-count edge values, and key rotation.

The driver should re-post this fix stage so CI can be watched again once the runner reaches this PR.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr200-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2938694 cached reads)
- Output: 14867 tokens
- Cost: $1.6544067999999998
- Wall-clock: 3749s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
