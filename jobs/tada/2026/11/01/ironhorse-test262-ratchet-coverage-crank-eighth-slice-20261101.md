# Eighth Ironhorse test262 ratchet slice: global declarations made by `eval` (6 rows now pass, 41 false failures reclassified, none lost)

I opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1614. Its head branch is `ironhorse-test262-ratchet-eval-global-decl-20261101` and its base is the frozen `llm-9a14ddf`. It carries the `garden-arc: ironhorse-test262-ratchet` marker.

**Choosing the slice.** The draft PRs already open for the other slices (#1599–#1612) covered RegExp, TypedArray, Promise, Proxy, Object, the global object's prototype, `with`, disposal, strict stores and iterator tags. I sent the tenth and fourteenth slices a message over the inbox naming the rows and shards I was taking, and neither objected. I took the `language/eval-code` failures, which are about how `eval` declares global names. Temporal stays excluded.

**Engine fix** (`ironhorse-vm/src/interp/environment.rs`):
- **Check everything before creating anything.** All global declarations are now checked before the first one is created. Before, `(0,eval)("function a(){} function NaN(){} function b(){}")` threw the TypeError but still left `b` defined.
- **Redefining an existing global.** A function declaration over an existing configurable global now makes it writable and enumerable. It stays configurable under `eval`, which is the spec's `CreateGlobalFunctionBinding` step 5.

**Test-runner fix** (`ironhorse-262/src/{lib,xst}.rs`):
- **The bug:** the runner decides a mismatch is caused by XS's eval framing by re-running the test body under that framing and checking it fails the same way. It re-ran the body without the test262 harness, so the re-run always died on `get assert` and never matched. Real framing gaps were therefore scored as Ironhorse over-acceptance failures.
- **The fix:** each run now records the setup scripts that ran before the body, and the re-run executes them first. The re-run's error must still equal XS's exactly.

**Ratchet.** I swept all 1549 non-Temporal whole-tree batches with the release build. Only the intended rows changed, in 11 shard files, and I regenerated those.
- **6 rows fail → pass:** `non-definable-function-with-{function,variable}` (sloppy and strict) and `var-env-func-init-global-update-configurable` (direct and indirect, sloppy).
- **41 rows fail → `skip:oracle-xs-script-decl-eval-framing`:** these are in `eval-code`, `global-code`, `delete`, `variable`, `function`, `reference`, and the built-ins `Function`, `Array/from` and `global`. They were XS framing gaps scored as Ironhorse failures, so skip is the honest result.
- **No losses.**

I did not add a `baseline/refresh-*` floor directory, because the open question on kriscendobot/garden#51 governs that.

**Tests:**
- **New:** `tests/eval_global_function_bindings.rs`, three tests where Ironhorse and XS must agree. Two of them fail on unpatched `llm`.
- **New:** a unit test showing that the re-run now includes the harness setup, and that a mismatched error still fails.

**Checks I ran locally, all passing:**
- **Test suites:** `cargo test --release -p ironhorse-vm -p ironhorse-262`.
- **Test configurations:** deterministic-math with store-integrity, cost-calibration, and consensus.
- **Expectation gates:** `try.txt`, and `ironhorse.txt` run three times (1712/1712).
- **Formatting and lint:** `cargo fmt --check`, and clippy 1.88.0 run the way CI runs it.

**CI:**
- **Passing:** 28 checks, including `test-ironhorse`, `-release`, `-macos`, `-calibration`, thixotrope, fuzz, wasm, cross-target, lint and all the JS legs.
- **Failing:** `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers`. I checked both logs: they fail only on `stage3-math/054.js` and `055.js`, where `Math.asinh` and `Math.acosh` differ from XS in the last digit. That failure is already on `llm`, and #1585 tracks it. I said so in a comment on the PR.

**Follow-ups:**
- #1609 (global object prototype) changes other rows in two of the same shard files (`global-code`, `statements/function`). Whichever PR lands second may need a trivial merge there.
- The remaining sloppy-mode XS over-acceptances (`for-of` destructuring into a `const`, and `annexB` catch redeclaration) are XS bugs, so I left them alone.
- The PR stays draft until the gauntlet runs.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-ratchet-coverage-crank-eighth-slice-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 192 tokens (12394328 cached reads)
- Output: 45927 tokens
- Cost: $4.7640936 (1 engagement(s) unpriced)
- Wall-clock: 13835s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
