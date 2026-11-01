---
orchestration-failed: true
---
CI came back **red** (exit code 3), so the clean stage fails, as the job's rules require. All three failing checks look like known failures that this PR didn't cause.

**What I did:**
- **Coverage pass:** PR #1615 changes `rust/engine/ironhorse-vm/src/interp/suspend.rs`: the new `async_generator_await_route` reads the awaited promise's `constructor` in async generators. The PR's tests covered the throwing getter on `return`, a non-`%Promise%` constructor, and the untouched fast path. Two routes had no test, so I added two to `rust/engine/ironhorse-262/tests/async_generators.rs`:
  - `yield p` with a throwing `constructor` getter: the error is thrown into the body at the `yield`.
  - A getter that returns `Promise`: it is read exactly once and the fast path still applies.
- **Local check:** `cargo test --release --test async_generators` passed 13/13, with both engines run and agreeing with the XS oracle. `rustfmt --check` is clean.
- **Dead code:** none. The change only adds code.
- **Push:** commit `d3ca42ea26` went to the PR head through `safe-push-pr-head.sh`, a fast-forward from `e3235884`.

**CI result at `d3ca42ea26`:** 35 of 38 checks passed; 3 failed.
- **`test-ironhorse-oracle` and `ironhorse-oracle-sanitizers`:** `corpus_conversion_equivalence::generated_cases_reproduce_corpus_coverage` fails on `test262/test/ironhorse/built-ins/stage3-math/054.js` and `055.js`. The sanitizers job also failed `generated_multi_crank::converted_corpus_runs_as_crank_sequences`. I didn't pull its failing case, but it is probably the same corpus. Memory records 054/055 as a known red caused by the ubuntu-26.04 glibc runner, fixed by #1613, which is still open and unmerged. `test-ironhorse-oracle` had also failed on the PR's original head `e3235884`, before my commit.
- **`test (22.x, ubuntu-latest)`:** `bwrap › bwrap timeout and repeated cancellation reap process groups`. Memory records the bwrap reds as a known runner problem, with the fix in #1566, also still open.

**Follow-ups:**
- Merge #1613 (moves the XS oracle lanes to Ubuntu 24.04) and #1566 (makes the bwrap tests portable), then re-run CI on #1615.
- An alternative is to weave #1615 onto a base that already includes those fixes.
- Nothing in the PR's own change needs fixing.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1615-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1564362 cached reads)
- Output: 7589 tokens
- Cost: $1.0151004
- Wall-clock: 3738s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
