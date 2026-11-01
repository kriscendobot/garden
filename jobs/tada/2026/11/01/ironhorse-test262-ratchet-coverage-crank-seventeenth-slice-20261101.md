I opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1615 for the seventeenth slice. It turns 6 failing test262 rows into passes.

**Choosing rows:** I ruled out the shards already touched by the open ratchet PRs (#1599–#1614) and the rows peers had already claimed. Of the rest, I dropped the ones that aren't real Ironhorse bugs:
- `Math.random` is left out of Ironhorse on purpose.
- The `over-acceptance` rows are XS oracle bugs, where Ironhorse already follows the spec.
- The Proxy rows depend on #1605.

I announced my picks to the 15th, 16th and 10th slices before starting; the 8th slice's inbox was gone, so that message was dead-lettered. I took the `built-ins/AsyncGeneratorPrototype/return/*-broken-promise*` rows (6). I also announced the `AsyncDisposableStack` `disposeAsync` `explicit-await-for-{null,undefined}` rows (4), then released them and told peers. They need a full async disposal machine that runs across promise ticks, which is the follow-up #1602 already names and too big for one slice.

**The bug:** when an async generator awaits a promise, the spec reads that promise's `constructor` property first. Ironhorse's fast path skipped the read. So `return(p)` fulfilled even when `p.constructor` is a getter that throws, and a `return` that resumes the generator at a `yield` never threw into the body.

**The fix** is in `rust/engine/ironhorse-vm/src/interp/suspend.rs`, in a new function `async_generator_await_route`, and covers async generators only:
- **Unpatched promises:** for an ordinary promise, it keeps the existing fast path. Nothing extra is read and metering is unchanged.
- **Patched promises:** otherwise it does the real read.
  - A throwing getter rejects the request, or throws into the body at the `yield`, as XS does.
  - A different constructor sends the value down the slower general path.
- **Left alone:** async functions and `Array.fromAsync` keep the old behaviour, because XS handles a throw there differently.
- **Known gap:** a program that deletes `Promise.prototype.constructor` still gets the fast path, as before. The PR notes this.

**Expectation files:**
- `AsyncGeneratorPrototype/return`: 6 rows now pass.
- `AsyncFromSyncIteratorPrototype/next/iterator-result-poisoned-wrapper` (2 rows): still failing, but with a new message. The promise now rejects as the test expects, but the sync iterator isn't closed yet, which is #1599's work. If #1599 lands first, that shard needs re-baselining on rebase.

**Checks run:**
- All 106 whole-tree shards for async generators, async functions, `await`, `yield`, async iterators and Promise pass against the updated expectations.
- `cargo test --release` passes for `ironhorse-vm` and `ironhorse-262`.
- New regression tests in `ironhorse-262/tests/async_generators.rs` run each case on both Ironhorse and XS, and the two agree.
- `cargo fmt` is clean and clippy reports nothing new.

The first version broke two `ironhorse-vm` unit tests: it registered a new property key when the program never uses `constructor`. I fixed that before committing.

**Follow-ups:**
- The `disposeAsync` explicit-await rows are still open and need the async disposal machine.
- Async functions still skip the constructor read; no test262 row currently fails because of it.

I also added a note to the crank-coordination memory: `inbox-send.sh` needs the message as a file path, not an inline string, and wants full PR URLs instead of `#NNNN`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-ratchet-coverage-crank-seventeenth-slice-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 206 tokens (14216243 cached reads)
- Output: 48859 tokens
- Cost: $5.432756600000003
- Wall-clock: 2008s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
