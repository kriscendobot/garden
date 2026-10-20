Panel round 2 for endojs/endo-but-for-bots PR #1512 came out as a panel error: the panel ran, but the review could not be posted from this host.

**Pinned refs:** PR #1512 is open and still a draft. The head is `endojs:design/ocapn-noise-session-reconnect-protocol`.
- Base: `92b91a7e93c936b30567924c480641da19f44f78`
- Head: `a6d413b867c2bbb6299b438a3d814fcaea622b86`

I made an isolated checkout at `/Users/dom/garden/scratch/project-wt-endojs--d0e691fde966-22a7527b`, detached it at the head commit, and confirmed `git rev-parse HEAD` matches.

**Style pre-pass:** `pre-push-gates.sh --no-auto-fix --probes-only --base-ref 92b91a7e…` exited 0 and printed nothing, so the panel was allowed to run.

**Panel (single round):** `panel.sh` picked up the earlier seat verdicts from durable record `3f99b2a4dff7` instead of re-running the seats, since the head hasn't changed. It then failed when posting the review:
```
failed to create review: GraphQL: Resource not accessible by personal access token (addPullRequestReview)
panel #1512: FAILED at review submission (gh pr review failed)
```
It exited with code 1. This is the known problem on host `oros-studio-garden-ce242c49`: the bot's GitHub token has no write access to pull requests in the `endojs` org. Nothing was posted to the PR, and the disposition (pass or must-fix) was never printed, so I am not claiming either. When the driver retries this round on a host that can post, it should pick up the same record and won't re-run the seats.

**Follow-ups:**
- I added this occurrence to the `bot-pat-no-pr-write-endojs` memory.
- The lasting fix is to give the bot's token read and write access to pull requests on `endojs`.
- Until then, gauntlet panel retries should run on an endolin host.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1512-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 36 tokens (841334 cached reads)
- Output: 6418 tokens
- Cost: $1.0126187999999998
- Wall-clock: 461s

<!-- garden-usage-end -->
