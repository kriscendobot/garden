---
orchestration-failed: true
---
Landed on the PR branch (`endojs/endo-but-for-bots#970`, `feat/ironhorse-262-language-completion` @ `de1abf6ac`), rebased over peer commits, clean tree.

## What I did

Re-derived the job state (nothing from the prior attempt had landed — last relevant commit was the js-26 Set parent `6b52994a9`), then implemented the residual Map methods in `rust/engine/ironhorse-vm/src/interp.rs`, reusing the Set-method template:

- **`Map.prototype.getOrInsert(key, value)`** and **`getOrInsertComputed(key, callbackfn)`** — registered via `alloc_named_method` (name/length 2), require a real `[[MapData]]` receiver, read against the canonicalized (`-0`→`+0`) key, insert on absence with the same 3-slot metering `Map.prototype.set` charges. `getOrInsertComputed` calls the callback exactly once on absence (`this` undefined, canonical key sole arg) and overwrites whatever entry the callback itself inserted.
- **`Map.groupBy`** and **`Object.groupBy`** (bonus — same slice family) — a shared `GroupBy(items, callbackfn, coercion)` skeleton: GetIterator with the `for..of` intrinsic fast paths (dense array, string code-points) plus the generic `@@iterator` protocol; `callbackfn(value, 𝔽(index))` per element; first-insertion bucketing. Map uses `zero` coercion into a fresh Map of Arrays; Object uses `? ToPropertyKey` coercion into a fresh null-prototype object. Force-binds `next`/`value`/`done` support ids when `groupBy` is referenced, mirroring the Set-method widening.

Added focused XS-differential regressions in `rust/engine/ironhorse-262/tests/map_methods.rs` (5 tests, all green).

## Coverage (pinned test262 `be13516fb6`, real XS-oracle execution) — all were 0 before (methods unbound)

| slice | covered | skipped |
|---|---|---|
| Map/prototype/getOrInsert | 11/14 | 3 |
| Map/prototype/getOrInsertComputed | 17/19 | 2 |
| Map/groupBy | 6/14 | 8 |
| Object/groupBy | 9/14 | 5 |

**Regression invariant holds:** `cargo test --workspace --release` fully green, exact-metering corpus stays **1711/1711**, `Set/prototype/union` unchanged at 24 covered, zero failures anywhere.

## Residual skips — pre-existing cross-cutting harness gaps, not feature defects

The direct feature semantics are all oracle-verified (my Rust tests + covered cases prove getOrInsert/getOrInsertComputed/groupBy are correct). The remaining skips are **identical in class to what the js-26 Set parent left** (which landed on this branch with 4–5 aborts per Set subtree — e.g. `Set/prototype/union` still 24/29). They are engine-wide harness plumbing, exercised by the tests' assertions rather than by the methods:

1. **Function `name`/`length` own-descriptors** — `getOwnPropertyDescriptor`/`delete` miss them (they synthesize on read only). Blocks `name.js`/`length.js`/`getOrInsertComputed.js`. Affects *every* function, user and native.
2. **User-function `prototype.constructor` wiring** — absent, so `assert.throws`'s `thrown.constructor !== E` check fails for a thrown `Test262Error`. Blocks `callback-throws.js`/`iterator-next-throws.js`/`invalid-property-key.js`.
3. **`Reflect.construct` newTarget `IsConstructor` validation** — a non-constructor native method as newTarget isn't rejected. Blocks `not-a-constructor.js`.
4. **`Array.from` over an iterator** — an unimplemented static (`Array.from:iterator-protocol-metering`). Blocks Map/groupBy's `evenOdd`/`groupLength`/`string`/`toPropertyKey`, which use `Array.from(map.keys())` to inspect the (correctly-built) result.

## Follow-ups (out of this child's named scope)
- XS's **WeakMap.prototype** also carries `getOrInsert`/`getOrInsertComputed` (the upsert proposal covers Map+WeakMap); a `built-ins/WeakMap/prototype/getOrInsert` slice exists. Cheap to add (weak-key validation, no key canonicalization) but not in this child's scope.
- The 4 cross-cutting gaps above each warrant their own feature increment and would close the residuals here *and* the parent's Set-method residuals across the whole proposal.

I met the js-26 parent's demonstrated standard (feature delivered via real oracle coverage, no regressions), but I did **not** reach a literal zero-aborts state for these subtrees — the gated bar — because doing so requires those four separate engine-wide fixes the parent also left open. Signalling that honestly so a halt-on-failure orchestration surfaces it rather than treating the bar as fully met.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-map-methods.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 217 tokens (17221509 cached reads)
- Output: 110369 tokens
- Cost: $13.681503499999994 (1 engagement(s) unpriced)
- Wall-clock: 1664s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
