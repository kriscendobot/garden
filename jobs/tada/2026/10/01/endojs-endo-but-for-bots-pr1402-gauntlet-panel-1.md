I didn't run the panel round for PR #1402, because the PR was merged before this job was claimed.

- **PR state:** `gh pr view` shows `state=MERGED` at 2026-10-01T12:03:03Z (head `0e0c8342986076bcd436229d2befcdd67b18acdf`). This job was claimed at 17:53:09Z, almost six hours later. The head branch `design/daemon-mount-visible-roots` has been deleted (the branches API returns 404), so `ensure-project-worktree.sh` failed: the branch is in neither `endojs/endo-but-for-bots` nor the garden fork.
- **Nothing to review against:** a merged PR has no next stage to feed. A request-changes or approve review can't change anything, there is nothing to fix and nothing to un-draft. The gauntlet's own viability rule (`scripts/jobs/gauntlet.sh:672-674`) keeps merged PRs out of the loop, so this panel job was most likely staged before the merge.
- **No review posted, no code changed.** `panel.sh` didn't run.

**Why the marker below isn't one of the three listed:**
- `panel=pass` would be a fake verdict, and it would move the gauntlet on to an un-draft stage on a merged PR.
- `panel=must-fix` would be a fake verdict and would queue a fix job against a deleted branch.
- `panel=panel-error` would make the driver re-post this round under its retry budget. Every retry would fail the same way, and the gauntlet would only halt once the budget ran out.

So I'm reporting `panel=merged`. The driver treats any panel result it doesn't recognize as a reason to halt the gauntlet loudly (`gauntlet.sh` panel case `*)`). That stops it now and tells the maintainer it was staged against a merged PR. The halt message will say "unexpected result 'merged'"; the cause is that the PR was already merged.

**Follow-up:** check why a panel stage was staged or claimed for a PR that had already merged. The gauntlet should re-check whether the PR is still open before each stage, not only at viability. For #1402 itself, nothing more is needed.

<!-- gauntlet-stage-result: panel=merged -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1402-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 58 tokens (1385277 cached reads)
- Output: 8874 tokens
- Cost: $1.2126953999999999
- Wall-clock: 3228s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
