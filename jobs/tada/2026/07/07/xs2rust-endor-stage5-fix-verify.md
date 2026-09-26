Inbox empty, remote tip is my pushed commit `fad688c98`, PR stays draft. All seven requirements are complete.

---

## Completion report — Stage-5 fix-verify 5/5 (closing tally)

**PR #600, branch `xs2rust-endor`, KEEP DRAFT.** Re-measured from a fresh sync of the real remote tip (was `825213276`); oracle pin `48ee02d8cfe0`. README updated + pushed (`fad688c98`).

### What I did & measured

1. **Workspace tests** — `cargo test --workspace -- --test-threads=1` **EXIT=0** (20 binaries, 0 failed; all byte-identity/parse-meter/fuzz-smoke/ses-xs-parity/boot-bundle/harden gates green).
2. **Full-corpus compile-diff (curated) — BAR FULLY MET on both goals:** script `total=1711 identical=1711 divergent=0 endor-rejected=0`; module `35/35/0/0`. (Was `1691/20` at child 7 — the coder-reject child closed all 20 folds → `1711/0`.)
3. **Broadened test262 sweep (8 subtrees, per-subtree).** Original 3 stay byte-clean (`addition` improved to 48/48). **The 5 new subtrees reveal divergences the curated corpora don't exercise** — for-of 45, class 191, object 67, try 10, assignment 15 divergent; class 53 / object 2 accept-disagreements. Named every class:
   - **Class A (kill-criterion-relevant, NOT a documented fold):** NamedEvaluation not emitted for a function/class/arrow/gen used as a **destructuring default** (`dstr/*-init-fn-name-*`; oracle emits the name opcode, endor emits `0x00`). A **mis-emit on accepted programs** — dominant in for-of/try/assignment/object (~120+ files). Confirmed on `catch ({ arrow = () => {} })`. Reads as a **narrow, fixable coder gap**, not fundamental infeasibility — but unclosed. Supervisor owns the verdict.
   - **B** async-gen `yield*` byte-length divergences; **C** class-tail byte-length / numeric accessor-key / direct-eval divergences; **D** the 1572+ endor-rejects are the *documented* loud folds (private-member read, in-function eval, async-gen private methods) — expected; **E** accept-disagreements are missing early-errors (`*-init-err-contains-arguments`, `grammar-privatemeth-duplicate-*`, `*-param-strict-body`).
4. **`using` heads** — oracle **rejects** `using x = a` at the pin (ERM absent); endor rejects identically → **reject-agreement, no gap**.
5. **Parse-meter determinism** green; **endor-fuzz** builds + smoke tests pass.
6. **Stage-4 regressions HOLD exactly** — Object 176/0 of 3127, Function 40/0 of 511, Array 437/0 of 2625 (all BAR MET, no aborts); harden-corpus/boot-bundle/ses-xs-parity green.
7. **README** stage-5 block rewritten with the re-measured tables + Classes A–E, folds pruned; committed README-only (`c/moddable` never `git add`-ed) and pushed.

### What changed
- `rust/engine/README.md` — stage-5 acceptance evidence block re-measured (commit `fad688c98`, pushed to `xs2rust-endor`).

### Follow-ups (for the supervisor)
- **Kill-criterion call is yours** on Class A. My read: honest byte-identity failure outside any documented fold, but a narrow/nameable candidate for a follow-up fix child (extend identifier-LHS name inference to destructuring binding/assignment initialization), not fundamental infeasibility.
- Further byte gaps (Class B/C) and accept-side early-errors (Class E) are additional follow-up candidates.
- Full tally sent to `port-xs-to-rust-memory-safe-engine-s13`; that inbox had already completed, so it was **dead-lettered and will be promoted to a fresh job** (intent preserved).
