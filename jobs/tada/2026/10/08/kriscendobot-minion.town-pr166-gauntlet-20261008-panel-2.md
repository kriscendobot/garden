## Completion report: panel round 2 for kriscendobot/minion.town PR 166

**Result: must-fix.** I ran one single-round panel and posted the verdict on the PR. I did not fix anything or un-draft the PR.

**How it ran**
- **Checkout:** an isolated project worktree of `kriscendobot/minion.town` on `feat/prod-objectives-probe`, at head `a443478`.
- **Base:** I used the PR's `baseRefOid` (`d750b09`, `main-d750b09`). The diff covers 8 files, which matches GitHub's file list for the PR.
- **Command:** `GARDEN_YARN=npm GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 166 d750b09…`, run fully detached. It ran the code panel and exited 0 with disposition `must-fix`.
- **Seats:** all 33 seats returned. 2 requested changes (purist, wire-watcher), 20 were comment-only and 11 approved.

**What blocks**
- **purist:**
  - `jwtClaims` decodes the JWT by hand even though `jose` is already a dependency (`decodeJwt`).
  - The public summary includes server text nobody checks (`serverInfo.name`) and the raw scope claim.
  - Two gateway constants are duplicated, and the tests keep the copies in sync by matching regexes against the `.ts` source.
- **wire-watcher:** the `Cache-Control` parser keeps the last value when a directive repeats. RFC 9111 says to use the first or treat the response as stale. As a result, `max-age=0, max-age=31536000, immutable` passes the probe even though browsers treat that response as stale.

The decider counts any request-changes finding as blocking. Both seats rated their findings should-fix, not must-fix, but they still block.

**Posting the verdict**
- GitHub refuses a request-changes review on the bot's own PR, so the verdict went up as a COMMENTED review headed `disposition: must-fix`, like rounds 1–6: https://github.com/kriscendobot/minion.town/pull/166#pullrequestreview-5453458375
- The `gh` wrapper's bare-`#N` guard rejected the first attempt. I rewrote the references as `kriscendobot/minion.town#165/#166` and `kriscendobot/garden#58`.
- The full aggregate was 84.6 KB, over GitHub's review-size limit. The review has a must-fix summary, the two request-changes seats in full, approving seats collapsed to one line each, and the comment-only seats in full. It comes to 62.7 KB.

**Follow-ups:** the fix-loop stage takes the purist and wire-watcher findings. Optional non-blocking items in the review: a comma-joined multi-policy CSP test (corner-prober) and a concision pass on the PR body (pruner).

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-20261008-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (992042 cached reads)
- Output: 6605 tokens
- Cost: $0.8005644
- Wall-clock: 275s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
