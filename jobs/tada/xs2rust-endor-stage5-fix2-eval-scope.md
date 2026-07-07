All changes pushed and verified. Here is my completion report.

## Completion report: Stage-5 fix2 4/6 — in-function direct eval (the EVAL environment slice)

**Job:** `xs2rust-endor-stage5-fix2-eval-scope` — PR #600, branch `xs2rust-endor` (kept DRAFT). Pushed as `5b1c8da1d` (rebased on `9ed2f12c2`).

### What I did
Ported XS's in-function direct-`eval` emission from `xsCode.c`/`xsScope.c` at the oracle pin, removing the blanket `eval-scope params deferred` assert on `scope_coding_params`. The slice, incrementally landed and kept byte-identical:

1. **`fxScopeCodingParams`' eval branch** (`coder.rs`) — the parameter `with`/`STORE` publish: sloppy opens a leading `null` `with` then an `undefined` `with` into which each `Arg`/`Var`/`Const` slot is `STORE`d; strict skips the `null` `with`. Two `environment_level` pushes.
2. **`arguments` injection for eval functions** (`scoper.rs`) — XS injects the synthetic `arguments` `Var` at parse-known flag time; a *body-level* direct eval is only discovered during the body walk, so injection is now two-phase: before the body (references / parser-known eval, so a body `var arguments` still merges) and after (body-eval discovered), via a shared `inject_arguments` helper in both `hoist_function` and `hoist_function_no_self`.
3. **`fxScopeCodingBody`/`fxScopeCodedBody`** (`coder.rs`) — the sloppy two-`with` body dance (`var`/function declarations publish into a `null` `with`, lexicals into an `undefined` one) plus the two-`WITHOUT` teardown. Strict bodies stay on the block path (which already handled the eval publish).
4. **Direct-eval vs `with` disambiguation** — added `Scope.direct_eval` (set in `fx_scope_hoisted` from the node's hoist extra). `code_body` keys the body dance on the *body node's* direct-eval marker, not the poisoned scope flag, so a `with`-poisoned scope (which sets `SCOPE_EVAL` on the scope but leaves the node clean) correctly does **not** get the body dance.
5. **Loud fold for the honest remainder** — eval inside a **parameter default** (the parameter var-environment / `EVAL_ENVIRONMENT` split) is unported; guarded to panic (`eval in a parameter default (parameter var-environment) deferred`) rather than mis-emit.

Added the `eval_scope_in_function` byte-identity test (sloppy+strict, no-param/param/default/rest, body var/let/function decls, function decls vs expressions, nested functions, arguments interplay, `with` regression). Updated the `direct_eval_poisons_scopes` scoper fixture, which had encoded the old (missing-`arguments`) behavior.

### Bar / measurements

| subtree | before | after |
|---|---|---|
| **statements/try** | identical=166 divergent=0 **endor-rejected=2** | identical=168 divergent=0 **endor-rejected=0** ✓ |
| statements/function | identical=357 divergent=2 rejected=31 | identical=384 divergent=2 rejected=4 |
| expressions/function | identical=198 divergent=0 rejected=10 | identical=201 divergent=0 rejected=7 |

- `statements/try` endor-rejected → **0** (the `eval-scope params deferred` assert is gone), divergent 0.
- Both function subtrees: the previously-rejected in-function eval cases now compile **byte-identically or reject loudly** — no new silent divergences. The 2 remaining `statements/function` divergences (`S13_A15_T1/T3`) are **pre-existing** `arguments`-as-parameter cases, unrelated to this slice and diverging before my work.
- Remaining loud folds are all `eval in a parameter default` (4 files each in the two subtrees — the `scope-param-{elem,rest}-var-{close,open}` family) plus the separate pre-existing `captured function name deferred` (3, a different slice).
- **Curated corpora: 1711/1711 divergent=0 endor-rejected=0.** Module corpora test green (35/35, `module_corpora_byte_identity_no_divergence`).
- `cargo test --workspace -- --test-threads=1` **EXIT=0**. `#![forbid(unsafe_code)]` intact; no unsafe added.

### Residual scope (precise honest remainder)
The **parameter var-environment** for a direct `eval` inside a parameter default expression (`fxParamsBindingNodeCode`'s `EVAL_ENVIRONMENT` split for non-simple params) — kept as the self-naming loud fold `eval in a parameter default (parameter var-environment) deferred`. This is the next sub-slice for a follow-up child. (Separately, the pre-existing `arguments`-as-parameter divergence `S13_A15_T1/T3` and the `captured function name deferred` fold are unrelated slices.)
