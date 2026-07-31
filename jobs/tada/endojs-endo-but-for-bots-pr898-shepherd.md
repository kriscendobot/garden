# Shepherd complete: endojs/endo-but-for-bots PR #898

PR: https://github.com/endojs/endo-but-for-bots/pull/898
Head before: f8c3923f4 -> after: e3ffe8f64
Green CI run: https://github.com/endojs/endo-but-for-bots/actions/runs/30591777791

## What was red

Two checks failed on the original head (run 30586808071):

1. **lint** (CI) - eslint error: `packages/reminder/test/plugin.test.js:10:11`
   `'setTimeout' is already defined as a built-in global variable` (no-redeclare).
2. **test (24.x, macos-15)** - flaky timing test
   `interval > ticking > reschedule retries with backoff`: "Expected retry tick,
   got 1 ticks".

Both were pre-existing in the base (upstream/llm), not introduced by PR #898's
own single commit (which touches only agentry/pi-agent.js, genie/agent/index.js,
and a changeset). They surfaced on this PR's CI because it is the head that
triggered the run.

## What I changed

Commit 866eced18 - fix(reminder): remove redundant setTimeout global directive
in test. Test files match `packages/*/test/**` in eslint.config.js, which
receives `...globals.node` (including setTimeout). The `/* global setTimeout */`
directive therefore redeclares a built-in global. Removing the directive fixes
no-redeclare. The `delay` helper continues to use the node-global setTimeout.
Verified: eslint and prettier pass on the file.

Commit e3ffe8f64 - fix(genie): widen reschedule-backoff test timing margins for
macOS CI. The test waited 30ms for the first (fire-immediate) tick and 100ms for
a 50ms-backoff retry. Under macOS CI timer jitter with concurrent ava workers,
those margins are too thin. Widened to 80ms and 250ms respectively. Verified:
test passes 5/5 runs locally; prettier and eslint clean.

## Result

All 25 checks green. mergeState: CLEAN, mergeable: MERGEABLE, 0 non-green checks.

## Classification

Class C (tractable) for both: a one-line lint fix and a timing-margin widening.
Both inline shepherd fixes, no fixer escalation needed.

## Follow-ups

- The `/* global setTimeout */` directive exists on upstream/llm in
  packages/reminder/test/plugin.test.js; the base branch is red on lint until
  this fix (or equivalent) lands there. Worth a separate base-branch fix if llm
  is actively maintained.
- The genie interval ticking test remains timing-dependent; the widened margins
  reduce but do not eliminate macOS flake risk. A deterministic fake-clock
  approach would be more robust if the flake recurs.
