All work complete and pushed. Both target subtrees are at **accept-disagreements = 0**; the remaining divergent/endor-rejected counts are byte-level coder issues and sibling coder panics (explicitly out of scope per the spec). Inbox is empty.

<<<REPORT>>>

## Completion report: Stage-5 fix2 5/6 — missing early errors + import()/import.meta coders

### Primary scope (Class E accept-disagreements) — CLOSED

Ported the oracle's parser/scoper/coder early errors so endor rejects exactly the set the oracle rejects. **`statements/class` accept-disagree 55 → 0; `expressions/object` accept-disagree 2 → 0.** No new false rejections introduced anywhere.

Checks ported (each at the oracle pin, `xsSyntaxical.c`/`xsScope.c`/`xsCode.c`):

1. **NSPL + `"use strict"` body** (`fxBody`/`consume_directive`, `parser/stmt.rs`): the root cause of the 24 `*-param-strict-body` accepts. The non-simple-parameter-list check was gated inside `STRICT == 0`, so it was skipped for class methods (already strict). Moved it out of the gate — it now fires on every `"use strict"` directive, matching the oracle. `fxProgram` never sets the flag, so the shared helper stays faithful at top level.
2. **`arguments` in a class-field initializer** (`class_field`) and **`arguments`/top-level `await` in a static block** — the `*-init-err-contains-arguments` set (arrows propagate the flag, regular functions absorb it — matching ContainsArguments).
3. **Getter/setter/plain parameter arity** (`fxParamsBindingNodeBind`, `scoper.rs`): getter → 0 params, setter → 1 non-rest, else ≤255. Object-literal accessors carry the flag via a faithful `fxObjectNodeBind` port (recorded in the `node_extra` side-table, not the AST; the coder relays the accessor bit from the property via `pending_accessor`, so **bytecode is unchanged**).
4. **Duplicate `PrivateBoundNames`** (`fxClassNodeHoist`): the `grammar-privatemeth-duplicate-*` / `fields-duplicate-privatenames` set, with the one sanctioned getter+setter (same static-ness) exception via the `{static,getter,setter}` XOR test.
5. **CoverInitializedName as a real expression** (`fxBindingNodeCode`, `coder.rs`): `({ a = 1 })` — a `Binding` with an `Access` target reaching the value-coding path is `invalid initializer` (a code-time panic, caught by the harness as endor-rejected, matching the oracle's mutual reject).

### Secondary scope (import()/import.meta coders) — LANDED

Ported `fxImportCallNodeCode`/`fxImportMetaNodeCode` (`coder.rs`): `ImportCall` codes the specifier then the options arg (or `UNDEFINED`), sets the header `mxImportFlag`, emits `IMPORT`; `ImportMeta` sets `mxImportMetaFlag`, emits `IMPORT_META`. These node kinds previously fell through to a coder panic. Added curated module fixtures (`corpora-modules/dynamic-import.js`, 10 programs).

### Measured tallies (final, pushed state)

- `statements/class`: **accept-disagree=0** (was 55); 113 divergent, 0 endor-rejected — divergent are byte-level coder siblings' scope.
- `expressions/object`: **accept-disagree=0** (was 2); 1 divergent, 8 endor-rejected — all 8 are the sibling `coder panic: eval in a parameter default deferred`, siblings' scope.
- **Curated script corpora: 1711/1711 identical, divergent=0, endor-rejected=0.**
- **Module corpora: 35 → 45 identical, divergent=0, endor-rejected=0** (import()/import.meta byte-identical to the oracle).
- **`cargo test --workspace -- --test-threads=1` EXIT=0** (all 20 suites; +8 new negative-fixture unit tests across parser/scoper/coder).
- `#![forbid(unsafe_code)]` intact; `c/moddable` never staged.

### Verification of no collateral regressions

Swept the most-exposed subtrees (statements/expressions function, generators, arrow, async-function/generator, assignment, array, destructuring, for-of/in, variable): every endor-rejection is a pre-existing sibling coder panic (`eval in a parameter default deferred`, `captured function name deferred`) — **zero** carry my new error strings, confirming no valid program is now falsely rejected.

### Commits pushed to `xs2rust-endor` (rebase-CAS, EXIT=0)

- `e7ecb5a281` — missing early errors (Class E)
- `013f76aa3b` — dynamic import()/import.meta node coders

PR #600 stays DRAFT. No PR comment, no maintainer/supervisor message (per ground rules).

### Follow-ups (folds, NOT my scope — reported per spec)

- `statements/class` 113 divergent and `expressions/object` 1 divergent + 8 endor-rejected are byte-level coder divergences / the `eval in a parameter default` coder fold — siblings' scope in the stage-5 fix2 orchestration.
