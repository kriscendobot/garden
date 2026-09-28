Press tick for arc kriscendobot/garden#89 (2026-09-28, about 14:05Z). One thing changed: there is a new design to review for item 4, so I updated the issue and posted one comment.

**Checklist state:**
- **What changed:** endojs/endo-but-for-bots#1357 opened as a draft at 05:03Z. It is item 4's back-fill design (`designs/endo-claude-inference-backends.md`), the one the maintainer asked for on endojs/endo-but-for-bots#1228. It is `MERGEABLE`, CI is green, and nobody has reviewed it yet. It asks the maintainer four open questions. The earlier 10:41Z press tick missed it because that tick only looked at new minion.town PRs.
- **Unchanged since the last press comment (2026-09-27 10:24Z):**
  - kriscendobot/minion.town#120 is still a draft with no gauntlet run and no review.
  - endojs/endo-but-for-bots#1015 and endojs/endo-but-for-bots#1340 are drafts with no maintainer reply.
  - kriscendobot/minion.town#105 and kriscendobot/minion.town#106 are still draft; #106 is on hold until a Claude API key exists.
  - The minion.town PRs opened or updated since then are off-arc, except kriscendobot/minion.town#128. That one is a routine version bump of the pinned Claude harness under item 1's upgrade policy and changes no box.
- **Issue body:** I added #1357 and its four open questions to item 4's evidence line and updated the "as of" line. Its production inspection found `ENDO_CLAUDE_ENABLED` unset and neither prototype deployed; I noted that too. No boxes changed, and the architecture and spec text is untouched.

**Comment:** posted https://github.com/kriscendobot/garden/issues/89#issuecomment-5871394373. It asks the maintainer to:
1. Answer #1357's open questions. That unblocks turning the minion.town CLI and SDK prototypes into the `@endo/claude` inference seam.
2. **run the gauntlet** on kriscendobot/minion.town#120. That ask is unchanged and unblocks item 2's root-only `delegate()` reaching merge.

It also restates the pending item 5 choice (the #1015 refresh or answers to #1340's questions) in one line, without asking it again.

**Jobs:** none posted. Nothing new is unblocked: #1357, #120 and item 5 all need the maintainer. Item 7's CapTP eval build still waits on four prerequisites that nobody has designed yet. I checked the board and the arc has nothing in `todo`, `doin` or `orch`.

**Inbox:** the drain returned nothing.

**Follow-up:** the next tick should watch #1357 for review answers. Once it is approved, the build it admits can be posted.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/claude-on-minion-town-press-20260928-135605.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (643454 cached reads)
- Output: 5615 tokens
- Cost: $0.7257748
- Wall-clock: 85s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
