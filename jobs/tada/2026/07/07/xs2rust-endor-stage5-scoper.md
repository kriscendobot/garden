All work is committed, pushed, and verified. HEAD matches origin/xs2rust-endor; the tree is clean.

---

## Completion report

**Job:** Stage-5 child 4/7 — port the XS scoper (`xsScope.c`) to Rust in `endor-compile`.

**Delivered** (3 green increments to `endojs/endo-but-for-bots#600`, branch `xs2rust-endor`, kept **DRAFT**; each `cargo test --workspace -- --test-threads=1` EXIT=0):

1. **`3ea14b3dce`** — `src/scoper.rs` (~1690 lines): faithful transliteration of `xsScope.c`'s two dispatch passes at the oracle pin.
   - **Scope tree**: PROGRAM/EVAL/FUNCTION/MODULE/BLOCK/WITH plus catch param+statement scopes, with XS's exact kinds/boundaries and the body-vs-function split (vars→bodyScope, args→functionScope).
   - **Hoisting**: var + function-decl hoisting (incl. the NoToken intermediate-block placeholders and their `fxScopeHoisted` removal, the PROGRAM/EVAL var/define `declareCount` discount); let/const/using lexicals with TDZ-token records; all duplicate-declaration early errors.
   - **Closure capture + slot numbering**: the per-scope ordered declare list *is* the coder's slot order (confirmed `xsCode.c` assigns `index = scopeLevel++`; the scoper never sets `index`). Function-scope closure aliases with `closureNodeCount`, and per-function `scopeCount = scopeMaximum` via the full `fxBinderPush/PopVariables` arithmetic across array/object/spread/template/try/postfix/for-in-of/bindings.
   - `this`/`super`/`target` arrow marking, direct-eval + with scope poisoning and lookup shadowing.
   - `ScopeTree::dump` + **21 unit fixtures** pin the numbering contract (values derived from reading the C).

2. **`9cf45e066a`** — module records: imports as immutable indirect (closure|useClosure) `let` bindings; local exports mark the declaration closure|useClosure; module top-level functions resolve lexically. Six module fixtures + dup/unknown-export errors.

3. **`f00f2204ce`** — `tests/corpus_scope_smoke.rs`: scopes all **1711** parser-accepted corpus programs, **0 panics** (robustness bar for the coder/fuzz children).

**Folds** (named explicitly, reported in full to inbox `port-xs-to-rust-memory-safe-engine-s12`): classes (`fxClassNodeHoist/Bind` — symbolScope, private/computed-key slots, init records — the largest remaining piece; recommend a dedicated class-scoping child), `export … from` re-exports / `export default`, host (@) defines, and the params-binding arguments-object mapping.

**Notes:** PR #600 stays draft; no maintainer contact or PR comments; `c/moddable` never staged. Zero warnings in `endor-compile`.
