I recorded kriskowal's two answers (comment 5939221667) in the design doc on endojs/endo-but-for-bots PR #1116 and pushed the change to the PR branch.

**Preflight:** it exited 2, a hint that the feedback might already be handled, but there was nothing to name. The only matching text was the bot's own "On it" acknowledgement (comment 5939254605), and no commit had landed since f7b82cba0b. So I did the work.

**Changes to `designs/guest-native-invitations.md`:** one commit, e70a960422, pushed to `design/guest-native-invitations`.
1. **How `accept` reports its outcome.** The maintainer prefers returning passable discriminated unions or labeled tags. Open Question 7 is now marked resolved: `accept` returns a `{ status }` record (including `revoked`) instead of the errors that #1310 throws. The "Implementation status" table still lists the change as work to do and now notes the maintainer confirmed it.
2. **#1277.** The maintainer asked for it to be retired. The "In flight" entry and Open Question 2 no longer say #1277 must be reconciled with this design before it lands. They now say it is being retired, so no reconciliation is needed, and that any gap it leaves will be designed again later. Per-invitation pins are still out.
3. The Open Questions intro now cites the comment that answered question 7.

**Reply:** I posted a summary to the maintainer on the PR as https://github.com/endojs/endo-but-for-bots/pull/1116#issuecomment-5942421574, marked as the reply to comment 5939221667.

**Follow-ups:**
- Switching #1310's thrown errors to the returned `{ status }` record is still code work. The design lists it as remaining work, but no build job for it is on the board yet.
- Retiring #1277 is up to the maintainer.
- PR #1116 is still a draft.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `7f2207af`; this job presented `e70a96042289cf593d28de07459cad1fb93ff51c`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1116-f1ab5121.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (461969 cached reads)
- Output: 4053 tokens
- Cost: $0.5843418
- Wall-clock: 66s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
