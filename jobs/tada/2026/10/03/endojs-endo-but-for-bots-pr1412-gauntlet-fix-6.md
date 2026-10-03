# Gauntlet fix round 6: endojs/endo-but-for-bots PR #1412

I fixed all eight seats that asked for changes in round 6 and pushed the fixes to `build/endo-claude-backends-1357`. CI is green: all 33 checks finished with 0 failures, and `ci-wait-merge` returned rc 0.

## Commits pushed
The head moved from `0674323ba9` to `aa09ea465a`.

1. **`f4fae43852` fix(claude)**
   - **breaker:** After a turn is stopped, `untilTerminated` no longer races the awaited promise against the stop signal. When both are already settled, `Promise.race` picks the first one listed, so before this fix a party that answered immediately could keep winning after the turn was stopped.
   - **saboteur:** A fractional count ceiling (such as `maxTurns: 1.5`) passes the request shape check but is refused by the limit enforcer. It now returns an `unavailable` result ("limits refused") in both backends instead of rejecting `infer`.
   - **fast-checker, prover, breaker:** New `test/turn-guard.test.js` with direct tests of the race, of late cleanup, and of `acquireAdmission`. It also has fast-check properties showing that `errorCategory` never depends on the error message and only returns a vetted code, a vetted name, or a kind.
   - New backend tests cover the fractional-ceiling case.
2. **`d88d3e9859` test(inference)**
   - **prover:** The old test passed even without the retention fix. The new test forces garbage collection and checks that a stopped enforcer is not kept alive by a long-lived cancellation. I confirmed it fails when the line `cancellation.onCancel = undefined;` is removed from `stop()`, and it passed in 3 repeated runs.
3. **`aa09ea465a` docs(claude)**
   - **archivist:** The design's Status row now matches its Status section.
   - **integrator:** The design and README now record that the guest's stdio MCP server also receives the credential, because it inherits the binary's environment (#1369 Gap 2). The README also explains why these backends may put the credential in the environment even though `FORBIDDEN_ENV_KEYS` forbids that for the `make()` provider's child.

## PR body and comment
- **pruner:** Removed the Documentation Considerations section and the #1015 sentence.
- **integrator:** Security Considerations now names Gap 2.
- **scribe:** Posted a summary comment covering rounds 1, 5 and 6 (issuecomment-5968502113), including what was declined or deferred.

Locally, `@endo/claude` passed 164 tests and `@endo/inference` passed 53. Lint shows 0 errors; the only warnings are the `safe-await-separator` kind that the files already had.

## Deferred (not must-fix)
- Saboteur's should-fix: the SDK backend converts each whole message to JSON before checking the byte ceiling.
- Fast-checker's lower-priority items: property tests for the `limits.js` counters and the `classify.js` delay check, and adding `fast-check` to `@endo/inference`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (4584927 cached reads)
- Output: 26873 tokens
- Cost: $2.3470454000000003
- Wall-clock: 3959s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
