Clean stage for endojs/endo-but-for-bots PR #774 (`@endo/sturdyref` first-wins shim) is done: CI is green at head `ef4662f04b`, and I pushed nothing.

**Coverage pass.** I read the new code in `packages/sturdyref/src/sturdyref-shim.js` and checked it against the four test files by hand; I did not run coverage locally. Every error path has a test:
- a handler that isn't an object;
- a handler whose `enliven` is missing or not a function;
- calling the constructor without `new`;
- `SturdyRef.enliven` on a non-ref, including `undefined`;
- a malformed `globalThis.SturdyRef` already present;
- setup both before and after `lockdown` (the freeze path and the harden path).

The first-wins adoption also has its own test file. The package is entirely new, so the change leaves no orphaned code, and the CI coverage jobs on Node 22.x and 24.x were already green.

**CI.** At claim time, 32 of 33 checks were green. The exception was `test (22.x, macos-15)`: in `@endo/daemon`, `test/endo.test.js` exited non-zero with 1 unhandled rejection (1,338 tests passed). The daemon doesn't depend on `packages/sturdyref`, which is the only code this PR adds.
- I re-ran the failed job. It went red again on the same cell with a different test: `@endo/hosted-agent`'s `provider-http › HTTP deadline releases late readers …` hit its test timeout, and the rest of the run was stopped with SIGINT. That package is unrelated to this PR too.
- A second re-run passed. `ci-wait-merge.sh --no-merge` ended with rc 0, 33 of 33 checks and 0 failed.

**Follow-up (optional):** the macOS 22.x cell looks flaky across several packages (`@endo/daemon` unhandled rejection, `@endo/hosted-agent` deadline timeout). It may deserve its own flake-tracking job.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 102 tokens (3044013 cached reads)
- Output: 13797 tokens
- Cost: $1.8818866000000003
- Wall-clock: 6611s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
