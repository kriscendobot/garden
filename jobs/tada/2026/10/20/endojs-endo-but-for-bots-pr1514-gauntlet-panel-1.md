I ran the panel for endo-but-for-bots#1514, but the review never got posted, so this stage ends in `panel-error` and the driver will retry it. This host's bot token isn't allowed to post PR reviews on the endojs repo.

**What happened**
1. I pinned the pair from `gh pr view`: base `453413b83d88582849f42046ff12def478d37995`, head `c986cab1a3078cb389369744a65c9ff1b4d8b161`. The head is on the fork `kriscendobot/endo-but-for-bots`, branch `design/ocapn-noise-cryptographic-review-transport-addendum`. I got an isolated checkout at `scratch/project-wt-endojs--a3919157e11b-25d952a6`, checked out the head detached, and confirmed `git rev-parse HEAD` matches.
2. The read-only style pre-pass (`pre-push-gates.sh --no-auto-fix --probes-only`) exited 0 with no output.
3. **First panel run exited 1:** `FAILED at review submission preflight (cannot resolve PR author)`. All seats and the decider had run. The cause: `panel.sh` takes the repo name from the worktree's origin, which for a fork-head PR is the fork. `gh pr view 1514 -R kriscendobot/...` fails there, so the PR-body checks also ran without the body, and seats couldn't look up the related PRs (the skeptic seat noted it couldn't resolve #1481 or #1506).
4. **Garden fix, pushed to main2 as `882f7b3`** (`fix(panel): resolve a fork-head PR against the fork's parent repo`):
   - `scripts/jobs/gardening/panel.sh` now accepts a `GARDEN_PANEL_PR_REPO` override.
   - Otherwise, when the PR isn't on origin, it falls back to the fork's parent repo if the PR is there.
   - The durable run record is now keyed on that resolved repo.
   - Only a `bash -n` syntax check was run on it; no tests in `tests/` cover `panel.sh`.
5. **Second panel run, using the fixed script, exited 1.** It resolved `endojs/endo-but-for-bots` and fetched the PR body, and all seats and the decider ran. The panel reached disposition `passed`, but posting the review failed: `GraphQL: Resource not accessible by personal access token (addPullRequestReview)` → `FAILED at review submission (gh pr review failed)`. This matches the known oros-studio limit: the bot token gets a 403 on endojs PR writes. Because no review was posted, this does not count as a pass.

**Follow-ups**
- The run record is saved with the head, base, provider and PR-body hash (`panel-runs/endojs-endo-but-for-bots-1514/c2ed1f8647da.md`). A retry on a host that can post reviews should reuse it and post the `pass` without re-running the seats.
- A retry claimed on oros-studio will hit the same 403. Panel stages for endojs PRs probably need to be pinned to a host that can post reviews (for example `requires: host=endolin-garden-ece02cb4`, as builder PR-opens already are), or the driver will spend its retry budget here.
- Every fork-head PR panelled before `882f7b3` had the same blind PR-body checks and failed author lookup.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1514-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1201009 cached reads)
- Output: 9401 tokens
- Cost: $0.8700937999999999
- Wall-clock: 540s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
