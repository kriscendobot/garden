Panel round 1 on kriscendobot/minion.town PR #188 (head `7b73dec`) came back **must-fix**. I posted the verdict as a review comment on the PR.

**What I did**
- **Checkout:** made an isolated checkout of the PR head (`kriscendobot/minion.town` `clip-gutter-live-refresh`, base `main-ad0257e`) at `/Users/dom/garden/scratch/project-wt-kriscen-7e2f44dcc29d-d2c66462`.
- **Panel run:** ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <wt> 188 main-ad0257e`. It exited 0 with the final line `code-panel single-round — must-fix`. The new-mechanism probe fired, so the decomplector seat was added.
- **Seat verdicts:**
  - **Request changes (6):** assessor, breaker, corner-prober, migrator, pruner, purist.
  - **Comment only (16).**
  - **Approve (12).**
- **Review:** https://github.com/kriscendobot/minion.town/pull/188#pullrequestreview-5530754549
  - It carries the `<!-- garden-panel-verdict: must-fix round=1 -->` marker.
  - It is a comment rather than a request-changes review because GitHub won't let the bot request changes on its own PR. Earlier rounds on PR #187 were posted the same way.
  - The full aggregate was about 82 KB, more than a review can hold. I kept a theme summary plus the full text of every request-changes and comment-only seat, and listed the approving seats by name only (62 KB total).

**Must-fix themes for the fix stage**
1. **Every refresh reloads the open clip.** `applyClips` calls `gutter.selectClip()` even when the selection hasn't changed, which reloads the iframe. Refresh runs on every window focus and every tab switch to visible, so this happens constantly. Five seats raised it.
2. **Login and "not found" errors are treated as temporary outages.** `makeClipSource.load` returns `null` for any non-OK response, so after sign-out a 401, 403 or 404 keeps showing the previous account's clips. That breaks the account isolation the design doc (`designs/clip-shell-framework.md` § 3) relies on.
3. **Auto-select isn't limited to the first load**, contrary to the JSDoc on `clipSelectionAfterRefresh`. Breaker showed that an empty pane can switch to the first clip on a later refresh.
4. **A click during an in-flight read can lose the selection.** The clip list was fetched before the user's click, so a newly published clip they selected meanwhile can be cleared as "removed".
5. **Smaller items:** two wording cuts, a stale code comment, and a wiring test that only checks the source text exists.

I made no fixes, did not un-draft the PR, and made no garden commits. The next gauntlet stage owns the fixes.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr188-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1308242 cached reads)
- Output: 6736 tokens
- Cost: $0.9234644000000001
- Wall-clock: 1367s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
