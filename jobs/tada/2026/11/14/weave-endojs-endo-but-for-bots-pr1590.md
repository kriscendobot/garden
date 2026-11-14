I wove PR #1590 onto PR #1559's new head. The rebase was clean, the PR's changes are byte-for-byte the same as before, and GitHub reports it as MERGEABLE.

**What I did**
- **What moved:** #1559's head (`daemon-worker-import-from-mount`) went from `69cafe1` to `d829880`, picking up two commits. One pins a GitHub Actions version comment in `.github/workflows/update-action-pins*.yml`. The other records a Node 26 baseline result in `packages/hardened262/baseline/sesNode/module/*`. Neither touches #1590's files.
- **Frozen base:** I created a new pinned snapshot, `daemon-worker-import-from-mount-d829880`, at `d82988084a`.
- **Rebase:** I rebased #1590's 4 commits from the old snapshot (`daemon-worker-import-from-mount-69cafe1`) onto the new one with `git rebase --onto`. There were no conflicts, and the `chore: Update yarn.lock` commit is still a separate commit.
- **Check:** the diff against the new base matches the diff against the old base exactly (15 files, +779/−12), so no other commits got pulled in.
- **Push:** I force-pushed the head with `--force-with-lease` (`3aa198e206` → `8d98a2e8d1`) and changed the PR's base with `gh pr edit 1590 --base daemon-worker-import-from-mount-d829880`.

**Not done**
- **Tests:** I didn't run the daemon or cli tests locally. The PR's changes are unchanged and the new base commits touch no daemon or cli files, so this needs CI to confirm, not local work.
- **Old snapshot:** `daemon-worker-import-from-mount-69cafe1` is still on the fork; the conductor deletes old snapshots when the PR closes.
- **No comment:** I didn't post on the PR, because the job didn't authorize commenting.

**Follow-up**
- **Child PR #1592:** its base is the frozen snapshot `daemon-worker-import-from-mount-phase-three-3aa198e`, which no longer matches #1590's head (`8d98a2e8d1`). Before #1592 can advance it needs its own weave onto a new snapshot such as `daemon-worker-import-from-mount-phase-three-8d98a2e`. I didn't post that job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/weave-endojs-endo-but-for-bots-pr1590.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 36 tokens (1007972 cached reads)
- Output: 7201 tokens
- Cost: $1.1896463999999998
- Wall-clock: 795s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
