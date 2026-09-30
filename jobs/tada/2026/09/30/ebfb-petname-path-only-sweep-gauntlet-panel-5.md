Panel round 5 on endojs/endo-but-for-bots#1390 came back **must-fix**. `panel.sh` finished cleanly (exit 0) against head `082a97a1ee`, base `llm-8e53cc0` (`8e53cc0f89`).

**Seat results:** all 33 seats finished with no errors. 7 asked for changes (changeset-auditor, coverage-auditor, curator, purist, releaser, scribe, typist), 8 were comment-only and 18 approved. None of the round-4 must-fix items came up again.

**Verdict posted:** https://github.com/endojs/endo-but-for-bots/pull/1390#pullrequestreview-5372775984. It went up as a COMMENT review, not request-changes, because `kriscendobot` authored the PR and so can't request changes on it. Rounds 2–4 were posted the same way. The full aggregate was 89KB, over GitHub's 65,536-character limit for a review, so I posted a 50KB condensed version. It keeps the header, the must-fix and should-fix lists, the full text of every request-changes and comment-only seat, and one line listing the seats that approved.

**Must-fix items for the next fix round:**
1. **`workerName` type (typist):** `lal/tool-dispatch.js:478` casts through `unknown` to compare against the string `'undefined'`, but `workerName` is typed as a path array. Type it as `NamePath | string` and remove the cast.
2. **`@endo/lal` version bump (curator and changeset-auditor):** the changeset says `minor`, but renaming `petNameOrPath` to `petNamePath` breaks callers, so it should be `major`.
3. **Changeset is missing `@endo/conversation-tree` (releaser):** its source changed, so it needs a `patch` entry.
4. **Summary comment (scribe):** no summary comment covers the last 11 commits, `970f27de73`..`082a97a1ee`.

The should-fix items are in the review: a helper duplicated in four places, a dead `typeof` branch, an unvalidated spread in `prepareWorkerFormulation`, `.split('/')` calls in `chat.js`, stale parameter comments, a stale name in `claude-sandbox/DESIGN.md`, a suggested property test, and labels that can exceed the 255-character pet-name limit.

Nothing was fixed and the PR was not un-drafted; that is left to the gauntlet's next stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1056659 cached reads)
- Output: 7479 tokens
- Cost: $1.0309998000000002
- Wall-clock: 668s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
