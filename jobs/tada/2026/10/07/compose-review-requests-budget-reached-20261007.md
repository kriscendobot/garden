## Completion report: compose-review-requests-budget-reached-20261007

I sent three review requests to the maintainer inbox and archived the five matching budget-reached notices. I didn't request any GitHub reviews or approve anything. No garden commits.

**How I sent them:** `send-msg.sh maintainer` doesn't work, because `maintainer` isn't an address it accepts (only `role/`, `job/`, `host/` and `broadcast`). I used `message-user.sh` with `GARDEN_MSG_ID` set to each key instead. That is the same route the existing `review-request-*` inbox entries came through, so a re-send updates the existing entry instead of adding a duplicate.

**Messages sent** (each has the PR link(s), arc, a two-line summary, current CI, the round-6 findings with what fix round 6 says it did, what is still open, why the review didn't converge, and where to look first):
1. `review-request-endojs-endo-but-for-bots-pr1398`: SturdyRef layer 8, arc endo-ocapn-background. CI is green at `afc5c25c1f`. The request-changes seats changed every round; only prover (tests) came back each time. Still open: breaker's note about the gap between writing the record and setting `formulaForId`, and a test through the real daemon core, which is deferred to layer 9.
2. `review-request-endojs-endo-but-for-bots-pr1426`: Familiar security-warning banner. Arc is unallocated (Familiar release). CI is green at `159ea0ff3c`. It went through two gauntlets, 12 rounds in all. Round 6 found a real bug in matching `~` versus `%7E` in the Chat page URL, and fix 6 fixed it. Still open: an optional type check on `callback` in `preload.mjs`.
3. `review-request-kriscendobot-minion-town-pr151`: one message for the whole stack, arc garden-upkeep, all heads CI green. Two things in it go beyond what the job described:
   - **kriscendobot/minion.town#153 sits in the stack.** The stack is actually #151 → #152 → #153 → #154. #153 passed panel round 1 and is already out of draft, so the message lists it in the review order but doesn't ask for a review of it.
   - **The stack's frozen bases are stale.** #152's base is 20 commits behind #151's head, #153's base is 6 behind #152's head, and `main-a378bb3` is 59 behind main. It will need a restack before merge.
   - The message also flags a security issue in #152: each deploy run resets the `UserPoolAddOns` advanced-security setting to its default. The old shell script had the same problem.

**Caveat in all three messages:** fix round 6 says it addressed every round-6 must-fix, but the budget stopped the gauntlets before a seventh panel could check that. The messages call those items "fix claims addressed, not re-verified."

**Archived** (unread → read): the budget-reached notices for `endojs-endo-but-for-bots-pr1398-gauntlet`, `build-familiar-localhttp-protocol-gauntlet`, and `minion-town-shell-to-js-20261004-part{1,2,3}-gauntlet`. #1426's second gauntlet (`endojs-endo-but-for-bots-pr1426-gauntlet`) had no unread notice to archive.

**Follow-ups (not done):**
- `endojs-endo-but-for-bots-pr1124-gauntlet-review-budget-reached.md` is still unread. It wasn't in this job's scope.
- The job told workers to use `send-msg.sh maintainer`, which fails. Future job bodies should name `message-user.sh` with `GARDEN_MSG_ID`, or `inbox-send.sh maintainer`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/compose-review-requests-budget-reached-20261007.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2247171 cached reads)
- Output: 14561 tokens
- Cost: $1.4321982000000002
- Wall-clock: 232s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
