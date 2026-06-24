---
ts: 2026-06-15T06:45:00Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/15/062100Z-dispatch-fixer-56a06a.md
---

Fixer addressed kriskowal's 2026-06-15T06:19:38Z COMMENTED review on
PR #58 (feat/error-tracing-implementation).

## Question and finding

The maintainer asked: "There's a hack in `@endo/ses-ava` that allows
the test harness to inspect the unredacted trace for an error, using
the internal tables installed by SES. Are we using that hack here?"

Answer: No. The trace aggregator was reading `err.stack` in two
places. Under SES with default `safe` errorTaming on V8, the public
`Error.prototype.stack` accessor returns `''`; the unredacted stack
lives in SES's internal `stackInfos` WeakMap keyed by error instance.
The two installed accessors are:

1. `globalThis[Symbol.for('MAKE_CAUSAL_CONSOLE_FROM_LOGGER_KEY_FOR_SES_AVA')]`
   in `packages/ses/src/console-shim.js`. This is the hack
   `packages/ses-ava/src/ses-ava-test.js` `makeVirtualExecutionContext`
   taps via `optMakeCausalConsoleFromLogger(originalT.log)` to surface
   unredacted causal traces (stack, cause chain, hidden `note(err)`
   annotations) to AVA's `t.log`.
2. `globalThis.getStackString(err)` (stack only) installed by
   `packages/ses/src/error/tame-v8-error-constructor.js` into the
   start compartment's permits as `%InitialGetStackString%`.

## Fix

Commit 2d3365cec lands `packages/daemon/src/unredacted-stack.js`, a
feature-tested helper that:

1. Calls the ses-ava causal-console factory with a buffer logger,
   invokes `causalConsole.error(err)`, joins captured args into a
   single string (the full unredacted rendering).
2. Falls back to `globalThis.getStackString(err)`.
3. Falls back to `err.stack` and then `''`.

Adopted at both production capture sites:

- `packages/daemon/src/worker.js` `makeWorkerPushTrace` (worker-side
  marshal-save hook).
- `packages/daemon/src/daemon.js` `makeOutboundMarshalSaveError`
  `@daemon` stub path.

`packages/daemon/test/error-trace.test.js` switches from raw `ava` to
`@endo/ses-ava/prepare-endo.js` so failing assertions surface the
unredacted error through the same causal-console path.

## Verification

- `corepack yarn workspace @endo/daemon ava test/trace-aggregator.test.js test/error-trace.test.js` — 25 tests pass.
- `corepack yarn workspace @endo/cli ava test/trace.test.js` — 3 tests pass.
- `corepack yarn workspace @endo/daemon lint:eslint` — 0 errors, 402 pre-existing warnings (2 fewer than baseline).
- `corepack yarn workspace @endo/daemon lint:types` — clean.
- Prettier check on the four touched files — clean.
- pre-push-gates probes: all probe failures (filename-no-stutter,
  no-ascii-banners, no-inline-import-jsdoc, no-pull-citations,
  no-non-ascii-in-source, security-md-hash-uniform, sentence-per-line-md)
  flag pre-existing files NOT in the diff; none of the four
  added/modified files trigger any probe. The auto-fix stage was
  skipped because it touched 25+ unrelated workspace files (Prettier
  drift across the repo); the diff was reset to the four intentional
  files only.

## Side effects on PR #58

- Pushed 2d3365cec to `feat/error-tracing-implementation`.
- Top-level comment posted: <https://github.com/endojs/endo-but-for-bots/pull/58#issuecomment-4705234535>.
- Re-requested review from kriskowal via JSON-body API; confirmed in
  `requested_reviewers`.

## Recommended next stage

`next: liaison`. The PR is back in the maintainer's queue with the
fix applied and review re-requested. No follow-on dispatch is needed
from this engagement.

Self-improvement: nothing this time. The fixer skill table already
covered the steps; the only friction was the pre-push-gates auto-fix
step touching workspace-wide Prettier drift, which is a known cost
of running auto-format in a monorepo and is handled by the existing
"reset and re-stage only intentional files" pattern.
