## Viability report: kriscendobot/minion.town PR #135

**Result:** proceed. The gauntlet can start.

**PR facts:** The PR is OPEN, draft and unmerged. It has one commit on head `build/npm-minion-town-registry` @ `8b9ee5c0`. The base is the frozen `main-c6788df`, and `main` is now 20 commits ahead of it. It has no reviews or comments yet.

**Deciding question:** Does anything on current `main`, or any other PR, already provision hosting for the `@endo/npm-registry-server` npm development registry at `npm.minion.town`, or has that plan been dropped?

**Answer:** No on both counts.

**Evidence:**
- **Nothing has replaced it.** None of the 20 commits `main` gained since `c6788df` touch npm or the registry; they are the git-remote #86 and git.minion.town #136 deploys. A search of all PRs for "npm registry" finds only #134 (the design) and #135 (this PR). No other PR does this work.
- **The reason for it still holds.** Design PR #134 (the npm.minion.town deploy design) is open and draft, with no rejection. The server it deploys, endojs/endo-but-for-bots#1362, is open and draft and has not been dropped. #135 is the design's phase 1, dark by construction, and it expects the pin to stay empty until #1362 lands. That is expected, not a blocker.
- **Something the fix loop must handle:** #136 merged at 00:47Z and added `deploy/aws/systemd/minion-git-remote.service`, which sets `GIT_REMOTE_PORT=3003`. This PR also binds `npm-minion-registry` to `127.0.0.1:3003`. The two services would collide on that port. Both PRs also add sections to `DEPLOYMENT.md`, so a weave or rebase onto current `main` will probably conflict there. This is ordinary rework for the gauntlet, not a reason to stop it.

No changes were made and no jobs were posted.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr135-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (170746 cached reads)
- Output: 1658 tokens
- Cost: $0.4241332
- Wall-clock: 26s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
