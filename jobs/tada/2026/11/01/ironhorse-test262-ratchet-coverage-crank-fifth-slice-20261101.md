# Ironhorse test262 ratchet, fifth slice: explicit resource management (+46 rows, 0 lost)

I opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1602. The branch is `ironhorse-test262-ratchet-resource-disposal-20261101` on the frozen base `llm-9a14ddf`, which is the current `llm` tip. The PR carries the `garden-arc: ironhorse-test262-ratchet` marker. CI passes except two oracle lanes, which fail only on a known pre-existing problem (details under **CI**).

**Choosing the slice.** I counted failures straight from the committed whole-tree shards, so I didn't need a new sweep. I skipped Temporal, RegExp (slice 1), AsyncFromSyncIterator and the class async-generator cases (slice 2, #1599), and TypedArray change-by-copy (a sibling's branch, #1600). That left explicit resource management as the next coherent slice. I asked the siblings over the inbox which directories they had and announced mine.

**The engine fix.** Four built-ins that XS has were missing from Ironhorse:
- `Iterator.prototype[Symbol.dispose]`
- `[Symbol.asyncDispose]` on the async iterator prototype
- `DisposableStack.prototype.disposed`
- `AsyncDisposableStack.prototype.disposed`

I followed XS's own code (`xsGenerator.c`) rather than the spec text, because XS behaves differently in ways test262 doesn't check:
- **`[Symbol.dispose]`** swallows every exception: a throwing getter, a non-callable `return`, or a throwing `return`. It always returns `undefined`.
- **`[Symbol.asyncDispose]`** returns the promise that `return()` resolves to, so it fulfills with `return`'s value rather than `undefined`. It calls a `null` `return` (which then rejects) instead of skipping it.

The two `disposed` getters are real accessor properties and reject receivers that aren't stacks with a `TypeError`.

**Pinned artifacts.** The four new functions add 6 slots to the boot heap, so I regenerated these under both math providers:
- the snapshot golden fixtures and the platform boot fingerprint;
- the metamorphic hashes, with the epoch-3 geometry going 1100 → 1106;
- the fuzz seed corpus.

I also registered the new pieces in the GC visitation registry, the snapshot ledger and the boot field list, and removed four entries from the "differs from XS" table in `intrinsic_key_order.rs`. Key order now matches XS for these prototypes.

**Raising the ratchet floor.** I re-measured the 104 whole-tree shards covering the 13 related directories. 46 case/mode rows go from fail to pass, none regress, and no other diagnostic changes; 4 shards change. A second sweep after the final code reproduced the committed shards exactly. Rows passing, before → after:

| Directory | Before | After |
| --- | ---: | ---: |
| `Iterator/prototype/Symbol.dispose` | 0 / 12 | 12 / 12 |
| `AsyncIteratorPrototype/Symbol.asyncDispose` | 0 / 18 | 18 / 18 |
| `DisposableStack` | 172 / 186 | 180 / 186 |
| `AsyncDisposableStack` | 188 / 208 | 196 / 208 |

As #1599 did, I didn't create a `baseline/refresh-*` floor directory: that needs a whole-tree sweep at the merged head, and depends on the maintainer's open question on kriscendobot/garden#51.

**Tests.** I added five cases in `ironhorse-262/tests/resource_disposal_methods.rs` that run both Ironhorse and XS. The `asyncDispose` settlement-order case is checked against Ironhorse only, because the test harness doesn't return the oracle's async result. I didn't separately confirm the new tests fail on the old code; they test methods that didn't exist before.

These passed locally:
- `ironhorse-vm` and `ironhorse-snapshot`: 2077 tests by default and 2078 with deterministic math, none failing;
- the other engine crates: 428 tests;
- `ironhorse-262`: everything, once the key-order table was updated;
- the `try.txt` gate (99 covered) and the `ironhorse.txt` gate (1712 covered);
- `cargo fmt --check`, the row-schema check and the crate-graph check.

**CI.** These ironhorse lanes pass: `test-ironhorse`, `-release`, `-macos`, `-calibration`, `test-thixotrope-ironhorse`, `fuzz`, `format`, `wasm` and `cross-target`. `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers` fail, but only on `stage3-math/054.js` and `055.js` (`Math.asinh` and `Math.acosh` off by one last digit on the runner). #1599 fails both lanes the same way and #1585 carries the fix; I noted this on the PR. The JS test matrix was still pending when I stopped; this PR changes no JS.

**Follow-ups:**
- **Snapshot regeneration on merge.** #1599 also grows the boot heap, and by coincidence also moves the geometry 1100 → 1106. Whichever lands second has to regenerate the golden fixtures, metamorphic hashes and fuzz seeds, and its geometry becomes 1112. The fourth-slice crank (+2 slots) will need the same regeneration when it lands. The TypedArray PR edits the same key-order table, which should merge with a trivial fix.
- **Duplicate work averted.** The sixth-slice crank had announced it would take this same slice; I told it the work is done in #1602 and pointed it at the leftovers. The seventh slice (Promise) and the fourth slice (string iterators) don't overlap with this one.
- **Still failing in these directories:**
  - `disposeAsync` `explicit-await-for-{null,undefined}`: `disposeAsync` settles synchronously today, and fixing it needs a native async disposal state machine.
  - `is-a-constructor.js` for both stacks: XS itself errors on it, so it's XS-side.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-ratchet-coverage-crank-fifth-slice-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 326 tokens (27935869 cached reads)
- Output: 75317 tokens
- Cost: $9.049025799999997
- Wall-clock: 5525s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
