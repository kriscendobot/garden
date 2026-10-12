Panel round 2 on kriscendobot/garden-book PR #8 returned **must-fix**, and the verdict is posted on the PR as a review.

- **Run:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` ran against an isolated checkout of head `8304543` (branch `book-reader-exposure-copyedit`) and exited 0 with disposition `must-fix`. I passed the base as the merge-base SHA `e6f2790…`, because the frozen base branch `main-e6f2790` couldn't be fetched as a ref.
- **Seats:** 33 seats ran with no errors. One requested changes, 13 approved and 19 left comments only.
- **Why must-fix (pruner):** the only must-fix is about the PR description, not the chapters:
  - The PR body is about 1,000 words and walks through each chapter's changes, which the diff already shows. It should be cut to roughly 300 words: the editorial approach plus the items that need maintainer judgment.
  - The "Likely conflicts" note should either say what the reviewer needs to do or be dropped.
  - The pruner also asks whether the "Open items" section in `editorial/reader-exposure-map.md` is a running list that will change, or should be cut.
- **Round 1 items:** both are resolved — the must-fix on the ch8 § 8.7 accountant text and the should-fix on non-ASCII characters in the exposure map.
- **Smaller notes (summary-fix level):**
  - The "5M-token" figure in ch8 has lost its source citation.
  - Two lines in ch7 run much longer than the rest of the chapter.
- **How it was posted:** GitHub won't let an account request changes on its own PR, so it went up as a comment review, the same way round 1 was. Its header states that the disposition is must-fix. The body is the full per-seat aggregate.
- **Posting fixes:** the bot's `gh` wrapper refused the first attempt because the text mixed bare `#3`/`#6` with another repo's name. I rewrote those as `kriscendobot/garden-book#3` and `#6`.

I made no fixes and did not un-draft the PR; the next gauntlet stage owns that.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr8-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1020920 cached reads)
- Output: 3979 tokens
- Cost: $0.781932
- Wall-clock: 165s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
