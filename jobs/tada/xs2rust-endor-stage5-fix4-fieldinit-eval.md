My commit is the remote tip, cleanly on top of sibling 1's work. No inbox messages. The job is complete.

## Completion report

**Job:** Stage-5 fix4 2/4 — field-initializer direct-eval scope emission (Class γ, the last eval slice), PR #600 branch `xs2rust-endor` (kept DRAFT, no PR comment, no maintainer message).

**What I did**
- Synced to the live tip (`1229c6875c`, sibling 1's real field-init function scope) and read its landed code + the README residual ledger.
- Diagnosed Class γ by disassembling a representative case (`direct-eval-err-contains-arguments`): the field-init function (`instanceInit`/`constructorInit`) emitted `begin_strict_field` then went straight to the body, **omitting the eval prelude** `undefined; with; pop` — exactly the 3-byte "endor-shorter" divergence.
- Confirmed the root cause against the XS pin (`xsCode.c` `fxFunctionNodeCode`, lines 3433–3434): XS calls `fxScopeCodeRetrieve` **then `fxScopeCodingParams`**; endor's `code_field_init_function` called only the retrieve. Because sibling 1 now creates the field-init scope **at hoist**, the hoist-time poison walk (`fxScopeEval`) already sets the scope's own `mxEvalFlag`, and the store side already ran `fxScopeCodeStore`'s store-all under that flag — so the single missing call was the params-publish prelude.

**What changed**
- `endor-compile/src/coder.rs` — added the `self.scope_coding_params(fi)` call to `code_field_init_function` (the `fi` path), mirroring `code_function`. For a field-init scope (only closure aliases) this emits precisely the strict eval prelude when the scope is eval-poisoned and nothing otherwise.
- `endor-compile/tests/coder_byte_identity.rs` — new `class_field_init_direct_eval` fixture pinning the plain, outer-capture, derived-with-`super`, static, private-adjacent, and static-private shapes.
- `rust/engine/README.md` — appended a "fix4 followup — Class γ CLOSED" ledger note.

**Bars (measured, `$?` checked directly)**
- `statements/class`: divergent **25 → 5** (all 19 γ + `static-field-init-with-this`'s eval half closed; remaining 5 are all Class α, out of scope — no new divergence/reject).
- `expressions/class`: divergent **19 → 4** (γ mirrors closed; remaining 4 are Class α).
- Curated corpora: **1711/1711 identical, divergent=0, endor-rejected=0**.
- `cargo test --workspace -- --test-threads=1` from `rust/engine`: **EXIT=0** (incl. `eval_scope_in_function` + param-default eval fixtures + the new fixture).
- `#![forbid(unsafe_code)]` intact; no unsafe added.

Committed `8e2252522e` and pushed (rebase-CAS) to `origin/xs2rust-endor`, now the branch tip on top of sibling 1's landed work. The temporary disasm debug binary I added for diagnosis was removed before commit.

**Follow-ups (out of scope for this child):** Class α (5 `statements/class` + 4 `expressions/class`) — the literal-numeric accessor-key + `arguments-callee` closure-vs-local scope classification — remains a separate narrow scoper fold for sibling/later work.
