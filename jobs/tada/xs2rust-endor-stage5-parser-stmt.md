Both commits are on `origin/xs2rust-endor`; HEAD matches origin. The job is complete.

## Completion report

**Job:** Stage-5 child 3/7 — the `endor-compile` parser statement/declaration/function/class/module surface — of the XS→Rust port on PR endojs/endo-but-for-bots#600 (branch `xs2rust-endor`, kept DRAFT).

**What I did.** Transliterated the second half of `xsSyntaxical.c` (oracle pin `48ee02d8cfe0`) into `endor-compile`, building on child 2's expression grammar. Two commits pushed via rebase-CAS:
- `8b725b9a87` — the statement grammar
- `4bde873b08` — fixtures + whole-corpus parse smoke

**Shipped surface:** all statements (blocks, var/let/const, expression, if, for-c/for-in/for-of/for-await-of with binding forms, while, do, switch, labels, break/continue/return/throw/try/catch/finally, with, debugger, empty) with ASI and directive-prologue strict propagation; functions/generators (plain + async), parameter bindings and the full destructuring binding subsystem (`fxBinding` + the `*FromExpression` cover conversions), arrow functions (single-ident + group-cover reparse), object methods/accessors (child 2 had deferred these), classes (member parsing with faithful early errors), and modules (`import`/`export` all forms) with goal-sensitive `parse_program`/`parse_module` entry points.

**Local bars — all green:**
- Statement/declaration AST fixtures: **63 lib tests** pass (49 prior + 14 new, each dump read off the C construct-by-construct).
- **Whole-corpus parse smoke** (`tests/corpus_parse_smoke.rs`, oracle dev-dep): 31 files, **1711 programs, 1711/1711 accept agreement, zero panics**, named tally emitted.
- `cargo test --workspace -- --test-threads=1` **EXIT=0** (16 suites); no unused/dead warnings.

**Named folds (all for the coder child):** (1) class field/static-block → init-function surgery (intrusive C pointer-aliasing that doesn't map to the owned-Vec AST; members kept faithfully in the `items` list, init slots null, default constructor synthesized); (2) `using`/`await using` (pin builds `mxExplicitResourceManagement==0`, oracle rejects, so omitted); (3) `fxCheckNativeConstructor`/`Function` (`@`-host-only, absent from corpus); (4) string-key→canonical-index nicety. JSX/host `@` literals out of ECMAScript surface — not ported.

Completion report sent to inbox `port-xs-to-rust-memory-safe-engine-s12` (not the maintainer). No PR comments; PR #600 stays DRAFT.
