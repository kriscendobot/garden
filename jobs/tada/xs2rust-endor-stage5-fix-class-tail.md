The parent job already completed, so my report was dead-lettered and will be promoted (intent preserved). My inbox was empty. The work is done, pushed, and green.

## Completion report

**Job:** Stage-5 fix 3/5 — class tail (computed-key fields, private members, static-block lexicals), XS→Rust Endor port, PR #600 `xs2rust-endor` (KEPT DRAFT).

**What I did.** Landed the class-tail keystone byte-identically against the oracle pin `48ee02d8cfe0`, committed as `1cb4529c1` and pushed to `origin/xs2rust-endor` (verified by git exit code: `dd766cd22..1cb4529c1`).

**Route decision (recorded in the commit).** The task named two routes. I chose **route 2** — synthetic field-function frames built in the coder plus class-scope access declares in the scoper — over route 1 (parser-synthesized FieldNode function nodes). Route 1 would have re-plumbed the whole field-function path through hoist/bind/code_function and risked the already-byte-identical slice 47–50 plain-field surface; route 2 extended the existing coder-synthesized field function with `RESERVE`/`RETRIEVE`/`STORE` of the captured closures, leaving plain-field bytes untouched.

**Landed (byte-identical, new tests green):**
1. **Scope-aware field-init functions** (the keystone) — the field function captures class-scope closures as use-closure aliases, reserving/retrieving them at entry and storing them from the class frame after creation.
2. **Computed-key fields** `[k]=v` (instance + static) — `AT` + `CONST_CLOSURE(atAccess)` at class-definition, `GET_CLOSURE` + `NEW_PROPERTY_AT` in the field function.
3. **Private members** — `#x` fields, `#m()`/`get`/`set` methods (instance + static) — `symbolAccess`/`valueAccess` closures + `NEW_PRIVATE`, with XS's two-pass field-collection order (private methods first, then data fields + static blocks).

New `coder_byte_identity` tests `class_{computed_fields,private_fields,private_methods,tail_mixed}`; in-crate corpus gate green; `cargo test --workspace -- --test-threads=1` **EXIT=0**; `#![forbid(unsafe_code)]` intact; no new warnings.

**Remaining folds (honest — loud asserts, never mis-emit):**
- Private member **reads** in bodies — `#x in obj`, `this.#x` get/set, `this.#m()` (the `GET`/`SET`/`HAS_PRIVATE` access path).
- Static block with **local lexical declarations** (item 4) — needs the field function's own frame count for block locals.

Each is a self-contained follow-up. README got a slice-51 entry and an updated "still folded" list; the compiler-seam fold test now uses a private read as its still-deferred construct.
