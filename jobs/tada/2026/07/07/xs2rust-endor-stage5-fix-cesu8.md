The supervisor inbox was gone (that job completed), so the message was dead-lettered and will be auto-promoted to a fresh job by `garden-deadmail` — intent preserved. The work is complete.

## Completion report

**Job:** `xs2rust-endor-stage5-fix-cesu8` (child 1/5) — CESU-8 string-literal emission for the XS→Rust Endor port (`endojs/endo-but-for-bots` PR #600, branch `xs2rust-endor`).

**Outcome: DONE. The byte-identity string fold is closed.** Pushed commit `23ca8ac79c` on top of `195fa9a665` to `xs2rust-endor` (push verified by exit code). PR #600 untouched, still DRAFT — no PR comment.

**What I did**
- Root cause confirmed against the oracle source (`fxCESU8Encode`, `xsCommon.c`): XS stores string literals as CESU-8 — an astral scalar as a 6-byte surrogate pair, a lone surrogate as a 3-byte unit (not valid UTF-8), an embedded NUL as the overlong `0xC0 0x80` — while the coder emitted the Rust `String`'s UTF-8. All 60 divergences were these, all in `corpora/stage3-string-utf16.js`.
- Changed the string-value representation to **UTF-16 code units end to end** (mirroring endor-vm's stage-4 rework): `ast::Value::Str` and lexer `Lexeme.string`/`raw` are now `Vec<u16>`; `cook_string` and the escape helpers build code units so lone surrogates from `\u` escapes survive. Added `coder::units_to_cesu8` (exact inverse of endor-vm's `cesu8_to_units`).
- Bridged the symbol/directive/module-specifier text boundaries with new `str_to_units`/`units_to_string` helpers. The atom table stays UTF-8-hashed and byte-identical (no astral identifiers/keys in the corpus).
- Updated the in-crate gate `corpora_byte_identity_no_undocumented_divergence` to assert `divergent == 0` and removed the CESU-8 fold from its documentation; updated the README stage-5 acceptance block (identical 1631→1691, divergent 60→0).
- Added `strings_cesu8_astral_and_surrogates` fixtures to `endor-compile/tests/coder_byte_identity.rs` (astral literal + `\u{}` + combined surrogate-pair escapes, lone surrogates, BMP CESU-8 boundaries, embedded NUL) — all byte-identical vs the C-XS oracle.

**Verification**
- Gate: `divergent=0` (was 60), `identical=1691`, `endor-rejected=20` (unchanged), `accept-disagree=0`.
- `cargo test --workspace -- --test-threads=1`: **EXIT=0**, zero failures.
- `#![forbid(unsafe_code)]` intact; `c/moddable` never staged.

**Follow-ups (not this child's scope)**
- The remaining 20 `endor-rejected` are the pre-existing named coder folds (`new.target`, optional chaining, declaring-scope paths) — the accept/reject half of the stage bar.
- Supervisor report to `port-xs-to-rust-memory-safe-engine-s13` was dead-lettered (that job had completed) and will be promoted to a fresh job by `garden-deadmail`; intent is preserved.
