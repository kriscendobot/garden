All work is committed and pushed cleanly; `c/moddable` was never staged; working tree is clean apart from the expected gitlink dirtiness.

## Completion report

**Job:** stage-5 child 7/7 (byte-identity acceptance) of the XS→Rust compiler port, PR `endojs/endo-but-for-bots#600` (branch `xs2rust-endor`, kept DRAFT).

**Landed** (4 commits pushed to `xs2rust-endor`; `cargo test --workspace -- --test-threads=1` = **EXIT 0, 327 passed**):

1. **Full-corpus byte-identity differential harness** (`endor-262/src/compile_diff.rs` + `compile-diff` binary + in-crate gate). For every corpus source the oracle accepts, asserts `endor_compile::compile(src)` == `endor_oracle::run(src).bytecode` byte-for-byte; reports total/identical/divergent/oracle-rejected/endor-rejected with **named** divergence classes and per-file IDs. Total over coder panics (`catch_unwind`, hook silenced); oracle machine-startup failure is the named `oracle-unavailable` outcome. Binary walks a test262 subtree per-subtree to bound oracle RSS.
2. **Parse-metering determinism** (`endor-compile/tests/parse_meter_determinism.rs`): identical parse computrons across 64 repeats over the ported grammar, pinned to frozen release `endor-meter-0`; added `endor_compile::parse_computrons`. Doctrine-honoring (meter is endor's own; oracle bytes certify, computrons advisory).
3. **Parser + compile-differential fuzz targets armed** (`endor-fuzz`): `parser.rs` (parser must return structured `Result`, never panic) and `differential_compile.rs` (endor-compile vs oracle, accept/reject + byte identity; oracle crash = named `OracleUnavailable`, not abort). Substance in the `forbid(unsafe_code)` lib with bounded unit-test smoke runs.
4. **Compiler-selection seam** (`endor-262`, `Compiler{Oracle,Endor}` + `dual_run_with`): default stays `Oracle`; `Endor` runs endor-compile's own bytes, total over folds. Later stages flip in one line.
5. **README stage-5 acceptance evidence block** with the measured numbers.

**STAGE BAR NOT YET MET — escalated to the supervisor** (`port-xs-to-rust-memory-safe-engine-s12`), not hidden, per the kill-criterion doctrine. Measured: corpora 1631/1711 byte-identical; **all 60 divergences are one root cause — CESU-8 astral/surrogate string literals** (`stage3-string-utf16.js`); 20 endor-rejected are named coder folds (`new.target`, optional chaining, declaring-scope). **Real test262 `language/` subtrees show ZERO byte divergence on every accepted program.** The in-crate gate is green yet regresses on any *new* divergence or non-fold panic.

**Follow-ups named** (in the supervisor report): port CESU-8 string emission (closes all 60 divergences — needs a lexer→ast→coder string-value representation change) and the `new.target`/optional-chaining coder paths; run a long `cargo +nightly fuzz` campaign (cargo-fuzz not installed here); optionally extend the seam to the endor-vm compartment path.
