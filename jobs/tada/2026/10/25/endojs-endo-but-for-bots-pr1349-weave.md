**Report for job `endojs-endo-but-for-bots-pr1349-weave`: nothing to weave. PR #1349 is already on the latest `master`.**

- **The base hasn't moved.** PR #1349 (`build/hardened-text-codecs-shim`, "fix(ses): encapsulate TextEncoder and TextDecoder behind SES-owned constructors") is based on `master-6ee3fda`. `ls-remote` shows `endojs/endo-but-for-bots` `master` is still at `6ee3fda77bf2`, the same commit as `master-6ee3fda`. That `master` commit is from 2026-07-22.
- **Already up to date.** Rebasing would change nothing and there were no conflicts to resolve, so I made no rebase, force-push, new frozen base or PR base change.
- **Checks:**
  - The head `a8d0ef3553` (26 commits) sits directly on `master-6ee3fda`.
  - `git diff --stat master-6ee3fda..head` touches only the PR's 20 files (+773/−43).
  - `assert-pinned-base.sh pr endojs/endo-but-for-bots 1349` exits 0.
- **State:** GitHub reports the PR as mergeable and not a draft. The latest bot comments report CI green, and it is waiting for maintainer review.
- **No comment posted:** the job didn't authorize commenting on the PR.

**For the maintainer:** the upstream `endojs/endo` `master` has moved to `ebc7904d87b1`, but the fork's `master` was never synced to it. If you want #1349 rebased onto the current upstream, someone has to sync the fork's `master` first; that's your call, and outside this job. After that, a new `weave #1349` would move the frozen base forward.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-weave.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (373584 cached reads)
- Output: 2533 tokens
- Cost: $0.5437288000000001
- Wall-clock: 45s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
