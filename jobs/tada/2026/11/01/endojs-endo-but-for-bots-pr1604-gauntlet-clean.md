Clean stage on PR #1604: I removed one piece of dead code and pushed it. CI did not finish within the one-hour bound (`ci-wait-merge.sh` returned rc 4), so the result is **still-pending**. Two checks have already failed, so this will become RED (rc 3) once the macOS legs finish unless #1585 lands first. The failure is the base-wide libm drift, not this PR.

**What changed**
- The new brand check limits `%ArrayIteratorPrototype%.next` to array iterators (kinds 0–2), and String Iterators now step through their own `%StringIteratorPrototype%.next`. That left the `kind == 4` String Iterator branch in `array_iterator_next` (`rust/engine/ironhorse-vm/src/interp/natives/array.rs`) unreachable, since dispatch is its only caller. I deleted those 3 lines.
- Pushed with `safe-push-pr-head.sh` (advance mode) as commit `5d9d93ad2e`, on top of `cfed92052a`.

**Local verification**
- `cargo test --release -p ironhorse-vm --lib`: 326 passed, 0 failed.
- `ironhorse-262` tests `string_iterator_prototype`, `xs_departures` and `intrinsic_key_order`, run against the XS oracle: all passed. These include the PR's new dual-run tests, which check that each prototype's `next` rejects the other kind of iterator.
- `cargo fmt --check` passes.
- `cargo clippy -D warnings` reports one error in `base64.rs`, a file this PR doesn't touch. It comes from my local Rust 1.91; CI's lint gate pins 1.88.
- Coverage: the PR's new tests already cover the new `StringIteratorNext` method and the narrower `ArrayIteratorNext` check, so I added no tests.

**CI at the deadline (head `5d9d93ad2e`)**
- Still running: `test (22.x, macos-15)` and `test (24.x, macos-15)`.
- Failed: `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers`. Both fail only on `stage3-math/054.js` and `055.js`: `Math.asinh(1.7)` and `Math.acosh(2.3)` differ from the oracle by 1 ulp. The run before my push failed the same way.
- This isn't caused by this PR. Every `ironhorse-test262-ratchet-*` branch run today fails the same two cases. The open fix is endojs/endo-but-for-bots#1585 ("accept both faithful roundings for stage3-math asinh/acosh (ubuntu-26.04 libm drift)").
- Every other check is green.

**Follow-up:** landing #1585 (or weaving #1604 onto a base that has it) is what turns this PR's CI green. The plan queue already holds weave-after-#1585 jobs for #1347 and #1501. #1604 probably needs the same.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1604-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (2918056 cached reads)
- Output: 10314 tokens
- Cost: $1.4528671999999998
- Wall-clock: 3860s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
