PR #970 remains draft (OPEN), as required. Empty inbox. The work is complete and pushed. Let me write the completion report.

The job asked to implement standards-faithful direct and indirect eval semantics on the shared branch for draft PR #970, cover official `language/eval-code`/`function-code` through real execution against pinned XS, add oracle-backed Rust tests, and run the required verifications without regressing the exact-meter corpus. Here is what I did.

## Completion report

**Repository / branch / PR:** `endojs/endo-but-for-bots`, shared branch `feat/ironhorse-262-language-completion`, draft PR #970 (still draft, not undrafted, not merged). Worked in an isolated per-job worktree, fetched, rebased onto the advanced remote (a peer's regexp commit `cf9247cd0` landed mid-flight — preserved via rebase, no conflicts), pushed by CAS. **New HEAD SHA: `0094e4ca9`** (`cf9247cd0..0094e4ca9`).

**What I found and implemented** (in `rust/engine/ironhorse-vm/src/interp.rs`). The preceding child had already removed the source-text pattern checks and landed the compiler/VM bridge, so this child extended the *semantics* it executes. Using the differential oracle to establish ground truth, I fixed three standards-faithful gaps, matching pinned XS exactly:

1. **`typeof` of an unresolvable name → `"undefined"`, never a throw** (ECMA-262 13.5.3.1). This was a general engine bug — `typeof undeclaredGlobal` threw `ReferenceError` engine-wide, not just in eval. XS encodes the rule by peeking the opcode after `GET_VARIABLE`; ironhorse now does the same, gated so a `typeof` of a *bound* TDZ binding still throws.
2. **`CanDeclareGlobalVar`/`CanDeclareGlobalFunction` on a sealed global → `TypeError`.** An eval declaring a new `var`/function after `Object.preventExtensions(this)` now faults before any body runs.
3. **Direct-eval `var`/global-lexical collision → catchable `SyntaxError`** (the "duplicate variable" early error), detected via a declarative-environment-chain walk that distinguishes lexical closure cells from a `with(obj)` object environment. Indirect eval correctly does **not** raise (matching XS, which throws only for the direct form).

The top-level program's success path is untouched (the new checks fire only for a sealed global or a direct-eval lexical collision, neither reachable in ordinary declaration instantiation), so the bit-exact meter corpus is unchanged.

**Tests added:** `rust/engine/ironhorse-262/tests/eval_declaration_semantics.rs` — 6 oracle-backed regression groups covering direct/indirect typeof, TDZ-still-throws, direct-vs-indirect declaration collision, eval-scoped lexicals not leaking, and non-extensible-global definability. No skip-list/expectation/reason-only changes.

**Verification (all run against pinned XS, revision `be13516`):**
- `language/eval-code`: **72 covered / 1 failed → 82 covered / 0 failed** (BAR MET). The one hard failure (`direct/var-env-global-lex-non-strict.js` negative over-acceptance) is fixed; `ironhorse-aborted` dropped 13→4.
- `language/function-code`: steady **197/219, 0 failed** (its cases don't exercise the fixed paths).
- `language/expressions/typeof`: **8 → 9** (broad typeof-fix benefit beyond eval).
- `cargo test --workspace --release`: **67 suites, 0 failures.**
- Exact-meter corpus (`corpus_conversion_equivalence`, 1712 cases, `--gate-meter-exact`): **passed, 0 failed — unchanged.**

**Remaining causal reasons on `language/eval-code`** (69 skipped, all honestly named): `eval:direct-scope` (37 — direct eval inside a *function* frame, needing caller-local capture the model deliberately does not implement); `strict:/abort-value-differs` (13 — largely XS-non-conformance artifacts where ironhorse already matches XS's actual behavior but harness error strings diverge); `defineProperty:global-object` (4 — a function-redeclaration MOP path); `eval:compiler-unimplemented` (4 — parse-failure fixtures); `store_arrow` (3); `module:evaluation` (4 — out of eval scope). These are follow-up territory, not regressions.

No gated outcome was missed: coverage rose with zero Ironhorse failures, the meter corpus is unchanged, and the workspace suite is green.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-eval-02-semantics.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 250 tokens (19398727 cached reads)
- Output: 102698 tokens
- Cost: $14.492696499999997
- Wall-clock: 1810s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
