All bars confirmed and the work is landed and pushed. Final summary:

## Completion report

**Job:** Stage-5 fix3 1/5 — Class α closure-vs-local scope classification, PR endojs/endo-but-for-bots #600 (`xs2rust-endor`, kept DRAFT, no PR comment, no maintainer message).

**Root cause found.** XS's parser moves every class field initializer into a real `instanceInit` `mxFieldFlag` function node, so a field value that references an outer binding *captures* it and the binding is promoted to a closure slot (`fxClassNodeHoist`/`fxFunctionNodeBind`). endor deferred that surgery to the coder and only modeled the class-scope member closures (`atAccess`/`symbolAccess`/`valueAccess`) — so a plain-data-field value capturing an outer var was bound under the class *block* scope, resolved to a plain local, and mis-emitted `NEW_LOCAL`/`CONST_LOCAL`/`GET_LOCAL` where the oracle emits the `*_CLOSURE` family (opcodes 228↔230).

**Fix (transliterated from the pin).** The scoper now binds each plain (literal-keyed) instance data field's initializer inside a synthesized strict `Function` scope — the `instanceInit` scope — so an outer capture promotes to a closure and is aliased in field order (`scoper.rs`: `class_instance_fields_all_plain`, `scope_new_field_init`, the `bind_class` field-init pass). The coder drives that field function's `RESERVE`/`RETRIEVE`/`STORE` and each captured value's `GET_CLOSURE` from the scope's use-closure aliases (`coder.rs`: `code_field_init_function` gains an `fi` scope param). Engaged only when every non-static instance data field is a plain `Property` (no computed-key or private instance member, whose interleaved member closures are a separate fold), so all other classes stay on the existing path.

**Results (measured, checked by exit code, not piped to tail):**
- `statements/class`: divergent **113 → 96**, **endor-rejected 0** (no new rejects), accept-disagree 0. Closes all 16 `elements/*literal-names*` files plus derived-class variants (17 divergences gone).
- `statements/function`: divergent **0** (the head commit already handled the `arguments`-param case; the 4 endor-rejects are the sibling's eval-in-parameter-default fold, left as instructed).
- Curated corpora (`compile-diff`): stays **1711/1711 divergent=0 endor-rejected=0**, BAR MET.
- `cargo test --workspace -- --test-threads=1`: **EXIT=0** (all suites green).
- Added byte-identity fixtures `class_field_init_closure_capture` in `coder_byte_identity.rs` (10 shapes: representative, single capture, method-interleaved, `var` capture, no-capture control, derived, two captures).
- `#![forbid(unsafe_code)]` intact; no unsafe introduced.

**Committed & pushed** (rebase-CAS to `origin/xs2rust-endor`, verified by git exit code): `8b0ca20e8`.

**Honest remainder (the ≤92 target was not fully met — landed at 96):** The 21 ledger-attributed α files split into three mechanisms, only one of which is closure-promotion:
- **4 `accessor-name-{inst,static}/literal-numeric-{leading-decimal,non-canonical}`** — these are *not* the closure mechanism. The divergence is endor-**longer**: the oracle canonicalizes a numeric accessor key `.1` to the string `"0.1"` (`NEW_PROPERTY`) while endor codes it through the computed integer-index path (`NUMBER`/`AT`/`NEW_PROPERTY_AT`). That is a numeric-property-key coding issue (Class δ-adjacent), out of this child's closure scope.
- **1 `elements/intercalated-static-non-static-computed-fields`** (`[i++] = i++`) — the genuine α interleave: computed-key fields whose values capture outer `i`, so `atAccess` member closures must interleave with value captures in the field-init frame. Closing it needs a rework of the computed/private field-capture path that risks the ~40 passing computed/private field byte-identity tests; deferred rather than risk a regression or a new reject (leaving it diverging, not folding to a reject, keeps `endor-rejected=0`).

No follow-up job strictly required for the closure mechanism itself; the two residual sub-cases above are candidates for a numeric-accessor-key slice and a computed-field-capture interleave slice respectively.
