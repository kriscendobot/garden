Panel round 1 for kriscendobot/minion.town PR #180 ("feat(git-remote): bind partitions into Endo guest inventories") came back **must-fix**. I ran one round, posted the verdict, and stopped there: no fixes, no un-draft.

**How it ran**
- Got an isolated checkout of the head branch `kriscendobot/minion.town@design/git-remote-endo-binding` with `ensure-project-worktree.sh`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 180 c7bdf2018897…`. I passed the real base SHA from the GitHub API rather than the branch name `main-c7bdf20`.
- `panel.sh` exited 0 with disposition `must-fix`. The decomplector seat was added because a check for new mechanisms fired.
- The run record went to the journal at `panel-runs/kriscendobot-minion.town-180/a6285b7b5e89.md`.

**Seat results (34 seats):**
- **10 request-changes:** assessor, stylist, archivist, locksmith, warden, saboteur, breaker, wire-watcher, engine-realist, integrator.
- **7 approve.**
- **17 comment-only.**

The main theme across seats is the new loopback control plane on `127.0.0.1:3004`. It trusts whatever `owner` the caller sends, and mint/revoke check no owner at all, so it has no authentication and its trust boundary isn't written down. Other findings:
- `createNamed` does a full directory scan, unbounded, while holding the store-wide lock.
- `post()` parses the response as JSON before checking `response.ok`, which can hide the real error.
- `GIT_REMOTE_CONTROL_PORT` is not validated.
- A failure in `readOnly`/`create` can leave a pet name bound even though the call reports failure.

**What I posted on the PR**
- **Review:** the 10 request-changes seat blocks under a must-fix header carrying `<!-- garden-panel-verdict: must-fix round=1 -->`. It went in as a COMMENT review, not request-changes, because GitHub refuses request-changes on the bot's own PR.
- **Follow-up comment:** the other 24 seat blocks, at https://github.com/kriscendobot/minion.town/pull/180#issuecomment-6105601989. The full aggregate is 90 KB, over GitHub's 65,536-character limit for a review body, so it had to be split.

**Follow-ups:** the fix-loop stage owns the must-fix findings. Anything that tells a panel verdict apart by GitHub review state needs to know that PRs authored by kriscendobot always come out as COMMENTED; the marker line and the must-fix header are what identify this one.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (887522 cached reads)
- Output: 4674 tokens
- Cost: $0.7346243999999998
- Wall-clock: 203s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
