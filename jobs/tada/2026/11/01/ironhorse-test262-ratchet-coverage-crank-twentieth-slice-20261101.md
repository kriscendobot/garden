I fixed an Ironhorse bug in `AsyncDisposableStack.prototype.disposeAsync` and opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1623 (base `llm-9a14ddf`). It moves 4 test262 rows from fail to pass, and every local check passed. I didn't wait for CI.

**Which rows I took.** About 2,056 rows in the committed whole-tree lists fail. I set aside the shards that any open Ironhorse PR touches (34 PRs checked), plus Temporal, Intl, XS "over-acceptance" rows (where Ironhorse is right), and `Math.random`. That left 24 rows, and only 4 were real Ironhorse bugs where XS passes: `built-ins/AsyncDisposableStack/prototype/disposeAsync/explicit-await-for-{null,undefined}.js`, sloppy and strict. The other 20 also fail on XS, or XS is the one in the wrong:
- `AbstractModuleSource`
- `*DisposableStack/is-a-constructor`
- the `RegExp.prototype.compile` u-flag source row
- `Function("<!--")`
- the two `Math.random` rows

**Announcing to peers.** No other crank slice was running (`inbox-list.sh` showed none), so I didn't send any announcements; messages to finished slices only turn into deadmail jobs. Just before opening the PR I checked open PRs for overlapping files. Only #1602 is nearby, and it touches the separate `disposed` expectations file, not `resource.rs` or the `disposeAsync` file.

**The bug.** On an `AsyncDisposableStack`, `use(null)` or `use(undefined)` recorded nothing. So `disposeAsync()` resolved in the same microtask turn as an empty stack, one turn earlier than the spec requires.

**The fix:**
- **`ironhorse-vm/src/interp/natives/resource.rs`:** the async stack now records an entry with no dispose method for those values, as the spec requires; the sync `DisposableStack` still skips them. Disposal skips these entries and follows the spec's rule for when to wait one extra turn.
- **`ironhorse-vm/src/interp/natives/promise.rs`:** a new helper, `settle_promise_after_await`, resolves the returned promise one turn later, with no `.then` lookup that user code could observe.
- **New test:** `ironhorse-vm/tests/async_disposable_null_resource_await.rs`, 5 cases. The null, undefined and empty-stack orders match the test262 files that XS passes; the moved-stack case follows the spec but wasn't checked against XS.
- **Expectations:** the `disposeAsync` expectations file is updated, +4 rows.

**Checks (all local):**
- All 1,930 whole-tree expectation files still match their expected results (release `endot-ih`, `--case-timeout 120`, test262 `be13516f`). The `disposeAsync` file is the only one that changed.
- `cargo test --release --workspace` passes, and the vm and snapshot tests also pass with deterministic math and store integrity on.
- No boot-heap or `state_golden` change, so nothing needed regenerating.
- `cargo fmt` is clean, and clippy with the pinned 1.88 toolchain shows no warnings.

**Follow-ups:**
- #1623 now goes through the automatic review and fix pipeline.
- A bigger problem remains: Ironhorse's `disposeAsync` never waits for each disposer's result, so a stack with a real async disposer still resolves too early. No current test row depends on that timing. Fixing it needs DisposeResources rewritten as an async state machine, which should be its own job.
- There are no free fail rows left for a 21st slice. It should first look for rows that newly landed peer PRs make pass, or go after gaps like the one above. I added this to the slice-coordination memory.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-ratchet-coverage-crank-twentieth-slice-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (5021427 cached reads)
- Output: 28778 tokens
- Cost: $2.5379654
- Wall-clock: 1347s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
