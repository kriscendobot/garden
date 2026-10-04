The panel round on kriscendobot/garden-book#12 finished with a verdict of **must-fix**, and the review is posted on the PR.

- **Run:** I took an isolated checkout of the PR head (`book-equilibrium-data` at `6035935a84`) and ran `panel.sh` in single-round mode. I passed it the PR's actual base commit, `6e0ad9790d` (the frozen base branch `main-6e0ad97`), rather than a possibly stale branch name. `panel.sh` exited 0 with disposition `must-fix`.
- **Seats:** 33 seats reviewed. Six requested changes: stylist, archivist, prover, breaker, pruner and corner-prober. The rest approved or left comments only.
- **Main must-fix finding (breaker):** the scenario's cost anchor `c` is built almost entirely from OpenAI prices. That breaks the PR's own rule that OpenAI is excluded from every true-cost total (`analyze.mjs:203-206`). It also contradicts the chapter, which says `c` is Claude cost.
- **Other findings that need fixing:**
  - The chapter links to garden-repo files with relative paths (`ch8...:532`, `:564`), which don't resolve inside garden-book.
  - The `isHuman` classification and the `quantile`/`describe`/`classify` helpers have no tests.
  - Should-fix: OpenAI is the only provider excluded from the true-cost totals; moonshot, local and fireworks events still count toward them.
  - Should-fix: a division by zero in the allocation factor (`analyze.mjs:263`) is unguarded.
- **How it was posted:**
  - The full report is about 80 KB, more than one GitHub review can hold. I posted it as a review holding the six request-changes seats first, plus a comment with the remaining 13 seat reports (issuecomment-5977521681).
  - GitHub refused "request changes" because the bot opened this PR, so the review shows as a comment (submitted 2026-10-04T07:00:43Z). The verdict is stated at the top of the body.
  - The `gh` wrapper also blocked one bare `#12` because the text names other repos; I changed it to `kriscendobot/garden-book#12`.
- **Next:** I made no code changes, didn't take the PR out of draft, and didn't run the fix stage. The gauntlet's fix-loop stage handles the fixes.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-equilibrium-data-draft-20261004-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (983875 cached reads)
- Output: 5114 tokens
- Cost: $0.7439269999999998
- Wall-clock: 366s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
