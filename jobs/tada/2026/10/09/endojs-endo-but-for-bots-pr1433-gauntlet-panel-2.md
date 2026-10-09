I ran panel round 2 on PR #1433 and it found must-fix problems, but this host couldn't post the review, so I'm closing the stage as a panel error for the driver to retry elsewhere.

**What happened**
- **Checkout:** the isolated checkout of `kriscendobot/endo-but-for-bots@design/formula-identifier-indirection` (head `4d7141de5f`) failed twice. Checking out about 49k files took longer than the fleet git wrapper's 120s limit on this loaded host (exit 124). It worked once I set `GARDEN_REPO_GIT_TIMEOUT=1200`.
- **Panel:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh … 1433 llm-7d2eb30` exited 0 with disposition **must-fix**. All 33 code-panel seats ran: 13 request changes, 13 comment-only, 7 approve. The run is recorded in the journal at `panel-runs/kriscendobot-endo-but-for-bots-1433/b923212d980d.md`.
- **Must-fix issues the seats agreed on:**
  - `locate()` and migration step 4 create shares nobody can ever revoke, and each one keeps its target from being collected.
  - A retried `rotate()` can't be told apart from a second, deliberate rotation.
  - Binding roots break pet-store garbage collection.
  - The migration rewrites `synced_store_entry.locator`, which holds values replicated to peers, and the staging contradicts the v3→v4 schema upgrade.
  - The doc contradicts the in-progress M4 external-connectivity design (formula identifier as the swissnum) without reconciling it.
  - Some claims about existing code are wrong: `resolvePetName` and `resolveReference` don't exist, and `from=` carries a handle number.
- **Posting failed:** `gh pr review --comment` returned `Resource not accessible by personal access token (addPullRequestReview)`. This is the known gap on `oros-studio-garden-ce242c49`: the bot's token can't write PR reviews or comments on endojs. Nothing was posted to the PR.

**Why panel-error and not must-fix:** the stage owes the driver a verdict that is actually posted on the PR. Since none is, I'm following the standing guidance for this host and emitting the panel-error marker so the driver re-posts the round. If the retry lands on the same head, `panel.sh` should rebuild the review from the recorded run instead of running all the seats again. That will need a host whose token can write to endojs, such as `endolin-garden-ece02cb4`.

**Follow-ups**
- On posting, the aggregate is about 93 KB, more than GitHub's 65,536-character limit for a review body. Whoever posts it will have to split it; I split it into a summary review plus a continuation comment (`/Users/dom/garden/scratch/tmpexec/pr1433-post/part{1,2}.md`). Those files are temporary.
- Some seats (procurer, for one) couldn't resolve the base `llm-7d2eb30` in the fork checkout, so their automated checks are unverified, not clean.
- `ensure-project-worktree.sh` needs a longer git time limit for large repos on loaded hosts.
- The durable fix for posting is giving the bot's token PR write access on endojs.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1433-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2026363 cached reads)
- Output: 10804 tokens
- Cost: $1.1944485999999999
- Wall-clock: 2777s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
