Round 1 of the panel on kriscendobot/garden-book PR #16 came back **must-fix**. panel.sh exited 0.

**What I ran**
- Made an isolated checkout of `kriscendobot/garden-book@garden-book-colophon-20261016` at head `fe9ece3`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 16 51f6c5d…`, against base `main-51f6c5d`. It printed `code-panel single-round — must-fix`.
- 33 seats reviewed: 2 asked for changes (pruner, corner-prober), the rest approved or left comments only.

**What has to be fixed**
1. **`$` patterns in the provenance splice** (corner-prober; assessor raised the same point as comment-only). `build/render-book.mjs` passes the provenance table to `colophonSource.replace("{{PROVENANCE}}", …)` as a string, so a `$&`, `$'` or `$$` in a chapter title or metadata value gets rewritten. The fix is a function replacer, `() => table`, plus a test with a chapter title containing `$`.
2. **Wordiness** (pruner):
   - Cut the PR body from about 758 words to about 300.
   - Delete the comment at `build/render-book.mjs:458-459`, which describes the move rather than the code.
   - Cut the clause in `build/colophon.html:15` that repeats the table's "Grounded on" column.
   - Shorten the provenance sentence at `build/README.md:64`.

**How it was posted (differs from the job spec)**
- GitHub refused a request-changes review because the bot opened the PR (`Can not request changes on your own pull request`). I posted the verdict as a **comment review** (COMMENTED, 2026-10-17T02:41:36Z) instead. Its header says must-fix and lists both items, so the fix stage can find them. The driver moves to the next stage based on the marker below, not on the review state.
- The full aggregate was about 74 KB, over GitHub's 65,536-character review limit. I split it at seat boundaries: the review holds the header, the two request-changes seats and the next 20 seats (about 58 KB). The other 11 seats are in a follow-up PR comment: https://github.com/kriscendobot/garden-book/pull/16#issuecomment-6228626854

**Follow-ups**
- Bot-authored PRs can't receive a request-changes review. If the next-stage check requires the CHANGES_REQUESTED state, it needs to accept a COMMENTED panel review on these PRs too.
- panel.sh has no handling for an aggregate over the size limit. It should split or condense automatically rather than leave that to whoever posts the review.

Nothing was fixed or un-drafted. No garden commits.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr16-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (947069 cached reads)
- Output: 5248 tokens
- Cost: $0.7819578000000003
- Wall-clock: 199s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
