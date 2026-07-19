---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-19T05:34:04Z
---
# xs2rust-endor press tick 20260719-050501 — String.split (string separator) closed; frontier now Object.fromEntries

Branch `xs2rust-endor` (PR #600, DRAFT) tip moved `7f8686284f` → `8eabbdefce`.

**Close:** `String.prototype.split` with a string/undefined separator
(`Unsupported("String.split:non-regexp-separator")`), transliterating
`fx_String_prototype_split` + `split_aux` + `indexOf_aux` exactly. Notable
finding: `indexOf_aux`'s scan meters **1 raw unit** (not 1·2¹⁴) per matched
lead byte — a C-XS `mxMeterSome(cond ? 1 : 0)` macro-precedence artifact the
oracle faithfully executes; measured as exact 1/3/9-raw deltas. Frame residual
4·2¹⁴+2·2⁸ fixed across all path shapes. 19/19 calibration probes delta-zero;
new suite `endor-262/tests/string_split_separator.rs` (7 tests).

**Frontier promoted:** the ~1 MB worker bundle now runs past the split into
`@endo/marshal`'s rank-order module and halts calling **`Object.fromEntries`**
(unbound: `typeof` probes "undefined" on endor vs "function" on the oracle) in
`fromEntries(entries(passStylePrefixes).sort(…).map(…))`. That static is the
next press tick's self-contained close (Object.entries already exists; the
iterator-protocol walk + CreateDataProperty metering is the work).

**Pre-existing raw-level gaps observed (not this tick's scope, recorded for a
future child):** (1) a string primitive `.length` read under-charges
2·2¹⁴+2·2⁸ raw (the GET-on-a-primitive wrapper seam — amplified past the
scaled-computron bar by any per-element `.length` map); (2) an
`Array.prototype.join` result over-charges 24 raw. Both invisible at scaled
granularity in isolation.

**Bars at `8eabbdefce` (observed):** engine workspace `cargo test --workspace`
797 passed / 0 failed EXIT=0; `compile-diff` 1909/1909 + SYMB 1909/1909 "BAR
MET" EXIT=0; `cargo test -p endo --lib` 110/0 (frontier marker promoted against
the real bundles, seeded bit-identical from ~/tmp/s9r — packages/ tree hash
equal). Zero new Rust warnings; `c/moddable` at pin `23b4d6b0a65f`, never
staged; no bundles committed. Peer `xs2rust-endor-stage10e-remeasure`
(measurement-only, other host) untouched by this push — its sweep pins its own
measured sha.

Finish line NOT met: worker bundle still halts before registering
`handleCommand`; `test:rust` daemon sweep is the remeasure peer's live run;
test262 parity continues per the staged roadmap.
