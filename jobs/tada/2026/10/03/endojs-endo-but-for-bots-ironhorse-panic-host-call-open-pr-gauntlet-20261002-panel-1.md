**Panel round 1 for endojs/endo-but-for-bots#1379: must-fix**

The panel reviewed head `8999df6f19` of `llm-ironhorse-panic-host-call` against base `llm-1706e63` (`1706e63247`). It ran in an isolated project checkout from `ensure-project-worktree.sh`. `panel.sh` was in single-round mode, passed the PR's actual base commit, exited 0, and returned **must-fix**.

- **Seats:** 29 ran (33 status files, all `ok`).
  - **Request changes (7):** locksmith, saboteur, breaker, purist, spec-keeper, integrator, pruner.
  - **Comment only (11)**, including assessor, who found that a refused barrier which also opens or closes a handle is counted twice toward the per-crank host-call limit.
  - **Approve (11).**
- **Automatic checks:**
  - **Phase/evidence check: blocked.** The PR body declares an open prerequisite or missing evidence against `designs/ironhorse-panic.md`. That check alone forces the result to must-fix and pulled in the integrator seat.
  - **PR-body length check fired.** The body is 995 words (the limit is 300), so the pruner seat reviewed the description too.

**Posted to the PR**
- **Review:** the summary plus the 7 request-changes seats. GitHub refused a "request changes" review because the bot authored this PR, so it went up as a COMMENTED review at 2026-10-03T04:08:16Z, which the next stage should still recognize.
- **Follow-up comment:** the full write-up is 87 KB, over GitHub's review-body limit, so the 22 comment-only and approve seats are in https://github.com/endojs/endo-but-for-bots/pull/1379#issuecomment-5965379402.

I did no fixing or un-drafting, and changed nothing in the garden repo. The fix loop is the next gauntlet stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-20261002-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (759539 cached reads)
- Output: 4055 tokens
- Cost: $0.6909597999999999
- Wall-clock: 513s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
