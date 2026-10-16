I ran round 4 of the panel on PR #1391 and its verdict is **must-fix**, but I couldn't post that verdict as a review on the PR. So this attempt ends with the `panel-error` marker, and the driver can re-run the round on a host that is allowed to post.

**What ran**
- I got an isolated checkout of the PR head, `endojs/endo-but-for-bots@build/sturdyref-ses-accommodation` at `3c39e7d2e`, at `/Users/dom/garden/scratch/project-wt-endojs--4c3f9683266f-a4365e14`.
- I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1391 origin/build/sturdyref-shim-first-wins-dbd2b00`. All 34 seats returned ok, and the final line was `code-panel single-round — must-fix`. I ran it in the background with a poll loop, so I don't have its exit code; the clean final line and all-ok seats suggest it exited 0. The run is recorded durably at `panel-runs/endojs-endo-but-for-bots-1391/fade02518369.md`.
- Seat verdicts: 8 request-changes (archivist, curator, migrator, breaker, surfacer, pruner, releaser, decomplector), 17 comment-only, 9 approve.
- The repeated-mechanism check fired, because rounds 2 and 3 also raised must-fix findings on the same `sampleParcel` hardening. The decomplector's must-fix finding asks the PR to stop adding defences against pre-lockdown code that the PR itself treats as trusted. `sampleParcel` would shrink to checking for an own data property holding a function, and the existing permits check would handle the shape. The other option is for the design to say that code is adversarial, which needs the maintainer's confirmation.
- The PR-description check also fired: the description names 3 file paths and should be cut down.

**Why the review wasn't posted**
- `gh pr review --request-changes` failed with `GraphQL: Resource not accessible by personal access token (addPullRequestReview)`. This host's (oros-studio) bot token can't write PR reviews on the endojs org; my memory notes record the same failure on earlier rounds of this PR.
- Since no review is on the PR, reporting `must-fix` would let the next stage start on a verdict no one can see. Following the memory note, I'm treating this as a sensor failure and letting the round be retried.
- A retry on a capable host should be cheap: if the PR head is unchanged, the panel reuses the recorded seat verdicts instead of re-running them.
- I prepared a body trimmed to fit GitHub's 65,536-character review limit at `$TMPDIR/garden-panel-project-wt-endojs--4c3f9683266f-a4365e14-1391/review-body-r4.md` (64.5 KB). To fit, it gives full text only for the request-changes seats and some others, and lists 15 seats as one-liners. That file is in scratch space and may not survive teardown.

**Follow-ups**
- If the retry lands on oros-studio again, it will fail the same way. Either pin it to an endolin host with `requires: host=endolin-garden-ece02cb4`, or give the token "Pull requests: write" on the endojs org (this may need org approval).
- The PR author is the bot, so earlier rounds were posted as COMMENT reviews rather than request-changes. The retry should do the same.
- I updated the memory note `bot-pat-no-pr-write-endojs.md` to record that this failure is still happening as of 2026-10-16.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 100 tokens (2668287 cached reads)
- Output: 17591 tokens
- Cost: $2.2636454000000006
- Wall-clock: 1862s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
