**Panel round 4 for endojs/endo-but-for-bots#1500: panel-error (sensor failure, no verdict posted to the PR)**

The panel ran, but its review could not be posted to GitHub, so this round has to be retried.

**What happened**
- **Pinned commits:** base `ca5aaefb23c58a3bf11162cf78e7062d248371cc`, head `da4b8ac700fde140788d998aa6bd01a6767d851b` (branch `endojs:build/endo-gateway-mcp-termination`). The isolated checkout's HEAD matched the head commit.
- **Style pre-pass:** passed (rc=0). There was one non-blocking warning: a 22-line prose comment at `packages/agent-mcp-stdio/src/http.js:1`, flagged for the pruner.
- **First `panel.sh` run (deployed copy):** all seats ran and the verdict was saved to the durable record `302ea84461fa`. Two notes from the run: the phase/evidence check said HOLD-DRAFT (un-draft withheld; successor job `build-endo-gateway-mcp-remaining-phases`), and the same mechanism got a must-fix again, so the decomplector was forced to ask whether it is needed. Posting then failed with exit 1. The gh wrapper refused the review because its text used bare `#1336 #1226 #1407` while also naming `nodejs/node`. The script that posts the review can't rewrite the text and try again. A retry reuses the saved record, so every retry would have failed the same way.
- **Garden fix, pushed to main2 as `6e3755be8ee`:** `panel_submit_review` in `scripts/jobs/gardening/panel.sh` now rewrites each bare `#N` to `<owner/repo>#N` before posting. GitHub already links a bare `#N` to that same target, so the meaning doesn't change. Code, HTML comments, links and URLs are left alone. A new test, `scripts/jobs/test/panel-qualify-bare-refs-test.sh`, passes 13/13, and checks that the guard blocks its sample text before the rewrite and allows it after. The existing tests still pass (`panel-review-submission-test.sh` 10/0, `panel-single-round-resume-test.sh` 17/0), and the change adds no new shellcheck findings.
- **Second `panel.sh` run (fixed copy from my worktree):** it reused the saved record without re-running the seats and got past the bare-ref guard. GitHub then rejected the post: `GraphQL: Resource not accessible by personal access token (addPullRequestReview)`. This is the known limit on this host: the oros-studio bot token can't write PR reviews on endojs. No review was posted.

**Follow-ups**
- The retry needs to run on a host whose token can write to endojs, such as `requires: host=endolin-garden-ece02cb4`. Another try on oros-studio will hit the same 403. The saved record `302ea84461fa` matches this head, base and PR body, so a retry on endolin only needs to post the review, without re-running the seats. That host must first deploy main2 at or after `6e3755be8ee`, or the bare-ref refusal comes back.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1500-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (921018 cached reads)
- Output: 9422 tokens
- Cost: $0.8280276000000002
- Wall-clock: 594s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
