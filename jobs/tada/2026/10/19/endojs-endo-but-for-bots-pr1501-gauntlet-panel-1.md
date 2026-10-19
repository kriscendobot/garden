## PR #1501, panel round 1: panel error (the review could not be posted)

The style pre-pass passed, but the panel's review post was refused, so no verdict exists. This is a sensor failure, so I'm reporting `panel=panel-error` for the driver to retry.

**Steps:**
1. **Pinned refs.** The PR's base is `ca5aaefb23c58a3bf11162cf78e7062d248371cc` and its head is `b1c5b929a7a7d13ecddb3972b95720149c74225a` (the PR head is on `endojs/endo-but-for-bots`, branch `feat/endopi-edit-tool-preview`). I made an isolated checkout at `/Users/dom/garden/scratch/project-wt-endojs--a40a27a96853-d6c2f4b0` and checked out the head detached; `git rev-parse HEAD` matched it.
2. **Read-only probes.** `pre-push-gates.sh --no-auto-fix --probes-only` exited 0. Its only output was one non-blocking warning: a 4-line prose comment at `packages/space-floot/src/MessageList.js:138` that the pruner seat should judge.
3. **Panel.** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` exited 1. It resumed the jurors' results from durable record `2dace332597a` without re-running any seats, then failed when posting the review:
   ```
   failed to create review: GraphQL: Resource not accessible by personal access token (addPullRequestReview)
   panel #1501: FAILED at review submission (gh pr review failed)
   ```
   The panel never got to the stage-result marker, so there is no pass or must-fix result.

**Cause and follow-up:** This is the known limit on host `oros-studio-garden-ce242c49`: its bot token is refused (403) when it tries to create, review or comment on PRs in `endojs`. A retry on this same host will fail the same way. The retried panel round should be pinned to `requires: host=endolin-garden-ece02cb4`, or the token on this host needs write access to `endojs` PRs. Because the seat results are saved in that record, a retry from a host that can post should only need to post the review.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1501-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 50 tokens (1147614 cached reads)
- Output: 8960 tokens
- Cost: $1.3851948
- Wall-clock: 844s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
