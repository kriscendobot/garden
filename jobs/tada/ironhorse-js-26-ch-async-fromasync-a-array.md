---
handed-off: ironhorse-js-26-ch-async-fromasync-a-orch
deliverable-complete: false
---
Everything is in place: worktree clean, fromAsync core committed and pushed to `origin/feat/ironhorse-262-language-completion`, and the successor orchestration is durably on `origin/journal2`. The deadline nudge confirms the evidenced-handoff path. Writing the report.

---

## Completion report: `Array.fromAsync` native async state machine (child A)

**Delivered (committed + pushed to `feat/ironhorse-262-language-completion`, PR endojs/endo-but-for-bots#970, head `963ff7da9`):**

Implemented `Array.fromAsync` as a native async state machine on the existing native-reaction substrate (`schedule_native_await` / `ReactionKind` / `run_promise_job` / `new_promise_capability`), with a `FromAsyncData` side table + new `ReactionKind` await-point variants. Full spec surface: async-iterable (`@@asyncIterator`), sync-iterable (intrinsic **and** custom `@@iterator`, live array iteration, per-element value `Await` with close-on-rejection), array-like fallback (incl. boxed primitives reading inherited `length`/index), `mapfn`+`thisArg`, this-constructor behavior (`Construct(C[, len])` / `ArrayCreate` with the 2³²−1 RangeError), and error/close semantics (`IteratorClose` on mapfn-throw / define-failure).

Supporting engine fixes the surface required:
- `call_any` — general `Call` dispatch so a native reaction handler installed by `promise.then(resolveFn, rejectFn)` (e.g. `assert.throwsAsync`) settles instead of self-naming.
- User functions now get the spec-required own `prototype.constructor` (unmetered; only when the program names `constructor`).
- `ensure_from_async_protocol_atoms` — force-reify the iterator-protocol atoms/methods when a program uses `fromAsync`.
- `Array.fromAsync` bound with `.name`/`.length`.

**Measured (XS oracle, pin be13516f):** `built-ins/Array/fromAsync` **2 → 77 covered of 95, 0 failures**. Added `rust/engine/ironhorse-262/tests/array_from_async.rs` (16 focused regression tests, all pass). No relabeling/skip-lists.

**Regression gates (all green):** `cargo test --workspace --release` (0 failures); `--gate-meter-exact` on `built-ins/Promise` (319 covered/0 failed), `language/statements/class` (3761/0), `built-ins/Function/prototype` (122/0). Rebased cleanly onto peer Map/Set/groupBy work before pushing.

**Remaining (handed off) — durably posted orchestration `ironhorse-js-26-ch-async-fromasync-a-orch` (serial, halt-on-failure) on `origin/journal2`, owning two bounded children:**
1. `…-a-asyncfromsync` — `%AsyncFromSyncIteratorPrototype%` (currently 6/38), driven by async-gen `yield*` / `for await` over sync iterables via `XS_CODE_FOR_AWAIT_OF` + `CreateAsyncFromSyncIterator` (a distinct mechanism from fromAsync; the child carries my full diagnosis).
2. `…-a-residual` — the last ~18 fromAsync cases, each blocked by a diagnosed **pre-existing** engine gap (well-known-symbol `.description`; strict async-function `this`-binding; `verifyProperty` on native-method `length`/`name`; native-method `[[Construct]]`→TypeError; TemporalHelpers `propertyBagObserver`) — not defects in the fromAsync machine.

Core `Array.fromAsync` deliverable landed and verified; the `%AsyncFromSyncIteratorPrototype%` half and the residual pre-existing-gap cases are owned by the posted orchestration.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-ch-async-fromasync-a-array.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (3 unmetered)
- Input: 313 tokens (55607530 cached reads)
- Output: 170268 tokens
- Cost: $35.31275399999999 (3 engagement(s) unpriced)
- Wall-clock: 5214s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
