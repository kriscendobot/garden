Empty inbox. Work is complete and pushed. Final report:

---

## Completion report: `ironhorse-js-26-eval-04-annexb-source`

**Repository:** `endojs/endo-but-for-bots` · **Branch:** `feat/ironhorse-262-language-completion` (draft PR #970) · **Pushed SHA:** `97fad0abd` (HEAD of the shared branch; no merge, no undraft)

### What I did
Closed the Annex B / parser-source-text portion exposed by runtime `eval` and the dynamic `Function` constructor by making ironhorse reproduce the pinned XS oracle's **exact thrown values** (four-valued agreement *and* `String(exception)` text), not a bare-constructor error that stalled every case at an `abort-value-differs` skip.

Root cause found empirically against the oracle: XS *declines* the Annex B block-level-function extensions these slices probe (a `FunctionDeclaration` in an `if`/`else` clause, a `do`/`for`/`while` body, a label) with `SyntaxError: no block (strict code)`; does not treat `<!--`/`-->` as HTML comments (assembled dynamic-function text is a parse error at `missing )` / `missing expression`); and names an undefined-variable read `ReferenceError: get <name>: undefined variable`. Ironhorse's parser already emitted XS's wording, but two seams dropped it.

### What changed
- `ironhorse-262/src/lib.rs` — thread the bare parser diagnostic (no `line N:` prefix) through `SourceCompileError::Syntax`.
- `ironhorse-vm/src/interp.rs` — `eval_source` relays that message into a new `catchable_syntax_error_msg`; the unresolvable-`GET_VARIABLE` (and `with`/eval-object miss) `ReferenceError` now carries `get <name>: undefined variable` via the operand's `symbol_names`. Both use a new `internal_error(name, message)` built exactly like `build_error(name,0,0)` (same geometry/proto/meter) with the message attached **unmetered** on the render side and as a real own non-enumerable `message` property.
- `ironhorse-262/tests/annexb_eval_source.rs` — 6 oracle-backed regressions (positive + negative) pinning the exact XS diagnostic for every family: the `no block` grammar forms, undefined-variable naming, dynamic-`Function` HTML-comment / line-terminator forms.

### Coverage before → after (`--gate-meter-exact`, test262 `be13516fb6`, 0 ironhorse failures, 0 over-acceptance)
- `annexB/built-ins/Function`: **1 → 5** (of 6)
- `annexB/language/eval-code/direct`: **24 → 122** (of 309)
- `annexB/language/eval-code/indirect`: **24 → 121** (of 160)

### Verification
- `cargo test --workspace --release` — green.
- Exact-meter corpus bit-identical: the 51 pre-existing `--gate-meter-exact` divergences (all stage3*/regexp) are unchanged by this commit — proven by a byte-diff of the failing-case list against the base binary. No new meter violation.
- Broad no-over-acceptance spot check (const/typeof/try/eval/global-code slices): all BAR MET, 0 failed.

### Follow-ups (out of this child's scope; not coverable here)
- `eval:direct-scope` (144 direct cases): direct eval in a *function* frame needs caller-local scope capture.
- `defineProperty:global-object` (48): global object ↔ environment-record coupling.
- The Annex B.3.3 var-hoist of an eval block-level function is **not implemented by XS itself**, so those assertions are shared XS+ironhorse failures rendered through the user `Test262Error` (a separate rendering gap), not coverable against this oracle.
- `Function('<!--')` — lone HTML-open-comment case whose parser message still diverges (`missing identifier` vs `missing expression`), a bare-token-position difference left honest.
- Optional: XS names the variable in `duplicate variable %s` too (ironhorse omits it) — would cover 1 more case but touches 6 scoper sites + unit tests; deferred.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-eval-04-annexb-source.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 308 tokens (25612286 cached reads)
- Output: 107893 tokens
- Cost: $17.993138
- Wall-clock: 1776s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
