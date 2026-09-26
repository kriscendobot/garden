All work is landed and pushed to `origin/xs2rust-endor`. Final summary:

## Completion report

**Job:** Stage-5 fix3 3/5, Class γ (nested/initializer direct-eval scope) + the parameter-default eval reject fold, on PR #600 (`xs2rust-endor`, kept DRAFT; no PR comment, no maintainer message, no `gh` calls).

**What I did — three code slices + a correctness fix + README, each pushed via rebase-CAS:**

1. **Class γ nested-function direct-eval capture** (`9f45d63ba5`). Ported `fxScopeCodeStoreAll`: an eval-scoped function now captures its *entire* enclosing lexical frame (not just names it lexically reads), storing each enclosing slot after its use-closure aliases. **`expressions/assignment` divergent 2 → 0** (`S11.13.1_A6_T1,T2`). Fixtures added.

2. **Parameter-default eval fold** (`632bb6c04d`). A direct `eval` in a parameter default poisons the *parameter* scope, not the body; restructured `code_body` so the `with`-frame teardown keys on the enclosing **function** node's eval flag (`fxScopeCodedBody`), not the body's. Removed the loud `panic`. **`statements/function` rejects 4 → 0** (subtree byte-clean), **`expressions/object` rejects 8 → 0**. Fixtures added.

3. **`node->declaration` correctness fix** (`729a581ba6`). Slice 1's store-all approximated `node->declaration` as "has a frame index", which wrongly captured synthesized slots (injected `arguments` `Var`, class anon field-init closures). Added a faithful `bound` bit set by the two bind self-lookups. **Fixed a regression** slice 1 introduced in the pre-existing `eval_scope_in_function` fixture, and **`statements/class` divergent 72 → 62** as a bonus, 0 new rejects/divergences.

4. **README ledger** (`a608404cfc`) updated to record the closures honestly.

**Bars:**
- `expressions/assignment`: divergent **2 → 0** ✅ (BAR MET)
- `statements/function`: endor-rejected **4 → 0** ✅ (BAR MET)
- `expressions/object`: endor-rejected **8 → 0** ✅ (its lone remaining divergence is sibling δ's, out of scope)
- Curated corpora: **1711/1711, divergent=0, endor-rejected=0** ✅ (maintained)
- `cargo test --workspace -- --test-threads=1`: **EXIT=0** ✅
- `#![forbid(unsafe_code)]` intact ✅
- Fixtures added (nested-fn eval sloppy+strict, param-default eval sloppy+strict) ✅
- No new divergence or reject introduced anywhere ✅

**Honest remainder (not completed):** The **class field-initializer** direct-eval sub-shape (Class γ) — the `class` 62 divergences (`*-visible-to-direct-eval*`, `derived-cls-direct-eval-*`, `privatename-*-earlyerr-*`, etc.). I diagnosed it precisely: the synthesized `instanceInit`/member-closure field function must key its eval prelude (`undefined; with; pop`) and store-all on the field-function scope's **own** `SCOPE_EVAL` (which endor must set at bind, after the hoist poison walk). The plain-`fi`-path case reduces to that, but the majority of the 62 files are the mixed private+public **`caps` path** (no real scope object) and the derived-constructor/superproperty/earlyerr shapes, each needing hand-rolled params-publish + store-all against the exact class-frame `node->declaration` gate. That is a larger coordinated scoper+coder fold with real regression risk to the byte-clean class corpora, so I left it as a named residual rather than a silent mis-emit, per the job's guidance. No new kill-criterion evidence: every residual stays attributed.
