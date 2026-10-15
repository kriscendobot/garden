The panel ran to a real verdict, **must-fix**, but I couldn't post it to PR #1391, so this stage is reported as a sensor failure for retry.

- **Checkout:** isolated worktree of `endojs/endo-but-for-bots@build/sturdyref-ses-accommodation` at head `67ab6031c`, 7 commits over base `build/parcel-shim-first-wins-98a09fa`. The first `ensure-project-worktree.sh` attempts failed only because a peer's `worktree add` held the bare-repo lock; a retry loop got through.
- **Panel:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh … 1391 origin/build/parcel-shim-first-wins-98a09fa` exited 0 with disposition `must-fix`.
  - 33 seats: 10 request-changes (assessor, typist, packager, archivist, curator, purist, integrator, changeset-auditor, pruner, releaser), 16 comment-only, 7 approve.
  - Main must-fix theme: the `presampled`/`sampleParcel` defense is never wired up. `lockdown.js:354` doesn't pass `parcelSample`, and the key spaces don't match (`Parcel` vs `%InitialParcel%`), so the JSDoc describes a protection that doesn't happen.
  - The run is saved at `panel-runs/endojs-endo-but-for-bots-1391/8987e474cc8e.md`.
- **Posting failed:** `gh pr review --request-changes` returned `GraphQL: Resource not accessible by personal access token (addPullRequestReview)`. This is the known limitation on host `oros-studio-garden-ce242c49`: the bot token has no pull-request write access on endojs. Nothing reached the PR; the follow-up comment with part 2 of the aggregate was never sent.
- **Why panel-error:** without a posted review, the next stage can't find a verdict. Claiming `must-fix` would be false, so I'm using the retry marker as the host memory directs. A retry with the same head, base and PR body should pick up the saved run and only need to post. The aggregate is about 95 KB, over GitHub's 65,536-character limit, so the retry will need to split it into a review plus a follow-up comment, as I did.

**Follow-ups:**
- The gauntlet's panel re-post isn't pinned to a host, so the retry could land on oros-studio again and fail the same way. Pinning panel and gauntlet stages for endojs PRs to an endolin host (`requires: host=endolin-garden-ece02cb4`), or granting the token pull-request write on endojs, would stop that.
- The thesaurus seat couldn't fetch the live PR title and body, so it couldn't check them for clichéd AI phrasing.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1560822 cached reads)
- Output: 7781 tokens
- Cost: $0.9451124000000002
- Wall-clock: 1489s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
