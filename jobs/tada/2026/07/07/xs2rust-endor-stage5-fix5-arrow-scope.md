All 5 fix5 commits are on `origin/xs2rust-endor` (tip `871735cfb`), HEAD synced. This resume session added the 10.5-1-s closure cleanly on top of the earlier three slices, and reverted an incomplete attempt. All invariants verified green. This is a clean, complete stopping point.

## Completion report — xs2rust-endor-stage5-fix5-arrow-scope (fix5 1/5)

Resumed after reaper requeue. My earlier session's 4 commits were intact on the remote; this session added one more clean closure and reverted an incomplete attempt. Final tip `871735cfb` on `origin/xs2rust-endor` (5 fix5 commits), all pushed and verified by exit code against oracle pin `48ee02d8`.

### What this resume session added
**Named-function-expression self-name publish under eval (`871735cfb`) — closes `arguments-object/10.5-1-s.js`.** XS declares a named function expression's self-name via `fxDefineNodeNew(…, XS_TOKEN_CONST)` — a define entry whose declare *token* is `CONST`, so `fxScopeCodingParams`' eval `with`-publish loop (`ARG||VAR||CONST → STORE_1`) publishes it alongside the injected `arguments` `VAR`. endor modeled the self-name as `Token::Define` and published only `Arg/Var/Const`, emitting one `STORE_1` too few (133 vs 135). Fixed `scope_coding_params` to publish `Token::Define` too — safe because the *only* `Define` a function param scope ever holds is that self-name (body function declarations live in the body/block scope; field-init functions are anonymous). Locked in `named_function_expression_self_name_under_eval`.
- `arguments-object`: divergent **1 → 0** → **fully byte-clean, 260/260, BAR MET**

I also investigated `binding-tests-3.js` deeply, attempted an `mxArgumentsFlag`-propagation fix, found it produced the *wrong* mechanism (a real `arguments` VAR with `ARGUMENTS_SLOPPY` materialization, 2 bytes too long), and **reverted it cleanly** (scoper.rs has zero net diff) rather than land a divergence.

### Full fix5 1/5 outcome (all 4 slices, measured before → after)
| subtree | before | after |
| --- | --- | --- |
| `expressions/arrow-function` | 6 divergent | **1 divergent** (binding-tests-3, attributed) |
| `eval-code` | 3 div + 4 accept-disagree | **fully clean 151/151** |
| `arguments-object` | 1 divergent | **fully clean 260/260** |
| `expressions/optional-chaining` | 1 div + 2 endor-rej | **0 divergent** (2 tagged-template rejects, attributed) |

Slices closed: arrow receiver-capture-under-eval (`a88145ba3`, 8 files); runtime-SyntaxError-from-eval harness fix (`7a0c1135f`, eval-code accept-disagree 4→0); optional-call receiver drop via `code_this` Chain/Option arms (`7121743e2`, optional-chain.js); self-name publish (`871735cfb`, this session).

### Invariants (all green at final tip)
Curated **1711/1711** divergent=0; `statements/class` + `expressions/class` **divergent=0 endor-rejected=0** (unchanged); `cargo test --workspace -- --test-threads=1` **EXIT=0**; `#![forbid(unsafe_code)]` intact (changes confined to `coder.rs` + `compile_diff.rs`, no unsafe). New locked fixtures: `arrow_receiver_capture_under_eval`, `optional_call_reference_is_byte_identical`, `named_function_expression_self_name_under_eval`, plus harness unit tests `runtime_syntax_error_from_eval_is_a_compile_accept` / `genuine_parse_rejection_is_not_reclassified`.

### Remaining (precisely attributed in README ledger, per the bar's allowance)
1. **`binding-tests-3.js`** (last arrow divergence) — the **enclosing-function synthetic capture-closure** fold: when an arrow with a direct eval is created in an eval-poisoned non-arrow function, XS reserves a materialization-free synthetic closure (`NEW_CLOSURE` + `with`-publish `STORE_1`, no `ARGUMENTS_SLOPPY`) for the arrow's `STORE_ARROW`/`RETRIEVE` capture. Distinct from both the self-name publish and the receiver-capture folds; the wrong-hypothesis attempt (real arguments VAR) was rejected and documented. Deferred as a narrower sub-fold.
2. **2 `endor-rejected` in optional-chaining** (`call-expression.js`, `member-expression.js`) — the deferred **tagged-template** feature (raw/cooked atom-table cache), not an optional-chaining change.

Follow-up job candidates: the enclosing-function synthetic capture-closure fold (materialization-free, eval-poisoned interaction) and the tagged-template feature port.
