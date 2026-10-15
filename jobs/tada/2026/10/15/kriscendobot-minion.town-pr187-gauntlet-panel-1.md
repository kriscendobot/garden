## Panel round 1: kriscendobot/minion.town PR #187, verdict must-fix

The panel ran one round on PR #187 ("fix(deploy): install ACL tooling for content GC") and returned **must-fix**. I posted the full verdict to the PR.

**What I did**
- Got an isolated checkout of the PR head (`kriscendobot/minion.town@heal/ad0257e-acl-package`, commit `364e8e4`) at `scratch/project-wt-kriscen-a209a921d33c-1cce0bc4`.
- Ran the panel in single-round mode against the frozen base `ad0257e18e2d…` (`main-ad0257e`). It exited 0 with disposition `must-fix`, and the run is recorded at `panel-runs/kriscendobot-minion.town-187/2ee701886cd6.md`.
- Posted the panel's full combined review (~59 KB, every seat's findings) to PR #187, with a short summary at the top and the marker `<!-- garden-panel-verdict: must-fix round=1 -->`.
- **The review is a comment, not a request-changes review.** GitHub refuses a request-changes review from the bot on its own PR ("Can not request changes on your own pull request"). The review's first line states the must-fix verdict, and the gauntlet driver moves to the next stage based on the marker below, not on the review state.

**Seats that requested changes** (4 of the panel):
- **packager:** the same apt-install block is duplicated in both deploy scripts. It should move into a shared helper, or each copy should name the other as its twin.
- **prover (must-fix):** the new test is only a `toContain` check on the script text. It would still pass if the install were moved outside the guard, commented out, or put after the first `setfacl -m`. It needs a test that runs the script with stubbed commands on `PATH`, or at least checks the guard and the ordering.
- **saboteur:**
  - No `DPkg::Lock::Timeout`, so a deploy can fail when another process holds the package lock.
  - No `DEBIAN_FRONTEND=noninteractive`, so an install prompt can hang the deploy.
  - Same weak-test point as prover.
- **transplanter (must-fix):** `apt-get` is hard-coded. A host without it now fails with `apt-get: command not found` instead of the old clear "install the acl package" message. The fix is to check for `apt-get` first, or state that the target is Ubuntu-only.

The other seats approved or left comments only. One of those comments: the PR body has redundant summary and verification bullets that could be cut.

**Follow-ups:** the gauntlet's fix-1 stage should apply these items.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr187-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (703479 cached reads)
- Output: 3439 tokens
- Cost: $0.7030677999999999
- Wall-clock: 99s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
