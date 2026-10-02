## Completion report — gauntlet clean stage, PR #1412

**Coverage pass on packages/claude** (the package this PR adds, alongside packages/inference which already had full test files): ran a baseline `c8 ava` and iterated per the coverage-driven-testing skill. Added 13 targeted tests across `cli-backend.test.js`, `sdk-backend.test.js`, `stream-reducer.test.js`, and `confinement-options.test.js` (plus extending the `_backend-fixtures.js` test harness to emit stderr in multiple chunks and accept a scratch-directory override), covering:

- the stderr ring-buffer trim once cumulative bytes exceed 64 KiB (CLI backend)
- a swallowed scratch-cleanup failure not replacing the turn result (both backends)
- a success result with no usage fields (usage omitted from the response)
- a result event missing `subtype` (falls to the generic "an error" detail)
- an SDK message that can't be `JSON.stringify`'d (BigInt field) still counting as zero bytes without crashing
- a guest-projection failure during SDK setup mapping to `unavailable`, not a thrown rejection
- a blank line and a message-less assistant event in the raw stream
- the `settingsPath` empty-string validation guard (mirroring the existing `mcpConfigPath` case)

Coverage improved: `cli-backend.js` 98.23%/89.83%→100%/95% stmts/branch, `sdk-backend.js` 95.23%/80.64%→100%/88.23%, `stream-reducer.js` 100%/94.02%→100%/98.57%, `response-shapes.js` 100%/94.59%→**100%/100%**. The one remaining stream-reducer branch (line 148, `lines.pop() ?? ''`) is a TS-required defensive fallback for `Array.prototype.pop()`'s type signature that can never actually fire given `String.split('\n')` always returns ≥1 element — documented, not deleted. No dead code found to remove in the touched files.

Pushed two commits to the PR head (`build/endo-claude-backends-1357`) via `safe-push-pr-head.sh`. The first CI run after my push caught a real defect in my own test commit — a TS2739 type error from an under-specified scratch-fixture override, plus an eslint `numeric-separators-style` violation — both fixed locally (verified clean with `tsc` and `eslint`) and pushed as a second commit.

The second push's CI run progressed to 29/33 checks green with 4 still in flight (guile-interop, macOS/ubuntu 22.x legs) when I had to stop polling. One check, `test (24.x, ubuntu-latest)`, failed — but the actual failure is `@endo/captp`'s `gc › test loopback gc`, a GC-timing-dependent test in a package this PR never touches (only `packages/claude` and `packages/inference` are in the diff). A rerun was attempted but refused since the workflow run was still in progress. I ran out of session budget before CI reached a terminal state and before I could confirm whether a rerun clears the unrelated flake.

**Follow-up needed:** re-run this clean stage (or just the CI-wait) to resolve the still-pending/flaky check; if `test (24.x, ubuntu-latest)` fails again on the same captp GC test, it should be retried rather than treated as a regression from this PR's diff.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 308 tokens (19200749 cached reads)
- Output: 71928 tokens
- Cost: $10.128366000000002
- Wall-clock: 9474s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
