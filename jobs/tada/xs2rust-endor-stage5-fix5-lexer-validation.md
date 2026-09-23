All three slices landed cleanly, pushed to `xs2rust-endor` (PR #600 stays DRAFT), inbox empty. Job complete.

---

## Completion report — xs2rust-endor-stage5-fix5-lexer-validation

Retired all three lexer/parser validation gaps on PR #600. Each slice landed as a self-contained commit (fix + fixtures + green bars + rebase-CAS push, verified by exit code) onto `endojs/endo-but-for-bots` `xs2rust-endor`. No codegen work — pure ACCEPT/REJECT parity.

**Slice 1 — hashbang comments (`comments/hashbang`): 6 ENDOR-REJECTED → 0.**
Ported XS's `fxSkipShebang`: added `Lexer::skip_shebang`, invoked from `Parser::new` before the first token for the program and module goals. Gated on the `#!` pair so it is safe to call unconditionally (a bare `#x` private-in expression is untouched). `comments` subtree: divergent=0 endor-rejected=0 accept-disagree=0.

**Slice 2 — string-literal escape validation (`literals/string`): 10 accept-disagree → 0.**
The failing files were malformed `\u`/`\u{…}` escapes (not octal, as the spec text implied) plus one strict-prologue legacy octal. A plain string with a malformed `\x`/`\u` (`mxStringErrorFlag`) is now rejected in the parser's `String` primary case (context-independent; a tagged template's cooked slot never lands there). A legacy octal / `\8`/`\9` (`mxStringLegacyFlag`, carried onto the String node as bit 2) in a strict scope is rejected in the scoper's `hoist_string`, mirroring `fxStringNodeHoist`'s legacy→error upgrade after a later `"use strict"` prologue is known.

**Slice 3 — `const` without initializer (`statements/const`): 5 accept-disagree → 0.**
A bare `const`/`using` declaration with no initializer is a SyntaxError. XS raises it at code time in `fxDeclareNodeCode`; mirrored in `code_declare` via a new coder error field that `compile`/`compile_module` surface after the pass. Because a `for (const x of/in …)` iteration binding is coded through the reference/assign path (never `code_declare`), it stays exempt exactly as in XS — verified for-of/for-in/for subtrees unregressed.

**Fixtures added** to `coder_byte_identity.rs`: a new `assert_both_reject` reject-agreement helper (correctly classifies oracle rejection via `completed`/`SyntaxError`, not `Some`), plus `hashbang_comment`, `string_escape_validation_rejects` + `legacy_octal_sloppy_accepts`, and `const_without_initializer_rejects` + `const_with_initializer_and_for_head_accepts`.

**Invariant bars (all green):** curated 1711/1711 divergent=0 endor-rejected=0; `cargo test --workspace -- --test-threads=1` EXIT=0 (20 suites, 0 failures); `statements/class` and `expressions/class` divergent=0 endor-rejected=0; `#![forbid(unsafe_code)]` intact (no unsafe added; `endor-oracle` still the only FFI seam). README residual ledger updated with the fix5 3/5 closures.

**Follow-ups:** none blocking. The parser-side malformed-`\u` rejection covers the primary string-literal position (all failing fixtures); malformed escapes in object property-key / import-export-specifier string positions are not exercised by these corpora and were left as-is.
