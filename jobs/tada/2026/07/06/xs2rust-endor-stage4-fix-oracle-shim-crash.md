The s11 recipient had already completed, so the message was dead-lettered for promotion (intent preserved per the message-bus contract). All work is done and pushed.

## Completion report

**Job:** `xs2rust-endor-stage4-fix-oracle-shim-crash` — oracle-shim SIGSEGV on whole-tree dual-runs (PR #600, `endojs/endo-but-for-bots`, branch `xs2rust-endor`).

**Root cause (one bug behind all three reported symptoms).** The stage-4b harden child's oracle-shim install (`63e6017999`) added `harden`/`lockdown`/`petrify`/`mutabilities` to the bare-boot global via `fxNextHostFunctionProperty`, but skipped the `mxPush(mxGlobal)` that `xst.c` performs first. That builder stamps each new host function's **HOME object** from `the->stack` at entry (`home.object = the->stack->value.reference`). With the global off the stack top, all four installed functions got a **garbage home pointer** (a stale frame slot read as a `txSlot*`). The GC's `XS_HOME_KIND` marker dereferences `home.object` (`aSlot->flag`, then recurses via `fxMarkInstance`) on the next collection, and the `Function.prototype.toString`/enumeration path reads it too — so any whole-tree run that walked the intrinsic graph (the Function/toString walkers) or churned allocations (Array concat/map/sort GC) **SIGSEGV'd the whole oracle process**. The same garbage home is why the ses-conformance child saw `lockdown()` crash the bare-boot shim. Confirmed empirically: reverting only the fix makes the walker regression test SIGSEGV (signal 11).

**Fix.** Push `mxGlobal` before the `fxNextHostFunctionProperty` chain so each function's home links to the real global — mirrors `xst.c` exactly. C-only change in the audited FFI seam (`endor-oracle/csrc/endor_shim.c`); no new Rust `unsafe`, `#![forbid(unsafe_code)]` intact on every engine crate.

**Bars (all met, re-certified on a fresh rebuild, no process abort, rc=0):**
- `built-ins/Function` — total=511 covered=40 divergent=0, wall ~<1s
- `built-ins/Array` — total=2625 covered=437 divergent=0, wall ~2s
- `built-ins/Object` — total=3127 covered=176 divergent=0 (unchanged), wall ~2s
- `stage4_harden_corpus_agrees_on_results_against_oracle` — green
- `cargo test --workspace -- --test-threads=1` — **EXIT=0** (checked `$?` directly, not piped), wall ~9–24s
- `lockdown()`/`mutabilities()` now **complete cleanly** (`undefined`) on the bare-boot shim instead of aborting

**Locked regression bar** (`endor-oracle/src/lib.rs`, 3 named tests — a SIGSEGV aborts the test binary, so a future shim widening that re-breaks home linkage fails a named cargo test instead of a whole-tree acceptance run): `shim_intrinsic_walk_and_gc_survive_installed_globals` (self-contained minimal equivalent of the two test262 walkers — walks globalThis, stringifies every reachable function, forces a GC), `shim_lockdown_call_fails_safely_not_segv`, `shim_mutabilities_call_fails_safely_not_segv`.

**Docs.** `rust/engine/README.md` stage-4 evidence updated: harden-child shim paragraph gains the crash-fix + re-certified numbers; the ses-xs-parity note's now-stale "`lockdown()` SIGSEGVs the shim" claim corrected (file stays pre-partitioned because endor still folds `lockdown` as `Halt::Unsupported`, but the oracle no longer aborts).

**Scope.** Kept to the shim regression. Did not touch the module-goal seam or the out-of-scope dual-run-survives-an-oracle-crash work. Committed with explicit pathspecs (gitlink `c/moddable` never staged — verified 0 occurrences), pushed `8f61d5fa6` to `origin/xs2rust-endor` via rebase-CAS (clean on attempt 1). PR #600 left DRAFT; no PR comment, no maintainer contact.

**Follow-up.** Completion report to `port-xs-to-rust-memory-safe-engine-s11` was dead-lettered (that gardener already finished) and promoted to a fresh job, so the intent is preserved.
