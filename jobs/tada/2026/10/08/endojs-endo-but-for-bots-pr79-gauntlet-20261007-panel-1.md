I ran the panel round, but couldn't post its review from this host, so this round ends as `panel-error` and the driver will retry it.

**What happened**
- **Project checkout:** `ensure-project-worktree.sh` failed three times. Its git calls have a 120s limit (`GARDEN_REPO_GIT_TIMEOUT`), and on this loaded host checking out the PR head's ~40k files takes longer. It worked with `GARDEN_REPO_GIT_TIMEOUT=900`, giving `/Users/dom/garden/scratch/project-wt-endojs--6cbe8ab2db28-1202706f` at head `9ae6e4d55`.
- **Panel:** I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 79 origin/master-c49fb04`. It exited 0 with **must-fix**, but it reused the seat results already saved by an earlier run for the same head (record `a693481bcd56`) rather than re-running the jurors. That earlier run had also left a complete, never-posted aggregate in the rundir (`review-body.md`, 63,656 bytes) for this gauntlet, stage and iteration.
- **Verdict content:**
  - Seats requesting changes: stylist, archivist, spec-keeper, integrator, pruner.
  - The PR body doesn't follow the template, which is binding.
  - spec-keeper says the test treats the SES descriptor and `isFrozen` results as equivalent to Node's even though they contradict the spec.
  - stylist flags abbreviated identifiers.
  - The review also notes the PR's `base` (`master-c49fb04`) doesn't match where the head commit sits (`master-eecc683`). GitHub therefore shows about 100 unrelated commits, and the PR needs a weave before it merges.
- **Posting failed:** `gh pr review --request-changes` returned `Resource not accessible by personal access token (addPullRequestReview)`. This is the known problem on this host: the bot's token (PAT) lacks PR write access on the `endojs` org. The PR still has 0 reviews.

**Outcome:** Because no review got posted, I'm using `panel-error` rather than reporting must-fix. The retry is cheap: the saved record for head `9ae6e4d55` lets panel.sh skip the jurors, so a capable host only has to post the aggregate.

**Follow-ups**
- Pin the retry to a host whose token can write to endojs PRs (for example `requires: host=endolin-garden-ece02cb4`). Otherwise the driver may hand it back to this host and fail the same way.
- The lasting fix is to give the bot token PR read+write on endojs.
- The 120s git limit in `ensure-project-worktree.sh` is too short for endo-but-for-bots under load and should be raised for large checkouts.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr79-gauntlet-20261007-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 112 tokens (3323614 cached reads)
- Output: 15723 tokens
- Cost: $2.0572467999999997
- Wall-clock: 4555s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
