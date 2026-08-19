---
kind: result
role: wire-watcher
host: endolin-garden-ece02cb4
at: 2026-08-19T13:21:12Z
---
Code-panel juror block for `endojs/endo-but-for-bots` PR [#1040](https://github.com/endojs/endo-but-for-bots/pull/1040) (base `origin/llm` @ `c6b70e8fdb98`, head `5cffd2846d7d`), seat `wire-watcher`, round 5, dispatch `endojs-endo-but-for-bots-pr1040-gauntlet-panel-5`.

### wire-watcher

**Verdict:** request-changes

**Findings:**

- should-fix. `packages/hardened262/scripts/agents/node.js:46` and `packages/hardened262/scripts/agents/xs.js:44` `spawn()` a test-subject child with no timeout and no `child.on('error'/'close')` path that ever kills it. The harness's own async protocol (`scenario.js:78-89`, mirroring test262's `doneprintHandle.js`) depends on the subject calling `$DONE` to print a completion marker; a subject that never calls it (an infinite loop, a promise that never settles, an `async` case whose completion path is buggy — exactly the corpus this package exists to stress) leaves the child running forever. `scripts/test.js`'s `runTests` awaits each scenario sequentially, so one non-terminating case wedges the entire run: no report, no exit code, no signal to the caller that anything is wrong. This is the failure path the seat's brief asks be documented for a protocol state machine crossing a trust boundary (untrusted-shaped test bodies driving process lifetime), and it currently has none. Add a per-scenario timeout that kills the child and reports a distinct `timeout` outcome (not laundered into `skip` or `ok`). [rule: roles/jurors/wire-watcher/AGENT.md § Protocol state-machine invariants]

- should-fix. `scenarioOk` (`packages/hardened262/scripts/agents/scenario.js:80-89`) decides pass/fail from unanchored substring matching over the full captured stdout: `stdout.includes(asyncFailureMarker)` / `stdout.includes(asyncCompleteMarker)`. This is the same shape as the in-band marker hazards the seat watches for — the pass/fail signal lives entirely in freeform text the subject controls, with no anchoring (e.g. exact-line match on the final printed line). For the curated, checked-in corpus this ships with, the practical risk is low, but the golden suite (`scripts/scenarios.test.js`) only tests the marker present-alone or absent-alone; it never tests the marker text appearing incidentally inside unrelated output (a test that legitimately prints a string containing that substring, or an error message that echoes it), so the "syntactically-valid-but-almost-certainly-wrong" class this seat's brief calls for is untested. Anchor the match (last non-empty printed line equals the marker, not `.includes`) and add that test case. [rule: roles/jurors/wire-watcher/AGENT.md § In-band-marker trust-bypass, § Failure-mode test catalog]

**Notes (out of scope but worth flagging):**

- The false-pass direction this seat cares most about — an async test that exits 0 without ever printing `Test262:AsyncTestComplete` being laundered into a pass by exit-code-only logic — is correctly guarded here (`scenarioOk`'s third branch, backed by `scripts/scenarios.test.js`'s "requires a declared-async case to signal completion" test). Calling that out because it is exactly the class of regression the panel's own `scenario.js` comments say a prior round already found and fixed; the pattern held on re-review.
- No hash/identifier/bundle-integrity surface is touched by this PR (it is a static, checked-in test262-style mirror + a local subprocess test runner, not a loader over untrusted bytes), so the seat's primary "check before trust" and identifier-discipline axes have no applicable code in this diff.

Self-improvement: the seat's brief is written against bundle/hash/capability trust boundaries; this PR has none of those, so the productive move was generalizing the "in-band marker" and "protocol state-machine failure path" lenses to the test harness's own pass/fail/hang determination rather than reporting no findings. Nothing to route as a rule change — the existing brief language already covered this once generalized.
