The commit is on `origin/xs2rust-endor`; only the `c/moddable` gitlink is dirty (intentionally never staged). Work is complete and landed.

---

## Completion report

**Job:** stage-5 child 2/7 — port the XS parser's AST model and expression grammar into `endor-compile`, building on child 1's lexer.

**Landed** (commit `294a2412c`, pushed to `origin/xs2rust-endor`, PR #600 kept DRAFT; `cargo test --workspace -- --test-threads=1` **EXIT=0**, 0 warnings, `#![forbid(unsafe_code)]` intact):

- **`ast.rs`** — the `txNode` model transliterated from `xsScript.h`: node kinds keyed by XS's `txToken`, XS's exact child-slot order, and the parser-flag bits stamped onto nodes (`fxPushNodeStruct`'s `mxStrictFlag|mxGeneratorFlag|mxAsyncFlag` inheritance, plus `mxSpread`/`mxElision`/`mxShorthand`/`mxExpressionNoValue`/…). `Node`/`Symbol`/`Null`/`List` stack items mirror XS's `fxPush*` pointer stack rather than reproduce its aliasing trick. Plus a deterministic dump-and-compare renderer (endor's own format — deliberately **not** XS's debug `mxTreePrint`, which is out of the byte-identity bar).
- **`token_flags.rs`** — `gxTokenFlags` transliterated verbatim (all 172 entries) with the grammar-class bit constants.
- **`parser.rs`** — the `fxCommaExpression`→`fxLiteralExpression` precedence cascade on a faithful `fxPushNodeStruct`/`fxPushNodeList`/`fxSwapNodes` stack machine over a `states[0]`/`states[1]` token window. Covers primaries, member/call/new/optional-chaining/tagged-template postfix chains, array literals, object **data** literals, templates, `new.target`/`import.meta`/dynamic `import()`, the full operator ladder (unary/update/exponent/binary/relational incl. `#x in obj`/equality/bit/logical/coalesce/conditional/assignment-with-all-compounds/comma), `yield`/`await` with XS's state flags, and regexp-vs-divide wired to the lexer's `read_regexp` re-entry. Fail-fast structured `ParseError` (`Lex`/`Syntax`/`Unsupported`) matching XS's early-error classification; **no panics on malformed input** (fuzz-target precondition). Parse meter continues per production.
- **49 AST fixture tests** (dump-and-compare) over the construct corpus — all green.

**Explicitly folded** (reported as `ParseErrorKind::Unsupported`, never mis-parsed — no silent gaps): (1) arrow functions incl. async + the `( )=>…` cover reparse, (2) function/generator/class **expressions** and object method/accessor shorthand — all need function *bodies* (statement grammar → child 3; the `fxPropertyName` accessor/async/`*` lookahead **is** ported so these are rejected precisely), (3) the destructuring binding-conversion subsystem (`fxBindingFromExpression` family, ~400 lines) — self-contained but large/risky, deferred to keep the slice landable per the stage-3/4 budget lesson, (4) native host `@`/JSX/eval-native paths.

**Follow-ups:** the fold report was sent to the `port-xs-to-rust-memory-safe-engine-s12` inbox; that job had already completed, so the bus dead-lettered it and auto-promoted it to a fresh job (intent preserved). Recommendation recorded there: child 3 supplies `fxBody`/`fxStatements`, after which arrows + function/class expressions fall out; the binding-conversion subsystem is a clean self-contained next increment. No maintainer contact; PR stayed DRAFT; nothing under `c/moddable` staged.
