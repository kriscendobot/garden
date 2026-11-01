I opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1616, which turns 2 more test262 rows from fail to pass. The rest of my slice was also fixed by the 17th slice, which got its PR (#1615) up first. So #1616 is stacked on #1615 and has to be retargeted to `llm-9a14ddf` once #1615 lands.

**Rows I picked.** I checked peer messages and every open ratchet PR (#1599–#1612), skipped Temporal and every row another slice held, and took:
- the 3 `built-ins/AsyncGeneratorPrototype/return/*broken-promise*` tests (6 rows);
- `language/statements/for-await-of/ticks-with-async-iter-resolved-promise-and-constructor-lookup-two.js` (2 rows).

I announced these to the eighth, tenth and sixteenth slices at 14:01Z.

**The bug.** When `await` gets a native promise, the engine skipped reading the promise's `constructor` property. The spec requires that read: a custom getter must run, and if it throws, the `await` throws. The fast path is in `schedule_native_await` in `ironhorse-vm/src/interp/suspend.rs`.

**The overlap.** The 17th slice started after my announcement, so it never saw it. It fixed the same async-generator rows and opened #1615 at 14:42, minutes before I was ready. Rather than open a conflicting duplicate, I dropped my copy and kept only what #1615 leaves out. My message to the 17th slice bounced because it had already finished.

**What #1616 adds.** #1615 does the `constructor` read only for async generators. #1616 does it for every await, including plain async functions and each `for await` step. That gives the +2 `for-await-of` rows.

#1615's description says it skipped plain async functions because the XS oracle would behave differently there. I tested that against the oracle and it agrees with my change:
- inside a `try`, the error from the getter is caught at the `await`;
- without a `try`, the function's promise rejects with it.

**Verification**
- **test262 whole tree:** all 1549 non-Temporal shards meet their expectations with no drift, on #1615 plus my change (release `endot-ih`, `--case-timeout 60`, test262 `be13516f`).
- **New tests:** `ironhorse-262/tests/await_promise_resolve_constructor.rs` runs each case on Ironhorse and XS. It covers a throwing getter at an async function's `await`, one read per `await`, and one read per `for await` step.
- **Test suites:** `cargo test -p ironhorse-vm --lib` 328 passed, 0 failed; `cargo test -p ironhorse-262` 1412 passed, 0 failed.
- **Formatting:** `cargo fmt --check` is clean.

I also added a note to the crank-coordination memory: an announcement only reaches slices that are already running, so re-check open crank PRs right before opening one.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-ratchet-coverage-crank-fifteenth-slice-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 224 tokens (15862271 cached reads)
- Output: 60737 tokens
- Cost: $6.007842200000001
- Wall-clock: 3634s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
