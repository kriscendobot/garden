## Press report for the Claude-on-minion.town arc (issue #89), 2026-09-28 ~23:40Z

The maintainer's gauntlet request on `kriscendobot/minion.town#120` had been dropped; it's now posted and running. The issue body and the press comment are updated to match.

**What changed since the last press comment (13:57Z):**
- **`kriscendobot/minion.town#120` (item 2):** at 21:02Z kriskowal asked to "run a gauntlet and retcon". Only the retcon job was posted. The retcon finished at 21:07Z (head `8e6ed5e`, tree unchanged, CI green). No gauntlet job existed anywhere on the board, so I posted one: `kriscendobot-minion.town-pr120-gauntlet` via `post-gauntlet.sh`, recorded at 23:39Z. I also left a short note on the PR saying so. The watcher probably missed the phrase because that host was running a garden version from before `c8792a8e` ("recognize run a gauntlet"). No new fix is needed.
- **`endojs/endo-but-for-bots#1357` (item 4):** kriskowal asked (20:56Z) whether the `--bare` flag rules out using a subscription. A test found it doesn't, as long as the token is passed as `ANTHROPIC_AUTH_TOKEN`. Commit `e235274b7c` rewrote open question 1 as a policy question.
- **No change:** `endojs/endo-but-for-bots#1015` (quiet draft), `endojs/endo-but-for-bots#1340` (questions still unanswered), `kriscendobot/minion.town#105` and `#106` (drafts; `#106` is on hold). No design landed and nothing else was unblocked, so the gauntlet is the only job I posted.

**Issue #89:**
- **Body:** updated the evidence date, item 2 (retcon done, gauntlet running), item 4 (`#1357`'s first review question answered and revised) and the design-PR bullet for `#97`/`#120`. The architecture text and item specs are unchanged, and no boxes flipped.
- **Press comment:** https://github.com/kriscendobot/garden/issues/89#issuecomment-5880864876. It makes two review asks:
  1. The rest of `#1357`'s open questions, including the policy half of question 1.
  2. The standing item 5 choice between `#1015` and `#1340`.

**Follow-ups:**
- The `#120` gauntlet will un-draft the PR if it passes.
- There is still no maintainer decision on item 5 or `#1357`, so I didn't post any new design or build work.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/claude-on-minion-town-press-20260928-232006.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (950519 cached reads)
- Output: 8029 tokens
- Cost: $0.8413878000000001
- Wall-clock: 781s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
