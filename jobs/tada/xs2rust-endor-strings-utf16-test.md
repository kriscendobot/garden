All work complete and pushed. Final report follows.

---

## Completion report: `xs2rust-endor-strings-utf16-test` (child 3/3)

Proved result parity + recalibrated meter for the CESU-8 → UTF-16 string storage swap on `endojs/endo-but-for-bots` branch `xs2rust-endor` (PR #600, kept DRAFT). Two increments pushed to `origin/xs2rust-endor` (`996cc6784`, `0b991a8b4`).

**Key finding that shaped the approach:** the C-XS oracle shim transports a string completion by reading the pin's CESU-8 payload as UTF-8, so an astral/lone-surrogate *string value* decodes lossily (U+FFFD). The differential harness therefore **cannot** faithfully assert astral string *values* — only scalars. Endor is correct; the pin's transport is the limitation. This is the job's "where the pin supports" caveat, and it split the deliverables cleanly.

**1. Result parity (governing check).** Dual-ran the String-touching test262 sections vs pin `48ee02d8cfe0`, per-subtree (whole-tree OOMs). `divergent=0` on RESULTS everywhere: `built-ins/String` total=1111 covered=130 divergent=0 (62 named computron-gap skips); template-literal, less/greater-than, equals, strict-equals all divergent=0. Locked into `cargo test` as `utf16_string_sections_have_zero_result_divergence` (charCodeAt/codePointAt/charAt/slice/substring, total=146 covered=8 divergent=0, 42 `builtin-coercion-computron-gap` named skips — value agrees, cost shifts under recalibration, never a RESULT divergence).

**2. New cases.**
- *Scalar-result differential fixtures* (`corpora/stage3-string-utf16.js`, `stage3_string_utf16_result_parity_and_determinism`): charCodeAt/codePointAt across a surrogate boundary, index-heavy `[i]`/`charCodeAt(i)` loops, slice/substring splitting a pair, spread/iterator yielding whole code points, lone-surrogate ops, concat reuniting a split pair. Asserts result parity + determinism-per-release + a live-recalibration guard.
- *Value-layer endor-vm tests* (`interp.rs` `utf16_*`) for the astral/lone-surrogate string values the oracle can't transport: O(1) direct index correct at every position incl. just past a supplementary char; slice splits a pair into a valid lone surrogate; lone surrogate round-trips through storage (verbatim, no normalization), comparison (byte-lex == code-unit order), and the real `concat_add` (lead+trail → U+10000; two lone highs stay distinct).

**3. Meter expectations.** `utf16_meter_expectations_are_the_frozen_recalibrated_costs` freezes endor's own UTF-16 computron costs asserted **against endor directly** (not back-fit to CESU-8 byte length or the oracle), with determinism-per-release. Cross-engine computron equality with C-XS is neither required nor asserted.

**4. Snapshot round-trip.** Supplementary-plane and lone-surrogate string atoms round-trip bit-identically through the chunk payload into a fresh machine (`utf16_string_atom_snapshot_round_trips_supplementary_and_lone_surrogate`).

**Bar:** `cargo test --workspace` green (endor-262 35, endor-vm 52, all crates pass). Miri: the 5 string-storage tests this job touches pass under Miri (18s); the full `endor-vm` Miri suite exceeds the 10-min tool timeout (pre-existing runtime — it dual-runs large corpora), so it was not driven to completion here. `#![forbid(unsafe_code)]` intact; only safe test code added.

**Follow-ups:** (a) supervisor inbox `port-xs-to-rust-memory-safe-engine-s7` is gone — the report was dead-lettered and will be promoted to a fresh job (intent preserved). (b) Pre-existing, not introduced here: the "method result consumed directly as receiver/arg" temporary-lifetime residual (e.g. `slice(..).charCodeAt(0)`) still meters one computron under the pin — a named computron-gap, never a result divergence.
