Press tick complete — took the wheel (the only live xs2rust peer is measurement-only) and closed the `String.split` string-separator frontier, bit-exact against the C-XS oracle.

## Completion report

**Job:** xs2rust-endor press driver, PR #600 (`endojs/endo-but-for-bots`, branch `xs2rust-endor`, base `llm`, kept DRAFT). Branch tip moved `7f8686284f` → **`8eabbdefce`** this tick.

**Peer check:** `xs2rust-endor-stage10e-remeasure` (other host, in `doin/`) is explicitly measurement-only — nothing pushed to the branch — so per charter this press pressed by default. The branch was 0 behind `llm` and MERGEABLE; no rebase needed.

**The frontier close (commit `8eabbdefce`):** the recorded frontier was `Unsupported("String.split:non-regexp-separator")`. Closed by transliterating `fx_String_prototype_split` (xsString.c, pin `23b4d6b0a65f`) exactly: the `fxNewArrayInstance` two-slot setup, `split_aux` per segment (slot + `fxNewChunk(len+1)`, empty segments still chunking), the per-character empty-separator loop, the empty-subject `[""]` case, ToUint32 limit semantics with mid-loop truncation skipping the tail, and the final `fxCacheArray` item chunk. The calibration surfaced a genuine C-XS artifact: `indexOf_aux`'s scan meter `mxMeterSome(cond ? 1 : 0)` expands unparenthesized, so `?:` binds looser than `*` and each matched lead byte meters **1 raw unit**, not 1·2¹⁴ — confirmed by exact 1/3/9-raw deltas across a partial-match ladder. Frame residual measured fixed at 4·2¹⁴+2·2⁸. **19/19 calibration probes delta-zero**; new suite `endor-262/tests/string_split_separator.rs` (7 tests: bit-exact matrices plus honest named skips for separator/limit coercion, non-ASCII/NUL, and `new String` wrapper receivers).

**Frontier promoted:** the real ~1 MB worker bundle now runs past the split into `@endo/marshal`'s rank-order module and halts calling **`Object.fromEntries`** (unbound — `typeof` probes "undefined" on endor vs "function" on the oracle), in `fromEntries(entries(passStylePrefixes).sort(…).map(…))`. The marker in `rust_worker.rs` is promoted; that static is the next tick's self-contained close. Two pre-existing raw-level gaps were also identified and recorded (string-primitive `.length` under-charges 2·2¹⁴+2·2⁸ — the GET-on-primitive wrapper seam; `join` over-charges 24 raw) — invisible at scaled granularity until amplified.

**Bars at the pushed tip (observed, real runs):** engine workspace `cargo test --workspace` 797 passed / 0 failed, EXIT=0; `compile-diff` 1909/1909 identical + SYMB 1909/1909, "BAR MET", EXIT=0; `cargo test -p endo --lib` 110 passed / 0 failed (marker test against real bundles, seeded bit-identically from `~/tmp/s9r` — `packages/` tree hashes equal). Zero new Rust warnings; `c/moddable` at pin, never staged; no bundles committed.

**Finish line: NOT met** (reported, not claimed): the worker bundle still halts before registering `handleCommand`; the `test:rust` daemon sweep is the remeasure peer's live measurement (not contended here); test262 parity continues per the staged roadmap.

**Recorded:** progress entry `entries/2026/07/19/053402Z-progress-gardener-717d44.md` with tip shas, bar evidence, and next-tick guidance. Inbox drained — empty.
