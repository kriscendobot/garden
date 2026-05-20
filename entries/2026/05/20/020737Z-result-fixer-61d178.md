---
ts: 2026-05-20T02:07:37Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/20/005355Z-dispatch-steward-54bedd.md
---

PR #301 (`kriskowal-error-trace`) Node-22-only CI failure fixed.

**Reproduction**: the unhandled rejection did not reproduce on my host
(Node 22.22.2 Linux): three runs of `yarn ava --serial test/endo.test.js`
and a full `yarn test` of `@endo/daemon` (570 passed, 4 skipped, exit 0).
Root-cause analysis proceeded by reading the CI log signature directly.

**Root cause**: CI's `Unhandled rejection in test/endo.test.js` had value
`{'@@error': true, name: 'Error', message: 'Termination requested',
stack: ''}` — the exact wire shape that `messageToBytes` writes for
`CTP_DISCONNECT.reason` Errors (per #171 fix). `bytesToMessage`
JSON-parses but does not reconstitute, so captp settlers and
`quietReject(unplug)` Promises reject with a plain object rather than
an Error. The Node-22 (V8-12.x microtask scheduling) and AVA worker
exit-code path together surface a single derivative rejection from
teardown that slips past the harness's defensive `.catch(() => {})`s,
where the same path with a real Error never does. Not a rebase-resolution
slot-ordering mistake (verified: `controlPowers.makeWorker` arity in
`daemon.js:1513` matches signatures in `daemon-node-powers.js:502` and
`daemon-go-powers.js:167` at slot 9 = `marshalLoadError` /
`recordInboundOrigin`), and not a Node-22 V8 behavior change in the
captp/marshal hot path (those are unchanged on this PR).

**Fix** (`packages/daemon/src/connection.js`): `bytesToMessage` now
reconstitutes the `@@error` wire shape into a real Error in
`reviveErrorReason`, mapping the built-in subclasses
(TypeError / RangeError / SyntaxError / ReferenceError) by name and
preserving `message` and `stack`. The transform is narrow
(`CTP_DISCONNECT` with `@@error` reason only) and idempotent.
Regression tests in `disconnect-error-display.test.js` and
`render-rejection.test.js` updated to assert on the Error shape after
`bytesToMessage` (the on-the-wire shape from `messageToBytes` is
unchanged; only the receiver-facing post-parse value changed).

**Commit**: `be73bd002` (pushed to `origin/kriskowal-error-trace`).

**Verification**:
- `yarn ava --serial test/endo.test.js` post-fix: 156 passed, exit 0.
- `yarn ava test/disconnect-error-display.test.js test/render-rejection.test.js`: 13 passed.
- Combined run of `endo.test.js + error-trace.test.js + render-rejection.test.js + disconnect-error-display.test.js`: 176 passed, exit 0.
- `yarn lint:prettier`: clean.
- `yarn lint` typescript surfaces one pre-existing libp2p type error
  (`@libp2p/utils/src/adaptive-timeout.js` missing) that reproduces
  without my diff applied, so it is on the branch tip already.

**Follow-ups** for the orchestrator: re-trigger the failing 22.x matrix
jobs (run 26133510155, jobs 76863650930 ubuntu and 76863650949 macos)
against the new head `be73bd002` to confirm green. macos-15's
secondary failure was actually in `@endo/init`'s
`async_hooks Promise patch` test (timed out, separate from this PR's
payload) — that one is a pre-existing flake worth a separate look but
not in this fixer's lane.

Self-improvement: nothing this time.
