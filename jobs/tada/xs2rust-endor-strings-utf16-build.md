HEAD == origin/xs2rust-endor (both commits pushed); working tree clean except the intentional local `c/moddable` submodule init (not committed). Job complete.

---

## Completion report

**Job:** `xs2rust-endor-strings-utf16-build` (child 2/3) — swap endor-vm's JS string storage from CESU-8 to UTF-16 code units on `endojs/endo-but-for-bots` branch `xs2rust-endor` (PR #600, kept DRAFT).

**Preconditions verified:** stage-3b fully landed (object-statics intern, xsre RegExp+String methods, promises) with child 1's UTF-16 design revision at HEAD; tree clean before touching string code.

**What I did (2 commits pushed to `xs2rust-endor`):**

1. **`45f1a6463` — the representation flip.** String values now store **UTF-16 big-endian code units** in the chunk arena (BE chosen so byte-lexicographic order == code-unit order, keeping the relational/equality opcodes comparing `str_content` bytes directly, and byte-concat == unit-concat). No NUL terminator (a U+0000 unit is `00 00`); length comes from the chunk header (`str_len` = O(1)).
   - **Storage helpers:** `str_units`/`str_len`/`str_text`, free fns `units_to_be16`/`be16_to_units`/`str_to_be16`/`cesu8_to_units`, `alloc_str_text`.
   - **Literals** decode the compiler's CESU-8 operand → units. **Concat/index/charCodeAt/codePointAt/slice/substring/String.prototype/iteration** operate directly on code units. **The O(1)-index machinery is DELETED** (`string_unit_starts`, per-byte `decode_code_point`, the `byte_of` offset table) — indexing is now direct. The string iterator recombines surrogate pairs into astral code points (previously self-named).
   - **Rendering** → `String::from_utf16_lossy`; every text-building string-value site encodes UTF-8 → UTF-16BE.
   - **C-FFI/regexp boundary** transcodes the subject UTF-16 → UTF-8 (matcher works in byte-offset space; identity on the ASCII covered subset); match-length reads code units.
   - **Meter** re-based to code-unit length (O(n) length, O(1) single index); passed to the unchanged tick_* fns. ASCII unit-count == old CESU-8 byte-count, so **ASCII string computrons are unchanged**; multi-unit content shifts (expected — classifies as computron-gap skips, never RESULT divergences).

2. **`71242056c` — round-trip checks.** Two tests locking the encoding: exact UTF-16BE encode/decode for every code unit (incl. lone surrogates and astral pairs), and a chunk-stored string atom reading back bit-identically with an O(1) length.

**Bar met:**
- `cargo test --workspace` **green** (all crates 0 failed; endor-262 differential incl. `covered_grammar_language_subset_has_zero_divergence` — **total=953 covered=322 divergent=0**). Every pre-existing bit-exact String corpus test still passes → no coverage regression.
- **Miri GC suite green** (9 tests, no UB); new string-storage paths Miri-clean.
- `#![forbid(unsafe_code)]` intact (no unsafe added); PR #600 kept DRAFT.

**Notes / follow-ups:**
- Numeric recalibration of the frozen string weights remains the sibling C1 job (`xs2rust-endor-meter-calibration-stage-c1`); I applied the O(n)-code-units / O(1)-index *shape* from child 1's design, not oracle-back-fit values.
- The design's "xsnap netstring boundary" transcode item does **not** apply — the Rust engine has no xsnap boundary; the oracle-shim completion comparison is String-vs-String and BMP-identical.
- Supervisor report to `port-xs-to-rust-memory-safe-engine-s7` was dead-lettered (inbox completed) → will be promoted to a fresh job, intent preserved.
- Pre-existing (not mine) warnings remain: unused `argc` and a redundant `mut push_segment` in `string_split` (confirmed present in base HEAD).
