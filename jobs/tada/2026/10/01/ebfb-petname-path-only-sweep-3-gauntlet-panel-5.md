## Panel round 5 for PR #1390: must-fix

The panel ran one single-round review against head `4427342873` and base `llm-8e53cc0` (`8e53cc0f89`). `panel.sh` exited 0 and returned **must-fix**. All 33 seats finished and none errored: 9 requested changes, 7 were comment-only and 17 approved. The verdict is posted as a comment review: https://github.com/endojs/endo-but-for-bots/pull/1390#pullrequestreview-5383128474. It's a comment rather than a request-changes review because the bot (`kriscendobot`) opened the PR and can't request changes on its own PR; earlier rounds were posted the same way.

**Must-fix items in the review:**
1. **Stale type field:** `packages/lal/agent.types.d.ts:33` still declares `petNames`, but the code now reads `petNamePaths`. The compiler doesn't catch it because `tool-dispatch.js` is marked `@ts-nocheck`.
2. **Pet names still split on `/`:** this happens in about a dozen places before a name is handed to a daemon method that expects a path. Files include `command-executor.js` (the channel-mode `reply` previews one value and sends another; also `adopt` and `eval`/`js`), `send-form`, `chat-bar-component`, `value-component`, `space-chat/inbox`, `space-channel/outliner`, `use-file-explorer` and `fae/endo-skill`. Commit `01ed8e0d64` fixed this pattern elsewhere. Splitting turns a flat name into a nested address, which widens authority.
3. **Tests don't cover the slash case:** the tests for `01ed8e0d64` only use names without a `/`, so reverting the fix wouldn't make them fail.
4. **PR body and changeset:** the "Relationship to other work" section says the same thing twice, and the changeset (592 words) should be cut to what users of the packages need to know.

**Should-fix items:** the `editMessage` JSON schema still advertises a bare string, the scratch name built in `host.js:1799` can exceed the 255-character limit, and the design doc needs a cross-reference.

**Automatic checks:** the phase/evidence check is still **BLOCKED** on `designs/fs-interface-consolidation.md`, which forces a must-fix result no matter what the seats say. The PR-body template check flagged an invented heading, and the PR-body length check fired at 477 words against a 300-word limit.

The full panel output is about 85 KB, over GitHub's review size limit, so the posted review has it truncated to about 62 KB. Following the job spec, I did not fix anything, did not un-draft the PR and did not loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-3-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (881735 cached reads)
- Output: 6207 tokens
- Cost: $0.8960949999999999
- Wall-clock: 832s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
