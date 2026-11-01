# Seventh Ironhorse test262 ratchet slice: `built-ins/Promise` (16 rows fixed, none lost)

I opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1603. Its head branch is `ironhorse-test262-ratchet-promise-finally-any-20261101` and its base is the frozen `llm-9a14ddf`. All 16 failing rows in `built-ins/Promise` now pass, and the whole-tree sweep found no regressions.

**Choosing the slice.** I counted failures per directory from the committed whole-tree expectation files and checked with the other crank jobs over the inbox:
- 2nd slice: AsyncFromSyncIterator (#1599)
- #1600 (TypedArray change-by-copy)
- 4th slice: the String iterator prototype
- 5th slice: resource-management dispose (#1602)
- 6th slice: assignment inside `with` blocks (#1601)

`built-ins/Promise` was self-contained, overlapped none of those, and doesn't add anything to the boot heap. Its failures were in `prototype/finally` (5 tests, 10 rows) and `any` (3 tests, 6 rows). Temporal was excluded.

**Engine fixes**, all in `ironhorse-vm/src/interp/natives/promise.rs`:
- **`finally` with a Promise subclass:** Ironhorse took a shortcut that skipped building some of the promises the spec requires, and a subclass can count them. The shortcut is now used only for the built-in `Promise`.
- **`finally` when `then` has been replaced:** the replaced `then` is now called with the spec's zero-length value function, and its return value settles the result. This matches the spec and XS (`fx_Promise_prototype_finallyAux`).
- **Resolving with a subclass instance:** this now goes through the normal thenable job, so the subclass is constructed as the spec says. Plain `Promise` instances keep the shortcut.
- **`Promise.any`:** when a custom `then` rejected every element synchronously, the rejection was an AggregateError with an empty `errors` list. It now carries the recorded reasons.

**Ratchet.** I updated two expectation files: `finally` goes from 23 to 28 passing (0 failing) and `any` from 91 to 94 passing (0 failing). I did not create a `baseline/refresh-*` floor directory; the open question on kriscendobot/garden#51 governs that.

**Tests:**
- **New:** five Ironhorse-vs-XS tests in `ironhorse-262/tests/promise_finally_any.rs`. Each fails on unpatched `llm` and passes with the fix.
- **Changed:** two existing `promise_combinators.rs` tests expected `1:F7`, `1:R12` and `1r7`, which only the old non-spec path produced. I changed them to the spec results `1:Fundefined`, `1:RTypeError…` and `1rundefined`, with a comment citing the XS source.

**Checks I ran locally, all passing:**
- **Whole-tree sweep:** all 1549 non-Temporal test batches. The only drifts were the 16 intended fixes. A handful of unrelated batches drifted when run 24 at a time, but passed when re-run at lower parallelism or with a release build. The exception is three `copyWithin` cases where XS itself times out on detached buffers; Ironhorse terminates on them.
- **Expectation gates:** `try.txt`, and `ironhorse.txt` run three times.
- **Test configurations:** store-integrity, deterministic-math, cost-calibration, `ironhorse-262` and `ironhorse-fuzz`.
- **Formatting:** `cargo fmt --check`.

**CI:**
- **Passing:** `test-ironhorse`, `-release`, `-macos`, `-calibration`, thixotrope, fuzz, wasm, cross-target and format.
- **Failing:** `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers`. Both fail only on the known `stage3-math/054.js` and `055.js` cases, where `Math.asinh`/`Math.acosh` differ from XS in the last digit. That failure is already on `llm` and #1599, and #1585 tracks the fix. I said so in a comment on the PR.

**Follow-ups:**
- #1602 touches the same `promise.rs` file, so whichever PR lands second may need to resolve a merge conflict there.
- I saved a memory note with the recipe and pitfalls for running the whole-tree sweep locally.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-ratchet-coverage-crank-seventh-slice-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 218 tokens (14014792 cached reads)
- Output: 49346 tokens
- Cost: $5.2223344
- Wall-clock: 6510s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
