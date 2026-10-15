## Gauntlet panel round 1: endojs/endo-but-for-bots PR #1460

**The panel returned must-fix, but I couldn't post the review from this host, so I'm reporting `panel-error` so the round runs again.**

**What I did**
1. Checked out the PR head (`endojs/endo-but-for-bots@design/parcel`, head `9728449f4e33`) in an isolated project worktree. The first try failed because git is cut off at 120s on this host; it worked with `GARDEN_REPO_GIT_TIMEOUT=900`.
2. Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1460 origin/llm-7ff30af`. It ran as a design panel, exited 0, and returned **must-fix**.
   - 10 seats ran. Six asked for changes: critic, skeptic, copyeditor, pedant, novice and integrator. Decomplector, ergonomist and thesaurus left comments only, and orthographer approved.
   - The PR-body template check failed, which forces must-fix on its own. The body is missing the *Scaling*, *Documentation* and *Upgrade Considerations* headings.
   - Main must-fix findings:
     - Writing the location into CapData leaves secrets readable wherever bodies are stored or logged (skeptic).
     - kriskowal's CHANGES_REQUESTED review came after HEAD and has no answer yet. It asks about Slot Machine as a consumer and whether "Superseded" is the right status for `sturdy-refs-endor-syscall.md` (integrator).
3. Tried to post the aggregate with `gh pr review --request-changes`. It failed with `GraphQL: Resource not accessible by personal access token (addPullRequestReview)`. This is a known limit: the bot token on `oros-studio-garden-ce242c49` can't write PRs or reviews on endojs.

**Why panel-error and not must-fix**
The verdict is real but no review was posted. A `must-fix` marker would tell the driver a review exists on the PR when it doesn't, so I'm treating this as a sensor failure and letting it retry the round.

**Retry cost**
The panel record was saved to the journal at `panel-runs/endojs-endo-but-for-bots-1460/653b8e392e56.md` (head, base and PR-body hash all match). A retry on a host that can write PRs, such as `endolin-garden-ece02cb4`, will reuse that verdict and only needs to post the review. It won't re-run the seats.

**Follow-up**
If the retry lands on this host again, it will fail the same way. The lasting fix is to give the kriscendobot fine-grained token read and write access to pull requests on the endojs org.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1460-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (991464 cached reads)
- Output: 5599 tokens
- Cost: $0.7638888
- Wall-clock: 1154s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
