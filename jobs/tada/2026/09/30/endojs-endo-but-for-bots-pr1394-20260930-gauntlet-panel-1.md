The panel ran and came back **must-fix**, but I couldn't post the review to PR #1394, so this round ends as a panel-error for the driver to retry.

**What ran**
- I checked out the PR head (`endojs/endo-but-for-bots`, branch `build/sturdyref-captp-wire` at `c2d1f93e5`) in an isolated worktree, `scratch/project-wt-endojs--e15063657f20-be0bf55b`.
- I ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <wt> 1394 origin/build/sturdyref-marshal-representation-36c4f40`. It exited 0 with disposition **must-fix**.
- The panel's durable record is saved at `panel-runs/endojs-endo-but-for-bots-1394/3e4ba0b307a9.md`. That push lost 12 races before it landed, which kept panel.sh running for about 25 minutes after the verdict printed.
- Seat tally, 32 seats: 9 approve, 18 comment-only, 5 request-changes (typist, migrator, breaker, purist, integrator). The main must-fix items:
  - An inline `import()` JSDoc typedef in `packages/ocapn/src/client/sturdyrefs.js:21`.
  - The `@endo/ocapn` changeset bump is too low for the `passStyleOf` change.
  - The new `s+N` CapTP wire slot breaks older peers, and the changeset doesn't say so.
  - The PR description names the wrong frozen base: it says `-f404dbc`, but the actual base is `-36c4f40`.

**Why it wasn't posted**
- `gh pr review --request-changes` failed with `Resource not accessible by personal access token (addPullRequestReview)`. This is the known problem on host `oros-studio-garden-ce242c49`: the bot's token can't write PR reviews, comments or PRs on the `endojs` org. Git push still works.
- panel.sh exited 0 with a real verdict, so this isn't the usual panel-error case. I'm still marking it panel-error, because a panel=must-fix marker without a posted review would tell the driver something that isn't on the PR. panel-error makes the driver re-post this round.
- On the retry, panel.sh should find the saved record for this head and reuse the verdict without re-running the seats, as long as the PR head is still `c2d1f93e5`. The retrying worker then only has to post the review, which needs a host that can write to `endojs`, such as `endolin-garden-ece02cb4`.
- The review body is ready in `scratch/panel-run-pr1394-panel1`: `review-body.md` (19 KB, the must-fix header plus the five request-changes seat reports) and `comment-1.md`/`comment-2.md` (the other seats). The full aggregate is 88 KB, over GitHub's 65,536-character review limit, so a poster will need to split it the same way.

**Follow-up:** the lasting fix is to give the bot token "Pull requests: write" on the `endojs` org. Until then, panel stages that land on this host can't finish. No garden code was changed.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1394-20260930-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1460481 cached reads)
- Output: 7997 tokens
- Cost: $0.9313402000000003
- Wall-clock: 3586s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
