Inbox empty. The job is complete. Let me write the completion report.

---

## Completion report — fix6 1/2: enclosing-function synthetic capture-closure fold CLOSED

**Result: the LAST byte-divergence in the whole `language/` tree is closed.**

### What I did
Diffed the two byte streams for the reduced shape `function foo(){ return ()=>eval("this"); }` opcode-by-opcode (throwaway disassembler, since removed) and measured the exact 10-byte delta in `foo`'s body (oracle 71 → endor 61): a missing `RESERVE_1 #1` (+2), `NEW_CLOSURE` (+3), eval `with`-publish `STORE_1` (+2), and closing `WITHOUT WITHOUT END` teardown (+3).

Traced the mechanism to the XS pin: `fxArrowExpression` (xsSyntaxical.c:2594) bubbles an arrow body's inner `mxEvalFlag` **out** onto the nearest enclosing non-arrow function node; `fxFunctionNodeHoist`'s `(mxArgumentsFlag | mxEvalFlag) && !mxArrowFlag` gate (xsScope.c:730) then injects a **materialization-free** synthetic `arguments` capture closure — no `ARGUMENTS_SLOPPY`, because the eval string is opaque so `arguments` is never referenced and the enclosing node never gains `mxArgumentsFlag`.

Root cause: endor's parser had the `flags::EVAL` bubble already wired (`arrow_expression`/`function_expression`) but **never set the flag** at an `eval(...)` call. Three-part fix:
1. **`parser.rs`** — set `flags::EVAL` when a call's callee is a bare `Access` to `eval` (mirrors xsSyntaxical.c:2171).
2. **`coder.rs` `code_arguments_object`** — gate materialization on the function node's actual `mxArgumentsFlag` (`flags::ARGUMENTS` OR the scope's `direct_eval`), not the mere presence of the injected `Var` — this is exactly what keeps the enclosing closure materialization-free and avoids the +2-byte wrong fix the residual explicitly warned against.
3. **`coder.rs` `code_body` + `scoper.rs` `Scope::node_has_eval`** — key `fxScopeCodedBody`'s two-`WITHOUT` teardown on the function node's eval flag, not `direct_eval`.

### Measured before → after
- `expressions/arrow-function`: **326 total, 250 identical / 1 divergent → 251 identical / 0 divergent**, endor-rejected=0, accept-disagree=0. **BAR MET.**
- Neighbors (all `divergent=0 endor-rejected=0`): eval-code 151/151, arguments-object 260/260, optional-chaining 19/0, tagged-template 27/27, statements/class 3298/0, expressions/class 3086/0.
- ~25-subtree function/eval/scope regression sweep (statements/expressions function + async + generators, with, block-scope, function-code, global-code, for/for-in/for-of, variable, try, labeled, assignment, object): **all divergent=0 endor-rejected=0**.
- Curated corpora **1711/1711 divergent=0**; `cargo test --workspace -- --test-threads=1` **EXIT=0** (all 20 test-result groups ok).
- Added locked fixture `arrow_eval_enclosing_capture_closure` (closed shape, nested-arrow chain, directly-eval-poisoned variant that DOES materialize, `arguments`-capture contrast, parameterized enclosing function); fix5 locked fixtures stay green. `#![forbid(unsafe_code)]` intact, no new unsafe.

### Changed / pushed
Commit `2b7cc6a35c` on `endojs/endo-but-for-bots` branch `xs2rust-endor` (PR #600, kept DRAFT; no PR comment): `parser.rs`, `scoper.rs`, `coder.rs`, `coder_byte_identity.rs`, `README.md` residual ledger (verdict updated to closed + fix6 mechanism block). `c/moddable` correctly excluded from the commit. Push verified by exit code; remote tip == my HEAD.

### Follow-ups
Full 120-subtree `language/` re-enumeration (total=20602) to confirm stage-5 `divergent=0` everywhere is the **fix6-verify 2/2** sibling's bar — I swept the closed subtree, all neighbors, and the highest-risk function/eval/scope trees, but not all 120.
