Inbox empty. All work complete and verified. Writing my completion report.

---

## Completion report: Stage 6 child 1/6 — flip the compiler-seam default to endor-compile

**PR** `endojs/endo-but-for-bots` #600, branch `xs2rust-endor` (kept DRAFT). Pushed commit `be53dd526c8d23ca5669f6d921a69820ce6421f6`.

### What I did

1. **Flipped the pipeline seam default** (`rust/engine/endor-262/src/lib.rs`, the `Compiler` enum): moved `#[default]` from `Compiler::Oracle` to `Compiler::Endor`. `dual_run`, `dual_run_async`, and every default-compiler path now run endor's own bytecode; the oracle remains a selectable differential reference and is still consulted for the reference result/computrons.

2. **Endor emits its own SYMB atom.** Added `compile_atoms` / `compile_atoms_with` / `compile_module_atoms` to `endor-compile` (return `(bytecode, symbols)`). The coder serializes the symbols atom in the exact C-XS `fxParserCode` wire format — 2-byte LE count `= used+1`, then each used symbol's bytes + NUL, walked buckets-in-index-order/most-recent-first (the same `assign_ids` walk that numbers the operands, verified against `xsCode.c` lines 581–1027 and `xsScript.c`'s `fxNewParserSymbol`). The seam's `Endor` arm stops cloning `oracle.symbols` and pairs endor bytecode with endor symbols.

3. **Committed byte-identity gate for the atom:** `compile_diff::symbols_diff_programs` + `print_symbols_report`, the `corpora_symbols_atom_byte_identity` locked test, and wired into the `compile-diff` binary (fails closed on any SYMB divergence).

4. **Flipped the standing residual:** `compartment_dual_run` (the endor-vm compartment-evaluate path the review ledger named) now evaluates endor's own bytecode/symbols; oracle stays the reference only.

### Verification (all EXIT=0)
- `cargo test --workspace -- --test-threads=1` → **EXIT=0**, every `test result:` line `0 failed` (42+93+105+82+26+… all ok). New tests `corpora_symbols_atom_byte_identity`, `compiler_seam_endor_matches_oracle_on_byte_identical_programs`, `compiler_seam_endor_fold_is_a_clean_abort_not_a_panic` all pass.
- `compile-diff` (no arg) → **EXIT=0**, `1711 identical, 0 divergent` (bytecode) **and** `symbols-atom byte identity: checked=1711 identical=1711 divergent=0 (skipped=0)`.
- Stage-4 spot-checks under the flipped default (endor's own bytecode via `dual_run`): `built-ins/Object` 182 covered / 0 failed, `built-ins/Function` 43/0, `built-ins/Array` 487/0 — all floors hold, EXIT=0.

### Grep-proof — every remaining `endor_oracle::` call site, classified
No DEFAULT execution path invokes the oracle compiler for the bytecode endor runs. Each site is (a) a differential **reference**, (b) a byte-identity/fuzz **harness**, (c) converter **tooling**, or (d) an oracle-only **example/test**:

- `endor-262/src/lib.rs` `dual_run_with:195`, `dual_run_async:295`, `compartment_dual_run:495` — **reference** (`oracle.run` supplies result/computrons; the bytecode endor runs comes from `compile_for(default=Endor)`). KEEP.
- `endor-262/src/lib.rs` tests 716, 966, 967, 1033 — reference in tests. KEEP.
- `endor-262/src/compile_diff.rs` `oracle_compile:117`, `oracle_compile_module:131`, new `oracle_symbols:483`, test 856 — the **byte-identity differential** reference. KEEP.
- `endor-262/src/bin/corpus_to_262.rs` 266/300/340 — corpus→test262 **converter tooling** (dual-runs to emit cases). KEEP.
- `endor-compile/tests/coder_byte_identity.rs` 115/164/1775, `corpus_parse_smoke.rs` 38 — byte-identity **reference tests** (dev-dep). KEEP.
- `endor-fuzz/src/lib.rs` 1539/1587/1631/1764, `regexp.rs` 224 — differential **fuzz harnesses** (VM-vs-oracle / compile-vs-oracle; feed oracle bytecode to isolate the VM). KEEP.
- `endor-oracle/examples/probe.rs:71`, `modprobe.rs:60`, `endor-regexp/tests/parity.rs:20` — oracle **examples / parity test**. KEEP.

The oracle crate stays in the workspace for differential harnesses only: `endor-vm` has **no** oracle dependency and `endor-compile`'s is `[dev-dependencies]`, so the shipped engine (endor-vm + endor-compile lib) never links the oracle.

### Follow-ups
- None blocking. The remaining stage-6 children (2/6–6/6) proceed under the parked orchestration; this child delivered the default flip + endor's own symbols emitter with committed gates. Branch is green.
