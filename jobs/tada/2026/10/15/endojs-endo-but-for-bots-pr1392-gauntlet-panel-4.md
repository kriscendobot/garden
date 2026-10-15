I ran panel round 4 on PR #1392, and it reached a genuine **must-fix** verdict, but I couldn't post the review from this host. So I'm closing this round as a panel error, which makes the driver re-run the round on a host that can post.

**What ran**
- Got an isolated checkout of the PR head (`endojs/endo-but-for-bots`, branch `build/sturdyref-pass-style-recognition`, head `1dfaf54aa0`).
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh` against base `origin/build/sturdyref-ses-accommodation-a10a201`. It exited 0 with disposition **must-fix**. All 34 seats ran cleanly: 13 asked for changes, 10 were comment-only, 10 approved and 1 gave no label.
- The panel flagged a repeat: the previous two rounds (heads 5316b03b and 93bc151b) raised must-fix findings on the same code. That is the `parcel` handling in `packages/marshal/src/rankOrder.js` (`compareParts`, `getPassStyleRank`, `getRankCover`). Because of the repeat, the decomplector seat had to ask whether that code is needed at all.

**Main must-fix findings**
- **decomplector:** remove the `nested` identity-bypass from `compareParts`. It is the code the last two rounds kept patching.
- **saboteur, corner-prober, breaker, spec-keeper:** comparing values that share sub-arrays or sub-records now takes exponential time in `compareParts`.
- **curator:** the new `P` type parameter on `Container` is a breaking change to a public type, and the changeset doesn't list it.
- **migrator, surfacer:** `@endo/parcel` is declared as a runtime dependency where it is only used for types (in `@endo/pass-style`) or only by tests (in `@endo/marshal` and `@endo/patterns`).
- **integrator:** the PR description gets the dependency graph wrong.
- **packager, changeset-auditor, releaser:** problems in the changeset itself (wrong bump levels and an undisclosed type change to `Parcel`).

**Why the review wasn't posted**
- The aggregate is 99 KB, over GitHub's 65,536-character review limit. I split it into two parts (57 KB and 46 KB), with request-changes seats first and a summary of their headlines at the top.
- Both `gh pr review --request-changes` and `--comment` failed with `GraphQL: Resource not accessible by personal access token (addPullRequestReview)`. The bot token on host `oros-studio-garden-ce242c49` doesn't have pull-request write access on endojs. Earlier rounds on this host hit the same block.
- Nothing was posted to the PR, nothing in the garden changed, and the PR stays draft.

**Follow-ups**
- The retry should run on an endolin host (e.g. `endolin-garden-ece02cb4`). If the PR head hasn't changed, the panel reuses the saved seat verdicts instead of re-running them, so the retry is cheap.
- The lasting fix is to give the bot token pull-request read and write access on endojs, which may need the org's approval.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1392-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 90 tokens (2490383 cached reads)
- Output: 13689 tokens
- Cost: $1.6861925999999996
- Wall-clock: 2288s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
