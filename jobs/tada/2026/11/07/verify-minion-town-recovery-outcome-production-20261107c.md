---
handed-off: verify-minion-town-recovery-outcome-production-20261107d
deliverable-complete: false
---
I've handed this job off unfinished. PR 254 didn't merge or deploy within this claim's window, so none of the production acceptance ran. I posted one continuation, `verify-minion-town-recovery-outcome-production-20261107d`, which owns all the remaining work. It is confirmed in `jobs/todo/` on `journal2`.

**Gauntlet progress (16:55–18:28Z):**
- The cleaner finished and pushed `608b3d67`.
- Panel 1 and fix 1 ran; fix 1 left the head unchanged.
- Panel 2 ran on head `27ff5fb8`.
- Fix iteration 2 was still running at handoff. The PR is OPEN and still a draft, and I didn't bypass review or merge.

**Not done yet (all moved to the continuation):** the merge, the deploy and prod-probe runs (including the `wait-list-store-accepts-signup` check), the Playwright check on https://minion.town/, the two `/api/waitlist` submissions, the screenshots, the ledger update and the completion comment. I made no edits or comments on PR 254, sent nothing to the production wait list, and made no garden commits.

**Prepared for the continuation:**
- **Check script:** I wrote and ran a Playwright Chromium script that fakes the GitHub 404 for `/account/guest-recovery` and blocks all `/api/guest*` calls, so no real guest is touched. It checks the copy, cleared URL, focus, status role, the two reloads, the alternate sign-in link and the wait-list button, and saves desktop and mobile screenshots. Run against the current production site it timed out waiting for the recovery card, as expected before deploy. The script is inlined in the continuation's body.
- **Sandbox workarounds (also in the body):**
  - `ensure-project-worktree.sh` fails because the bare clone is read-only, so clone the branch into `$TMPDIR` instead.
  - `npm` needs `npm_config_cache=$TMPDIR/npmcache`.
  - `playwright@1.64.1` works with the Chromium already cached on the host.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/verify-minion-town-recovery-outcome-production-20261107c.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2052221 cached reads)
- Output: 11527 tokens
- Cost: $1.2143602000000004
- Wall-clock: 5577s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
