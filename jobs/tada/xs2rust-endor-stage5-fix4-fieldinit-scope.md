All bars confirmed green. Everything is committed and pushed. Let me write the completion report.

All bars are met and everything is pushed to `origin/xs2rust-endor`. Final verification summary:

## Completion report

**Job:** Stage-5 fix4 1/4 — unify the member-closure field-init path onto the real `instanceInit`/`constructorInit` function scope (Classes β + ε structural fold), PR #600 (kept DRAFT, no PR comment, no maintainer message).

**What I did.** Root-caused and built the one fold three fix3 children deferred. endor synthesized the class field-init function at *code* time, so field values bound at the class scope — leaking their closures/temporaries into the enclosing frame and resolving `this.#x` reads to the class-scope brand index. I made every field initializer bind inside a **real field-init function scope created at hoist**:

- **Scoper** (`scoper.rs`): a new `hoist_field_init_scope` creates the `instanceInit` (instance) and `constructorInit` (static) function scopes at hoist, parented to the class body, and hoists each field value / `static { … }` block body inside them so a value's inner function/class chains through the field function. `bind_field_init_scope` re-enters each scope, looks the member accesses (`atAccess`/`symbolAccess`/`valueAccess`) up from inside it (creating use-closure aliases in field order, get/set pair sharing one brand via `fxScopeLookup` dedup), then binds the value. `scopeCount == scopeMaximum` now counts closures + peak value-temporary depth. New predicate `class_has_constructor_init_member` gates the static scope.
- **Coder** (`coder.rs`): `code_field_init_function` reads the recorded fi/ci aliases and drives `RESERVE`/`RETRIEVE`/`GET_CLOSURE`/`NEW_PRIVATE`/`STORE` from the function frame for both instance and static paths. `this.#x` reads resolve automatically. A `static { … }` block with lexical declarations remains a loud, named fold.

**Results (measured on the oracle pin, captured to files, checked by exit code):**
- `statements/class`: divergent **62 → 25** (meets the ≤ 25 bar), `endor-rejected 0`.
- `expressions/class`: divergent **50 → 19**, `endor-rejected 0`.
- Curated corpora: **1711/1711, divergent 0, endor-rejected 0** (unchanged).
- Module corpora in-crate gate + `cargo test --workspace -- --test-threads=1`: **EXIT 0**.
- `#![forbid(unsafe_code)]` intact.
- Added `coder_byte_identity.rs::class_field_init_function_scope` (14 fixtures: nested-class private RESERVE, field-init brand read, init-value temp depth, shared accessor-pair brand, static constructorInit twin, simple static block, derived+cross-construct mix).

**Closed:** all of Class β (35), Class ε's `init-value-incremental`, and Class α's `intercalated-…` interleave. Removed the superseded plain-only helpers; README residual-divergences ledger updated.

**Honest remainder (residual 25 statements / 19 expressions, all attributed):** Class γ — the class field-initializer **direct-eval** scope prelude (`*direct-eval*` / `*visible-to-direct-eval*` / `derived-cls-direct-eval-*`, and `static-field-init-with-this`'s eval half; sibling 2's surface), and Class α — literal-numeric-key + captured-`arguments` scope classification (a separate scoper closure-promotion gap). No unexplained byte divergence.

**Commits pushed to `origin/xs2rust-endor`** (rebase-CAS, verified by exit code): the instanceInit unification, the constructorInit extension, the cleanup+guard, the fixtures, and the README update. `c/moddable` never staged.
