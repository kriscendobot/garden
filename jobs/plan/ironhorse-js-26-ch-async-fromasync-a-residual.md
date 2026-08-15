---
gate: orchestrated
orchestrated_by: ironhorse-js-26-ch-async-fromasync-a-orch
priority: normal
posted_by: producer
posted_at: 2026-08-15T05:13:26Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Async child A.3: `Array.fromAsync` residual — close the last ~18 cases (pre-existing engine gaps)

Nested child of `ironhorse-js-26-ch-async-fromasync-a-orch`. The `Array.fromAsync`
NATIVE STATE MACHINE landed (`built-ins/Array/fromAsync` 2 → 77 covered of 95, 0
failures, commit on `feat/ironhorse-262-language-completion` PR #970, plus 16 Rust
regression tests in `rust/engine/ironhorse-262/tests/array_from_async.rs`). The
remaining ~18 fromAsync cases are each blocked by a **pre-existing engine gap the
fromAsync test files happen to exercise** (NOT a defect in the fromAsync machine —
its async-iterable/sync-iterable/array-like/mapfn/thisArg/error-close/this-constructor
behavior is verified correct). Close each gap; do NOT relabel/suppress.

The fromAsync child DIAGNOSED each remaining case (faithful harness repro). The gaps:

1. **Well-known symbol `Symbol.prototype.description`** — blocks ~8 `observeProperty`
   cases (`asyncitems-{asynciterator,iterator}-{exists,null,sync,promise}`,
   `asyncitems-arraylike-promise`, `asyncitems-operations`, `this-constructor-operations`).
   `Symbol.asyncIterator.description` returns `undefined` (should be
   `"Symbol.asyncIterator"`). `TemporalHelpers.observeProperty`'s getter calls
   `formatPropertyName` → `propertyKey.description.startsWith('Symbol.')` → TypeError
   on `undefined.description`, so the observer getter throws and fromAsync rejects.
   Well-known symbols ARE created with a description slot (`interp.rs` ~line 5396,
   `Symbol.<name>`); the `.description` accessor on `%Symbol.prototype%` is what is
   missing/returning undefined. Implement it. (`Symbol.keyFor` and `.startsWith` work.)

2. **Strict async-function `this` binding** — blocks `thisarg-omitted-strict`,
   `thisarg-primitive-strict` (2, reason `unsupported-opcode:to_primitive:no-primitive-result`).
   A STRICT async function called with `undefined`/primitive `thisArg` must bind that
   value verbatim; ironhorse coerces `undefined` → global (verified OUTSIDE fromAsync:
   `'use strict'; (async function(){return this}).call(undefined)` yields non-undefined).
   The assert-failure message then `ToString`s the global object → `to_primitive`
   halt. Fix strict async-function this-binding (and/or the global stringification).

3. **`verifyProperty` on a native method's `length`/`name`** — blocks `length.js`,
   `name.js` (2, `ironhorse-aborted`). `Array.fromAsync.length===1` and
   `.name==="fromAsync"` are now CORRECT (fixed in the parent via `alloc_named_method`),
   but `propertyHelper.js`'s `verifyProperty` still aborts — its descriptor
   writable/enumerable/configurable probing hits an unsupported op on a native
   method's own `length`/`name` accessor. Diagnose with the harness and close.

4. **Native method `[[Construct]]` → TypeError** — blocks `not-a-constructor.js`
   (1, `ironhorse-aborted`). `new Array.fromAsync()` must throw TypeError (a native
   prototype method is not a constructor); today the construct dispatch runs it and
   returns an object. Make the RUN/construct path reject a `FuncInfo.method.is_some()`
   (or plain-native non-constructor) target with a catchable TypeError. Broad but
   in-scope; verify no regression to legitimate native constructors.

5. **TemporalHelpers `propertyBagObserver`** — blocks `mapfn-result-awaited-once-per-iteration`
   (1, `callback:non-user-function`) and possibly `thisarg-primitive-sloppy` (1,
   reported-failure) + `asyncitems-bigint` (verify). `propertyBagObserver` wraps in a
   Proxy/observer whose `.then` access is logged; diagnose the exact op.

Approach: fix the SMALLEST correct engine change per gap (each is generally useful
across the arc, not fromAsync-specific). Re-run `full-run.sh --subtree
built-ins/Array/fromAsync` after each. Target: 95/95 covered, zero forbidden reasons.

**Acceptance bar / invariants / branch / pins:** identical to the parent (see PR
#970, `feat/ironhorse-262-language-completion`, pin be13516f, XS 23b4d6b0). NO
relabel/skip-list; full workspace gates + `--gate-meter-exact` corpus before every
push; fetch+rebase CAS loop (peers touch `interp.rs`).

**Report:** commands, before/after totals for `built-ins/Array/fromAsync`, per-gap
fix summary, changed skip reasons, head SHA, PR URL.

issue_spine: issue-kriscendobot-garden-51
submitter: kriscendobot
