All work is complete and verified. Let me confirm the PR draft state is untouched (I never un-drafted it) and finalize.

Completion report:

## Stage 7 child 3/7 — `Promise.prototype.finally` + combinators: DONE

**What I did.** Landed `Promise.prototype.finally` and the four combinators (`Promise.all`, `allSettled`, `race`, `any`) on the existing 5-slot native-reaction path in `endor-vm`, replacing the `Halt::Unsupported` stubs.

**What changed** (commit `1449b3c58`, pushed to `origin/xs2rust-endor`; PR #600 kept DRAFT):
- `endor-vm/src/interp.rs` — two new `ReactionKind`s the drain (`run_promise_job`) dispatches on: `FinallyReturn` (runs `onFinally`, passes the settlement through) and `Combine(comb_idx, elem_idx)` (folds each element into a shared `CombinatorState` — XS's `remainingElementsCount` cell + values/errors Array). `all` rejects-first/else index-ordered values; `allSettled` builds `{status,value|reason}` records and never rejects; `race` first-settles; `any` first-fulfills or rejects with an `AggregateError`. A shared `register_native_reaction` + `promise_resolve_to_instance` back both; `promise_then_native` refactored onto them. Only dense-Array iterables modeled (mirrors `build_aggregate_error`); others are a named skip. Reactions run **only at the pump-loop drain** — the crank discipline the existing promise tests lock (item 3 satisfied).
- `endor-snapshot/src/sidetable.rs` — new `SideTable::Combinators` ledger row (Pending, like `PromiseJobs`; VARIANT_COUNT 29→30) so the runtime-only state isn't a silent snapshot gap.
- `endor-262/tests/promise_combinators.rs` — 15 dual-run tests: oracle result-agreement + the resolved value read from a post-drain global + deterministic computrons.

**Metering** (item 4): advisory endor-own constants under the accuracy-over-parity doctrine — purely additive on previously-unsupported surface, so no existing computrons move and `endor-meter-1` is unchanged (children-1/2 precedent).

**Verification — all EXIT=0:**
- `cargo test --workspace -- --test-threads=1`: all 31 `test result:` lines 0 failed (incl. sidetable exhaustiveness).
- new `promise_combinators.rs`: 15/15 passed.
- `compile-diff` (curated): 1711/1711 + SYMB 1711/1711.
- `endor-xst built-ins/Promise`: **68→109 covered, 0 failed**, every skip named (76 `non-array-iterable`, rest pre-existing families).
- `--repeat 3`: no determinism violations. `#![forbid(unsafe_code)]` intact; no new warnings.

**Honest remainder / follow-ups** (all named skips, never wrong answers):
- Non-dense-Array iterables (`promise-combinator:non-array-iterable`, 76 cases) — general iterator-protocol walk is a later increment.
- `onFinally` throwing (`promise:handler-throw`) or returning a thenable (`finally:thenable-return`) self-name — the re-entrant throw-unwind and thenable chaining are deferred, consistent with the existing `promise:handler-throw` deferral.
- `race` allocates an unused results Array (advisory-metering only).

Practical note: had to check out the oracle pin `23b4d6b0` into `c/moddable` (submodule was uninitialized); left it in the working tree, **never `git add`-ed**.
