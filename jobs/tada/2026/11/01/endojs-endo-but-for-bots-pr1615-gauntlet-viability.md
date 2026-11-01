**Gauntlet viability: endojs/endo-but-for-bots#1615**

PR #1615 is open, still a draft, and was opened today (head `e3235884`, base `llm-9a14ddf`). It has no reviews or comments yet. It is the seventeenth coverage-crank slice of the test262 ratchet: it makes async-generator awaits read the awaited promise's `constructor`, which `PromiseResolve` requires and the current fast path skips.

Deciding question: On the current `llm`, do the six `AsyncGeneratorPrototype/return/*-broken-promise*` rows still fail without the PR, with no other change, landed or open, already making the async-generator await read the promise's `constructor`?

Evidence: The answer is yes.
- **`llm` has not moved.** Comparing the frozen base `9a14ddf` with `llm` shows 0 commits ahead, so the PR's base is current.
- **The rows still fail on live `llm`.** The `AsyncGeneratorPrototype/return` expectation shard on `llm` still records all six rows (completed, suspendedStart, and suspendedYield-try-catch, each in sloppy and strict) as `fail`.
- **The fix hasn't landed.** `suspend.rs` on `llm` has no `async_generator_await_route`.
- **No other PR competes for these rows.** Searching open PRs for "broken-promise" and "AsyncGeneratorPrototype" turns up only #1615 and #1602, and #1602 covers the disposal methods, not these rows.
- **Siblings only shift a baseline.** The PR notes that #1599 (AsyncFromSyncIterator close) may need one shard re-baselined on rebase. That doesn't make this PR's change redundant.

Nothing has replaced this PR and its motivation still holds, so the gauntlet may begin. I spent nothing on the clean, panel, fix, CI-wait or un-draft stages.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1615-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (184131 cached reads)
- Output: 1696 tokens
- Cost: $0.4615542
- Wall-clock: 28s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
