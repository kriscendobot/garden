Panel round 7 on kriscendobot/minion.town#190 is done, and the verdict is **must-fix**.

- **Checkout and run:** I got an isolated checkout of the PR head (`kriscendobot/minion.town` branch `clip-gutter-reorder`, head `0dfbf03`) and ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against base `main-ad0257e`. It exited 0 with disposition `must-fix`. 33 seats ran: 16 approve, 15 comment-only, and 2 request-changes (integrator and pruner).
- **The must-fix:** the saved gutter order is stored by clip id. `designs/clip-shell-framework.md` Open question #4 lists the clip-id model as undecided, and under #88 (a fresh id on every upgrade) each upgraded clip would silently drop to the end of the gutter. The PR body never mentions #85 or #88. The fix is either to explain this in the body and in Open question #4, or to keep the PR in draft until that question is decided.
- **Should-fix items** were also gathered:
  - An owner with more than 1000 clips can never save an order.
  - The admission-503 change also affects other routes and should be named in the PR body.
  - The commit history is review-loop fix-ups and should be regrouped.
  - The pruner flagged redundant comments.
  - Two test gaps: the 1000-entry limit isn't tested against the production body parser, and the `clipsFor` wiring in `src/http.ts` has no test.
  - `OwnerClipOrder.save` doesn't validate its own input.
  - The order file is renamed without an fsync, and the parse error's message is dropped.
  - Two non-ASCII glyphs in a comment.
  - There is no summary comment for the round-6 push.
- **Review posted:** https://github.com/kriscendobot/minion.town/pull/190#pullrequestreview-5543552063. It is a COMMENT review, not request-changes, because GitHub won't let the bot request changes on its own PR; rounds 4–6 were posted the same way. The full aggregate is 91 KB, over GitHub's 65 KB review limit, so the body opens with the must-fix and should-fix summary and then gives the full reports of the 17 seats that didn't approve. The tally in my first post was wrong, and I corrected it in place.

Follow-up: per the job spec, the next fix stage should take on the must-fix. Whether to keep the PR in draft until #88 is decided is the maintainer's call. I made no fixes and didn't un-draft.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr190-gauntlet-panel-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1170442 cached reads)
- Output: 7538 tokens
- Cost: $0.8975204000000001
- Wall-clock: 303s

<!-- garden-usage-end -->
