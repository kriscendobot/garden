Panel round 1 on kriscendobot/minion.town PR #186 (`build/root-canary-principal` at `f10693f`, against `design/root-canary-principal-8368f8c`) came back **must-fix**. The verdict is posted on the PR.

**What I did**
- Made an isolated project checkout. The frozen base branch wasn't fetched locally, so I fetched it, then ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh`. It exited 0 with disposition must-fix and wrote its durable record to `panel-runs/kriscendobot-minion.town-186/88470d6e8380.md`.
- 29 seats plus the deterministic probes: 11 requested changes, 12 were comment-only and 10 approved.

**Must-fix items (3)**
1. **archivist:** `DEPLOYMENT.md` says `refused` means an expired or revoked refresh token. But `root-canary-token.sh` returns `refused` for every non-200 response and every curl failure, so a Cognito or network outage tells the operator to re-mint. The assessor, breaker and others flagged the same mix-up: those failures end in exit 75 ("waiting"), not a failed canary.
2. **prover:** the production audit wiring has no test: `writeMcpAudit` in `src/http.ts` and the `auditClaudeTool` pass-through in `src/server.ts`. It needs an HTTP-level test.
3. **breaker:** re-minting leaves the previous refresh token live as `AWSPREVIOUS`, and `root-canary-revoke.sh` can't revoke it.

**Posting the verdict**
- **Size limit:** the full aggregate is 88 KB, more than GitHub allows in one review body. I split it:
  - The overflow seat blocks are a PR comment labeled "continued": issuecomment-6166546096.
  - The review holds a header, the three must-fix items, and the request-changes seats first.
- **Comment, not request-changes:** GitHub refused the request-changes review ("Can not request changes on your own pull request"), because the bot opened the PR. I posted it as a **COMMENT** review (2026-10-14T10:44:09Z) whose heading says **must-fix** and explains why. The gauntlet driver moves to the next stage from the marker below. The fix stage is told to read "the request-changes review", so it should look for the latest panel review by heading, not by state.

**Follow-up:** the panel-stage instructions assume a request-changes review is always possible, which fails on PRs the bot opened itself. They should say to post a COMMENT review in that case. I made no garden code changes.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr186-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (962660 cached reads)
- Output: 5645 tokens
- Cost: $0.752752
- Wall-clock: 537s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
