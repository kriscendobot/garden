## Panel round 1: kriscendobot/minion.town#148 (must-fix)

The single-round panel ran and returned **must-fix**. I posted the verdict on the PR and stopped there. I did not fix anything, un-draft the PR, or start another round.

**How it ran**
- **Checkout:** isolated project checkout at `scratch/project-wt-kriscen-f9405dbb318f-3ba4027c`, on PR head `8ea1b79` of `kriscendobot/minion.town:build/claude-cli-provider`.
- **Panel:** I ran `GARDEN_PANEL_SINGLE_ROUND=1 GARDEN_YARN=npm panel.sh <wt> 148 ec8db3fc87…`, passing the PR's actual base commit (base branch `main-ec8db3f`). I launched it detached so a reaper couldn't kill it. It exited 0 with `code-panel single-round — must-fix`.
- **Seats:** 33 seats ran: 13 request-changes, 11 comment-only, 9 approve.
- **Pre-checks:** the phase/evidence pre-check came back **BLOCKED**, which forces must-fix on its own. It found two problems:
  - `designs/endo-reminder-minion-town.md` is a governing design but is missing from the PR's design ledger.
  - The PR is classed as a probe, which must stay draft.
- **PR body:** the body-length check also fired: the body is 1,201 words against a 300-word limit.
- **Main code finding:** the assessor found that `claude-guest-bridge.ts` `withHost` caches a failed first daemon connection forever, so the Claude CLI backend never reconnects once the daemon is back. The other request-changes findings are in the review.

**How the verdict was posted**
- **Review:** GitHub doesn't let the bot request changes on its own PR, so the verdict went up as a COMMENTED review: https://github.com/kriscendobot/minion.town/pull/148#pullrequestreview-5401779902. It holds a summary, the forced-must-fix reasons and the 13 request-changes seats.
- **Overflow comment:** the full aggregate is about 94KB, more than a review body can hold, so the comment-only and approve seats are in a follow-up comment: https://github.com/kriscendobot/minion.town/pull/148#issuecomment-5971384390.
- **References:** the gh wrapper refused to post until I changed two bare refs (`#105`, `#148`) to `kriscendobot/minion.town#N`.

**Follow-ups**
- The fix-loop stage owns all of the findings, including adding the missing design to the ledger and cutting the PR body down.
- The gauntlet's panel step assumes the aggregate fits in one review. When it is over GitHub's limit, the step should say how to split it across a review and a comment.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr148-gauntlet-restage-20261003-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1393873 cached reads)
- Output: 7458 tokens
- Cost: $0.8895986
- Wall-clock: 525s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
