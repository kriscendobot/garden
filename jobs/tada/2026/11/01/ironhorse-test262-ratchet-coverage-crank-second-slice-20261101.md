# Ironhorse test262 ratchet, second slice: AsyncFromSyncIterator (+116 covered, 0 lost)

I opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1599 on the live `llm` base, branch `ironhorse-test262-ratchet-async-from-sync-20261101`, with the `garden-arc: ironhorse-test262-ratchet` marker.

**Choosing the slice.** I did not run a separate whole-tree report. The in-flight first-slice job was already sweeping the same pins (llm 9a14ddf plus its RegExp flag-accessor fix), so I aggregated its results so far. The sweep was about a third done at the time, which covers `annexB/` and `built-ins/` up to `String/`. In that data, the largest supported failure cluster outside the sibling's RegExp work was `for await` / async `yield*` over synchronous iterators. Its root cause was that Ironhorse had no AsyncFromSyncIterator. I can't confirm this is the second-largest slice across the whole corpus, because `language/` hadn't been swept yet. Temporal was excluded.

**The engine fix.**
- **The wrapper.** `for await` with no `@@asyncIterator`, and an async generator's `yield*` over a sync delegate, now wrap the iterator in a real `%AsyncFromSyncIteratorPrototype%` object, translated from XS's code.
  - Before, any sync iterable other than arrays, strings, Map/Set or generators threw `call: not a function`.
  - Before, `for await (x of [Promise.resolve(5)])` gave `x` the unresolved promise instead of 5.
- **Async `yield*`.** It now resolves each step with the delegate's value directly, as XS does, instead of awaiting it. I removed the old stand-in code for the missing wrapper.
- **Snapshots.** The wrapper is a new iterator-table row kind (16), and snapshot save, restore and validation accept it. The two short-lived handler functions only exist between microtasks; a snapshot taken while one is pending is refused (fail-closed) rather than written incorrectly.
- **Pinned artifacts.** The new prototype adds 6 slots to the boot heap, which moves several pinned artifacts. I regenerated them under both math providers:
  - the snapshot golden hashes and fixtures, and the platform boot fingerprint;
  - the fuzz seed corpus.
  
  I also registered the new pieces in the intrinsic key order, the GC visitation registry, the snapshot ledger and the halt-label registry.

**Raising the ratchet floor.** I re-measured the 19 affected `expectations/whole-tree` shards: 230 case/mode rows go from fail to pass, 2 from skip to pass, and 2 still-failing tick-order cases have updated messages. All 320 shards in the affected directories pass their gates. I did not create a `baseline/refresh-*` floor directory: that needs a whole-tree sweep at the merged head, and the maintainer's open floor-resolution question on kriscendobot/garden#51 governs it.

**Coverage**, checked per test across 26 async, generator, iterator, Promise, class and module directories before and after:
- `AsyncFromSyncIteratorPrototype`: 8 → 38 of 38
- `async-generator` expressions: 608 → 622
- `async-generator` statements: 290 → 298
- `class` statements and expressions: +28 each
- object literals: +7
- `for-await-of`: +1

**Tests.** New tests, each confirmed to fail without the change it covers:
- six cases in `ironhorse-262/tests/async_from_sync_iterator.rs` that run both Ironhorse and XS;
- a snapshot test resuming a `for await` loop across a snapshot;
- decoder checks for the new kind-16 rows.

These all passed locally:
- the engine test suites in the store-integrity, deterministic-math and cost-calibration configurations;
- the `ironhorse-262` tests;
- the `try.txt` and `ironhorse.txt` expectation gates;
- `cargo fmt --check`, plus the row-schema and crate-graph checks.

**CI.** `test-ironhorse`, `-release`, `-macos`, `-calibration` and `test-thixotrope-ironhorse` all pass. `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers` fail, but only on `stage3-math/054.js` and `055.js` (`Math.asinh` and `Math.acosh` differ from XS in the last digit on the CI runner). PR #1548 fails both lanes on exactly those two cases, so they predate this PR; I noted that on the PR. The JS test matrix was still pending when I stopped, but this PR changes no JS.

**Follow-ups:**
- The sibling's RegExp PR also probably grows the boot heap. Whichever PR lands second has to regenerate the snapshot golden fixtures, golden hashes and fuzz seeds; I sent the sibling the recipe over the inbox.
- The ratchet autopilot halts when more than one crank PR is open. With two parallel cranks open, it needs the maintainer's handling when the delegation is resumed.
- Still open nearby:
  - XS-specific tick-order differences in a few `for await` / async-generator tests;
  - `%AsyncIteratorPrototype%[@@asyncDispose]`, 9 cases;
  - `DisposableStack`'s `disposed` getter.

I saved the boot-heap regeneration checklist and the pre-existing `stage3-math` CI failure to memory.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-ratchet-coverage-crank-second-slice-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 386 tokens (41030804 cached reads)
- Output: 106084 tokens
- Cost: $12.938168800000001
- Wall-clock: 6403s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
