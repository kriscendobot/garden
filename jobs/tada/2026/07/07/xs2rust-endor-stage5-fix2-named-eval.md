Inbox empty. All work complete and pushed. Writing the completion report.

---

## Completion report: stage-5 fix2 1/6 — NamedEvaluation for destructuring defaults (Class A)

**Root cause found.** In XS the name for an anonymous initializer is stamped at *bind* time, not code time: `fxBindingNodeBind` / `fxAssignNodeBind` (`xsScope.c`) call `fxFunctionNodeRename` when the target is an `Access`/`Arg`/`Var`/`Let`/`Const`/`Using` node, setting `self->symbol` on the function/generator/class-constructor (unwrapping a single-item parenthesized `Expressions`, only when the value has no own name). That symbol becomes the `FUNCTION`/`CONSTRUCTOR_FUNCTION` name operand in `fxFunctionNodeCode`. The port's coding-time equivalent is `pending_name`, which was staged for identifier declarations (`code_binding`), defines, and plain assignment (`code_assign_node`) — but **not** for the `= default` inside a destructuring pattern.

**Fix (one call site).** `code_assign`'s `Token::Binding` arm (`coder.rs`) now calls `self.set_pending_name(&n.children[0], &n.children[1])` before coding the initializer. `set_pending_name` already mirrors XS's target-token gate exactly, so this covers both binding patterns (declarations, catch params, function params, for-of/for-in heads) and assignment patterns, while a member or nested-pattern target correctly leaves the value anonymous. This is `fxBindingNodeCodeAssign`'s bind-pass counterpart, ported at the pin.

**Measured (all captured to files, exit codes checked directly):**
- `statements/try` → total=192 identical=166 **divergent=0** oracle-rejected=24 endor-rejected=2 — the 2 rejects are the documented `eval-scope params deferred` cases.
- `statements/for-of` → total=712 identical=641 **divergent=0** — **BAR MET**, Class A eliminated (was 45 divergent).
- `expressions/assignment` → total=466 identical=400 **divergent=0** — Class A eliminated; 4 endor-rejected are all the deferred `eval-scope params` class (not Class A, not divergences).
- Curated corpora → **1711/1711 identical, divergent=0, endor-rejected=0**.
- Module corpora → **35/35** byte-identical (covered by the passing `endor-262` workspace test).
- `cargo test --workspace -- --test-threads=1` → **EXIT=0** (49-test coder crate incl. new fixture, plus all sibling crates).

**Tests added.** `coder_byte_identity.rs` gains `destructuring_default_name_inference` — 26 fixtures spanning binding + assignment patterns; fn/arrow/class/generator/async values; renamed properties; parenthesized initializers; catch/function-param patterns; for-of/for-in heads; and two **negative** fixtures asserting nested-pattern and member targets stay anonymous. Passes byte-for-byte against the oracle.

**Invariants.** `#![forbid(unsafe_code)]` intact; `c/moddable` never staged; committed with explicit pathspecs; pushed to `origin/xs2rust-endor` (verified by git exit code, tip = `2e4763b1b`); PR #600 left **DRAFT** and untouched; no PR comment, no maintainer message.

**Residual scope (for siblings 2–6, not mine to fix):** the eval-scope-params deferred rejects on `try`/`assignment` are a separate known class. No Class-A divergence remains on the measured subtrees.
