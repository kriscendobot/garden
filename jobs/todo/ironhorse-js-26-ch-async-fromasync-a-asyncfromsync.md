---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-15T05:16:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Async child A.2: `%AsyncFromSyncIteratorPrototype%` via async-gen `yield*` / `for await` over sync iterables

Nested child of `ironhorse-js-26-ch-async-fromasync-a-orch` (the decomposition of
`ironhorse-js-26-ch-async-fromasync-a-array`, whose `Array.fromAsync` core LANDED —
`built-ins/Array/fromAsync` went 2 → 77 covered of 95, commit on
`feat/ironhorse-262-language-completion`, PR endojs/endo-but-for-bots#970).

**Scope:** `built-ins/AsyncFromSyncIteratorPrototype` — currently **6 covered of 38**
(32 skipped: ~14 `ironhorse-aborted`, ~17 `async:reported-failure`, 1
`async:unhandled-rejection`) at branch head. Convert to covered (XS-oracle gated).

**Key finding (from the fromAsync child's investigation):** these 38 cases are NOT
driven by `Array.fromAsync`. They are driven by **`yield*` delegation inside an
async generator over a SYNC iterable** (e.g. `async function* g(){ yield* syncGen(); }`
then `g().next().then(...)`) and by `for await ... of` over a sync iterable. Both
compile through `XS_CODE_FOR_AWAIT_OF` (see `ironhorse-compile/src/coder.rs`
`code_delegate`, which emits `XS_CODE_FOR_AWAIT_OF` for async `yield*`).

**What to build.** Today `XS_CODE_FOR_AWAIT_OF` in `interp.rs` (search
`XS_CODE_FOR_OF | XS_CODE_FOR_AWAIT_OF`) falls back to the bare **sync** iterator
for a sync iterable and lets the compiler-emitted loop `await` each `next()`.
Per spec, `for await` / async `yield*` over a sync iterable must call
`GetIterator(obj, async)` which, when `@@asyncIterator` is absent, does
`CreateAsyncFromSyncIterator(GetIterator(obj, sync))`. Implement a real
`%AsyncFromSyncIteratorPrototype%` intrinsic (object with `next`/`return`/`throw`
native methods + the value-unwrap functions) and make the `FOR_AWAIT_OF`
sync-iterable fallback return that wrapper instead of the raw sync iterator, so the
existing delegate/for-await loop drives it. Cover:
- `.next(v)`: `NewPromiseCapability`; `IteratorNext(syncRecord, v)` (IfAbruptReject);
  `IteratorComplete`/`IteratorValue` (IfAbruptReject); then
  `AsyncFromSyncIteratorContinuation` — `PromiseResolve(value)` + a value-unwrap
  reaction (`[[Done]]`) that repackages `CreateIterResultObject(unwrapped, done)`,
  with **close-on-rejection** (`fromAsync` passes it too; a rejecting value closes
  the sync iterator). Note `.next()` called with no args must NOT pass an argument
  to the sync `next` (absent-value tests).
- `.return(v)` / `.throw(v)`: the full spec edge matrix the corpus exercises
  (absent underlying method, poisoned `return`/`throw`, result-not-object,
  iterator-result-unwrap-promise, poisoned `done`/`value`, throw-undefined →
  `IteratorClose` + TypeError, etc.).

Reuse the native-reaction substrate (`schedule_native_await`, `ReactionKind`,
`new_promise_capability`, `settle_via_function`, `register_native_reaction`) exactly
as the landed `Array.fromAsync` machine does — add a `ReactionKind` variant + side
table for the value-unwrap step. **Regression-critical:** `FOR_AWAIT_OF` is on the
hot path for ALL existing `for await`/async-`yield*`; the fromAsync child confirmed
several `for await`-over-sync cases already pass via the current bare-fallback, so
verify no async-generator / for-await regressions (run `cargo test --workspace`,
the async-generator tests, and a meter-exact sweep of `language/statements/for-await-of`
and `built-ins/AsyncGeneratorFunction`/`built-ins/AsyncFromSyncIteratorPrototype`).

**Reusable helper already landed:** `interp.rs` now has `call_any` (a general
`Call` dispatch handling promise resolving fns / native methods / native / bound /
user) — use it when a native reaction handler must invoke a capability settler.

**Acceptance bar / invariants:** identical to the parent. Convert the scope to
covered via real XS-oracle execution; add focused Rust tests under
`rust/engine/ironhorse-262/tests/`; NO relabel/suppress/skip-list. Zero
`ironhorse-aborted`/`parse-or-decode`/`unsupported-opcode:*`/`abort-value-differs`/
`non-primitive-completion` in scope. No baseline/earlier-child regression; full
workspace gates + exact-metering corpus before every push.

**Shared branch/PR:** `feat/ironhorse-262-language-completion` (PR #970 — keep OPEN,
do NOT merge). Fetch+rebase before every push (rebase CAS loop; peers push serially
and touch `interp.rs` — expect conflicts near `link_intrinsics`/`install_intrinsic_bindings`).

**Pins:** test262 `tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972` (checkout
`/home/kris/garden/scratch/test262-pin-be13516f`); XS oracle
`23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (`git submodule update --init --depth 1
c/moddable`). Rust: prepend `$HOME/.cargo/bin`; `TMPDIR=/home/kris/garden/tmp`.

**Report:** commands, before/after totals for `built-ins/AsyncFromSyncIteratorPrototype`,
changed skip reasons, head SHA, PR URL.

issue_spine: issue-kriscendobot-garden-51
submitter: kriscendobot
