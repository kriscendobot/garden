I got PR #1590's CI back to green by rerunning one failed job, with no code change. GitHub now reports the PR's merge state as CLEAN, which clears the way for #1592.

- **What failed:** In run 43609796328, the `test (24.x, ubuntu-latest)` job failed on one test in `@endo/sandbox`: `bwrap › bwrap timeout and repeated cancellation reap process groups` ("process group 46796 survived bounded cleanup").
- **Why it isn't this PR's fault:** #1590 only changes `cli`, `daemon`, the designs docs, changesets and `yarn.lock`; it doesn't touch `packages/sandbox`. This is a known timing flake with an open fix in endojs/endo-but-for-bots#1591 ("sweep the bwrap process group when the leader exits"). The one other failing run, on the earlier head `3aa198e2`, is out of date now.
- **What I did:** Ran `gh run rerun --failed` on that run. Attempt 2 finished with success on the same head, `8d98a2e8`.
- **Leftover red entries:** `gh pr checks` still lists 4 fails (`cover`, `test`, `test-async-hooks`, `viable-release`). They all come from a duplicate CI run, 43609796147, that GitHub cancelled when the post-weave push started a second run. The status rollup no longer counts any check as failed.

Follow-ups:
- #1592 can go ahead.
- Landing #1591 should stop this bwrap flake from turning other PRs red.
- #1590 is still a draft and is waiting on its normal gauntlet/review.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1590.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 54 tokens (1893726 cached reads)
- Output: 8581 tokens
- Cost: $1.6648931999999999
- Wall-clock: 4233s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
