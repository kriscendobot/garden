The round-1 panel on endojs/endo-but-for-bots PR #1412 (claude CLI/SDK inference backends, head `40a7369819`) came back **must-fix**, and the verdict is posted on the PR. I didn't fix anything or un-draft it.

**The panel run**
- I got an isolated checkout of `endojs/endo-but-for-bots@build/endo-claude-backends-1357` and ran `panel.sh` in single-round mode against the pinned base `llm-80054c3` (`80054c3453`). It exited 0 with disposition must-fix.
- Of the 31 seats, 8 requested changes: stylist, prover, saboteur, purist, integrator, changeset-auditor, pruner and corner-prober. The other 23 approved or left comments only.
- Among the must-fix items: integrator says the stack merge took in #1403 at a stale head, so the PR should weave onto #1403's current head. The PR-body concision check also triggered the pruner.

**How the verdict was posted**
- **Split in two:** the full aggregate was about 87 KB, over GitHub's ~65 KB limit for a review body. I posted it as two reviews:
  - 06:27:42Z: part 2 of 2, the approve and comment-only seats.
  - 06:27:58Z: the main verdict, headed "disposition: **must-fix**", with the 8 request-changes seats. It is the latest review on the PR.
- **Comment review, not request-changes:** GitHub won't let the bot request changes on its own PR, so the verdict is a COMMENTED review. Its header names the must-fix disposition and its body keeps the usual panel shape. The next-stage check needs to read the disposition from the body, not the review state.
- **Bare issue references:** the gh wrapper first refused the verdict because it had bare `#N` references alongside a mention of `kriscendobot/minion.town`. I fully qualified the minion.town one (`#106`) and reworded a stray "finding #1". I then posted with `GARDEN_ALLOW_BARE_ISSUE_REF=1`, because every remaining bare reference (#1403, #1357) really is an endo-but-for-bots PR.

**Follow-ups**
- The next gauntlet stage is the fixer, working from the must-fix review.
- Garden gap: the panel stage doesn't handle an aggregate over 65 KB or the GitHub rule against requesting changes on your own PR. Both needed manual handling here and will likely come up again.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1151821 cached reads)
- Output: 6061 tokens
- Cost: $0.8061922
- Wall-clock: 751s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
