## Fix round 11: kriscendobot/minion.town PR #93

I applied the round-11 panel's must-fix item and pushed it to the PR head. CI is green on the new head `df22056`: the "typecheck + vitest" run passed (https://github.com/kriscendobot/minion.town/actions/runs/38213268332).

**Decomplector (must-fix): GC runs now take one lock instead of guarding against each other.** Commit `1a8ab38`.
- **The lock:** a run that deletes takes an exclusive `gc.lock` file in the store directory, holding its pid. A second such run, for example the timer firing during a manual run, refuses with `GcAlreadyRunningError`. Nothing checks whether the lock's owner is still alive. Read-only audit runs take no lock.
- **Removed:** the check that skipped another running GC's quarantined blobs by pid (`isLiveQuarantine`). Quarantine files are now named `<blobId>.tmp-gc-<random>` with no pid, and a crashed run's quarantine is cleaned up like any other leftover temp file.
- **Excision (moving a vhost record aside):** it still re-reads the record just before the rename and refuses if it changed. It is now a plain rename: the after-rename comparison and the link-back undo are gone. A republish that lands between the re-read and the rename ends up in the `.excised` tombstone file, and the owner's next publish re-installs it.
- **Unchanged:** races between publishers and the GC are still handled by the mtime bump plus the grace period, and blobs are still quarantined before deletion as the approved design requires.
- **Tests:** I replaced the tests for the two removed mechanisms and added tests for a held lock refusing a run, audits ignoring the lock, two overlapping runs, the lock being released after a throw, and cleanup of a crashed run's quarantine. Typecheck and the gateway suite pass locally (207/207).
- **Docs:** the design doc's "Overlapping runs" and excision sections now describe the lock. The GC runbook has a new section, "Clear a stale GC lock".

**Packager (should-fix):**
- **Finding 2 (drive-by renames):** commit `df22056` restores the original `vhostsDir` name in `vhost-table.ts`.
- **Finding 1 (duplicated ACL grant):** I took the reviewer's alternative and documented it rather than consolidating. The PR body now has a "Deploy coupling" section saying both deploy scripts carry the same grant and must stay in sync; `test/gateway/content-gc-deploy.test.ts` already pins both copies. The safety section now mentions the lock.
- **Finding 3 (squash the 40-commit history):** not done. Rewriting the history is a retcon, outside a fix round.

**Follow-ups:**
- **Stale lock after a kill:** a run that is killed outright (an out-of-memory kill under `MemoryMax=256M`, or SIGKILL after a timeout) leaves `gc.lock` behind. Every deleting run then refuses until an operator removes the file, as the new runbook section describes. This is deliberate: refusing is safer than a pid check.
- **Design change for the maintainer:** the decomplector suggested raising the lock with the maintainer as a design amendment. The change is now written into the design doc's text, so the maintainer may want to confirm it at review.
- **This host's CI waiter:** the deployed `ci-wait-merge.sh` here can't read check status with the bot token and just retried for about 10 minutes. I stopped it and re-ran the newer copy from this job's `main2` worktree, which falls back to the Actions runs API. The host's deployed garden needs updating to pick that fix up.
- **History squash:** a retcon job if the maintainer wants it.

My inbox couldn't be checked: the journal clone timed out.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr93-gauntlet-20261010-fix-11.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (3983348 cached reads)
- Output: 27720 tokens
- Cost: $2.2537016
- Wall-clock: 2465s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
