<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-06T03:04:03Z -->

---
model: opus
roadmap: xs2rust-endor
---
# Test/corpus: prove result parity + recalibrated meter for the UTF-16 string swap, PR #600

**Program:** `xs2rust-endor`. Repo `endojs/endo-but-for-bots`, branch `xs2rust-endor`
(PR #600 — keep DRAFT). Engine `rust/engine/`; oracle pin C-XS `48ee02d8cfe0`; `cargo` at
`/home/kris/.cargo/bin`. This is child 3/3 of `xs2rust-endor-strings-utf16`, following the
build child that swapped storage to UTF-16.

## Work
1. **Result parity (governing check).** Run the test262 / differential harness across all
   String-touching sections dual-run vs the pin; confirm **divergent=0 on RESULTS**
   (completion kind, value, error identity). Run per-subtree, not whole-tree single-process
   (a whole `language/` run OOMs from C-oracle accumulation — see `rust/engine/README.md`).
2. **New index-heavy + supplementary-plane cases.** Add corpus programs and (where the pin
   supports) differential fixtures exercising exactly what UTF-16 code-unit semantics must get
   right:
   - `charCodeAt` / `codePointAt` **across a surrogate boundary** (a supplementary-plane
     code point stored as a surrogate pair): `codePointAt` at the lead surrogate returns the
     full code point; at the trail surrogate returns the trail unit; `charCodeAt` returns the
     individual surrogate units.
   - **slicing across a surrogate boundary** (`slice`/`substring`/`substr`/spread/iterator):
     code-unit slices may split a pair (lone surrogate results are valid JS strings); the
     string iterator yields whole code points.
   - **index-heavy access** — tight `[i]` / `charCodeAt(i)` loops over long strings, asserting
     the O(1) direct-index behavior (no cursor/side-table) is correct at every position incl.
     just past a supplementary char.
   - Ensure a **lone-surrogate** string round-trips through storage, comparison, concat, and
     snapshot without normalization/corruption (WTF-16 semantics — JS strings are not
     required to be well-formed UTF-16).
3. **Meter expectations.** Update expected computron numbers to the **recalibrated UTF-16
   costs** the build froze — do NOT back-fit to CESU-8 byte length or to the oracle. Assert
   determinism-per-release (identical computrons across repeated runs / platforms), which is
   the property that must hold; cross-engine computron equality with C-XS is neither required
   nor asserted.
4. **Snapshot round-trip.** Confirm string atoms round-trip under UTF-16 (including a
   supplementary-plane and a lone-surrogate atom).

## Bar
Harness green with divergent=0 on results across touched sections; new surrogate-pair /
index-heavy / lone-surrogate cases present and green; Miri + `cargo test --workspace` green;
meter expectations updated to the frozen recalibrated costs with determinism-per-release
asserted. Land + push each increment; requeue-safe per the standing work discipline. Report
to the supervisor inbox `port-xs-to-rust-memory-safe-engine-s7` (or its successor).
