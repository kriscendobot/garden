Pushed to PR #970 branch. The job is complete.

## Completion report

**Job:** Add `WeakMap.prototype.getOrInsert` / `getOrInsertComputed` to the Ironhorse/XS engine (`endojs/endo-but-for-bots`). This is the explicit follow-up the parent `ironhorse-js-26-map-methods` job flagged (Map forms already landed; WeakMap forms deferred).

**Re-derived state:** Fresh worktree off a reaped requeue. Confirmed the Map upsert methods already landed on PR #970 (`feat/ironhorse-262-language-completion`); the WeakMap forms were unbound. No prior WeakMap commit existed to resume.

**What I did** (project worktree, one commit `9a8b381bf` pushed to the PR #970 head branch):
- `rust/engine/ironhorse-vm/src/interp.rs`:
  - Added `WeakMapGetOrInsert` / `WeakMapGetOrInsertComputed` `NativeMethod` variants and registered them on `WeakMap.prototype` with proper `.name`/`.length` (arity 2).
  - **Generalized the existing Map upsert handler** over receiver kind: it derives `(expected_kind, weak)` from the method, admits a Map- or WeakMap-kind receiver, and — for the WeakMap forms — rejects a non-weakly-holdable (primitive) key with a catchable TypeError **before** the callable check or any insert (spec order), mirroring `WeakMap.prototype.set`'s `key.kind != Reference` gate. No key canonicalization (WeakMap keys are objects); insertion charges the same three entry slots `WeakMap.set` does.
- `rust/engine/ironhorse-262/tests/map_methods.rs`: 3 new XS-differential regression tests (presence/descriptors + distinct-from-Map; get-or-insert object-key/present/primitive-throws/wrong-receiver; get-or-insert-computed absence/present/callback-arg/mutation-overwrite/primitive-throws-before-callable/throwing-propagates).

**Verification:**
- `cargo build -p ironhorse-vm` clean; `ironhorse-vm` unit tests 101/101; `ironhorse-262` `map_methods` 8/8, `set_methods` 9/9, `collections` 5/5 — no regressions.
- Against the pinned test262 `be13516fb6` slice via the real XS oracle: `WeakMap/prototype/getOrInsert` **14/17**, `getOrInsertComputed` **17/22**, **zero failures**. Every residual skip is a `symbols-as-weakmap-keys` case the XS 8.3.1 oracle predates (it rejects symbol WeakMap keys) — not a feature defect; unlike the parent's Map residuals, the descriptor/error tests (name, length, not-a-constructor, this-not-object, internal-slot, callbackfn-throws, overwrites-mutation) now all pass (the name/length own-descriptor gap the parent noted was closed by intervening commits).

**Follow-ups:** Symbol WeakMap keys (`symbols-as-weakmap-keys`) remain rejected engine-wide (a pre-existing `WeakMap.set` limitation, out of this job's "weak-key validation only" scope, and unverifiable against the XS 8.3.1 oracle anyway). No new PR — this is an increment on existing draft PR #970.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-ironhorse-js-26-map-methods-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (4 unmetered)
- Input: 105 tokens (4366069 cached reads)
- Output: 31304 tokens
- Cost: $3.9305165000000004 (4 engagement(s) unpriced)
- Wall-clock: 706s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
