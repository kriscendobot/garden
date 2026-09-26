The remote head matches my commit (`39665c235d`). The work is complete and pushed. Let me write the completion report.

---

## Completion report

**Job:** Builder — corpus → test262 cases conversion (PR #600, `endojs/endo-but-for-bots` branch `xs2rust-endor`, test262-convergence child 2/5). Pushed as commit `39665c235d` to the PR head (PR stays **draft**).

### What I did

**Built the `corpus-to-262` converter** (`rust/engine/endor-262/src/bin/corpus_to_262.rs`). For each of the 1,711 corpus lines it dual-runs the program once against the C-XS oracle to record the completion/abort at conversion time, then emits one standard test262 case:
- `assert.sameValue((<expr>), <lit>)` for a primitive completion the oracle's `String()` round-trips to a literal (number/boolean/string/undefined/null/bigint), with **-0 recovered** via an `Object.is` oracle probe and the expression validated as parenthesizable via a `typeof` probe;
- a `raw` verbatim body (oracle-relative, bit-preserving) for non-reconstructable completions (object/array/function/symbol), multi-statement programs, and bare primitive `throw`s (a matching shared abort the dual-run covers);
- `negative: { phase: runtime, type: <Ctor> }` for real `Error` throws.

Each assert body is **verified at conversion time** against the runner's harness; one whose wrapper perturbs metering on a meter-exact corpus is downgraded to `raw`, so the generated bit-exact set equals the corpus's exactly.

**Generated `cases/`** (`cases/language/**`, `cases/built-ins/**`): strictly 1:1 — 1,711 lines → 1,711 cases (837 spec-anchored asserts, 870 raw, 4 runtime negatives). Endor gating rides `features:` markers (`endor-dual-run`, `endor-meter-exact`, `endor-meter-determinism`); each case preserves its original line in `info: Source:`. The meter contract never enters a case body.

**Proved coverage equivalence** (`tests/corpus_conversion_equivalence.rs`, and `endor-xst endor-262/cases --gate-meter-exact`): **total=1711 covered=1711 failed=0 skipped=0** — same totals, zero divergence, same bit-exact set under `--gate-meter-exact` (the 34 computron advisories are exactly the result-parity corpora — utf16 string values, transitive harden, cross-compartment eval — which never claimed bit-exact metering). Also extended `endor-xst` to accept a case directory/file path directly (as `xst` does).

**Retired by name** (gated on the proof): the 31 `corpora/*.js` line files, the 28 `stage*_corpus()` accessors + their per-stage bit-exact tests, and the stage-1 `harness.rs` CLI. The stage-5 byte-identity gate (`corpora_programs`) is repointed to read the same programs from the surviving cases' `info: Source:` lines (verified total=1711 identical=1711 divergent=0); `parse_corpus` survives for the converter. `corpora-modules/` (module compile-diff inputs) is untouched.

### Verification
- Enabled the `c/moddable` submodule (was uninitialized) so the C-XS oracle builds.
- Full `endor-262` lib suite: 32 pass. The equivalence integration test passes. Byte-identity gate reads 1,711 cases, all identical.

### Follow-ups / notes
- **Pre-existing, out-of-scope failure:** `compile_diff::tests::module_corpora_byte_identity_no_divergence` fails with a 1-byte `top-level-await` module-goal-flag divergence (endor-compile emits 1 byte longer). This is stage-5 `endor-compile` module codegen, reading the untouched `corpora-modules/`; my diff is provably isolated to `endor-262` and touches no `endor-compile`/`endor-oracle`/`corpora-modules` path, so this failure is independent of this work. Flagging for the stage-5 endor-compile track.
- **Submodule pin discrepancy** worth a maintainer glance: the recorded `c/moddable` gitlink is `5516726…`, while the design Ground Truth cites pin `48ee02d8cfe0` and `build.rs` cites `23b4d6b0a65f` (moddable 8.3.1). All metering + the 1,711-case bit-exact proof pass against the recorded gitlink, so it is the effective calibration; the doc pins are stale relative to the gitlink.
- Curation pass (merging related one-liners into richer cases) and the `cases/regressions/` fuzz-trophy tree remain later steps in the design's rollout (steps 3–5), as intended.
