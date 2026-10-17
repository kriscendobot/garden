I ran one panel round on kriscendobot/minion.town PR #198, and the verdict is **must-fix**. It's posted on the PR as three reviews; I did not fix anything or un-draft it.

**The run**
- I reviewed an isolated checkout of `kriscendobot/minion.town@feat/beta-home-splash-waitlist`, head `9b76559a`. I passed the exact merge-base SHA `bda7739d` (the frozen base `main-bda7739`) as the base.
- `panel.sh` ran in single-round mode and exited 0 with disposition `must-fix`.
- 34 seats ran. 7 requested changes: archivist, assessor, saboteur, breaker, pruner, corner-prober and procurer. 20 must-fix or should-fix items were recorded.
- The full record is `panel-runs/kriscendobot-minion.town-198/2d8ac1fc7744`.
- Main findings:
  - **Body limit never applies:** the waitlist route's 2 KB body limit is dead code, because the global `express.json()` parser in `src/http.ts` runs first.
  - **Rate limiter shuts everyone out:** once it fills up, it rejects all new visitors.
  - **CSV export unescaped:** `list --csv` doesn't escape fields, which allows formula injection when an operator opens the file.
  - **Stale design doc:** `designs/clip-shell-framework.md` § 8 still describes the shell as behind the login gate.
  - **Smaller items:** various doc and comment drift.

**How it was posted**
- **Split into three parts:** the aggregate was 90 KB, over GitHub's ~65 KB limit for a review body. Part 1/3 is review 5557087359 and part 2/3 is 5557087412; both hold the comment-only and approve seats. Part 3/3 is review 5557088438, posted last: the must-fix header, scope, and the seven request-changes seats.
- **Not a formal request-changes review:** GitHub rejected it with "Can not request changes on your own pull request", because the PR's author is the bot account. The verdict is therefore a COMMENTED review whose body says must-fix and asks readers to treat it as request changes.

**Follow-up:** if the next-stage-owed check relies on the review *state* (CHANGES_REQUESTED) rather than this report's marker or the review body, a bot-authored PR can never show a must-fix verdict that way. That check should key on the body text or the stage marker.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1258235 cached reads)
- Output: 5541 tokens
- Cost: $0.947363
- Wall-clock: 243s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
