---
orchestration-failed: true
---
orchestration-failed: true

# Gauntlet clean stage: endojs/endo-but-for-bots #1602

**CI is red, so this stage failed.** The coverage pass found nothing to change. The two failing checks come from the base branch, not from this PR.

**Coverage and dead code: clean, nothing pushed.** I reviewed the full diff at head `aa0be39f8`. The PR adds:
- `%IteratorPrototype%[@@dispose]` and `%AsyncIteratorPrototype%[@@asyncDispose]`
- the `DisposableStack` and `AsyncDisposableStack` `disposed` getters

The new `ironhorse-262/tests/resource_disposal_methods.rs` checks each of these against the XS oracle and covers every new branch:
- property descriptors, names and lengths
- a `return` that is missing, null, or not callable
- a `return` getter or call that throws
- the async result for fulfil, reject, and a throwing getter
- a `disposed` getter called on the wrong receiver (`TypeError`)

The only removals are the `KEY_SET_DIFFERENCES` entries in `intrinsic_key_order.rs` that this change makes stale, so no dead code is left behind. I did not run a local Rust build, since there was nothing to change.

**CI: `ci-wait-merge.sh --no-merge` returned 3 (red).** 36 of 38 checks passed; 2 failed:
- **`test-ironhorse-oracle`** fails `corpus_conversion_equivalence::generated_cases_reproduce_corpus_coverage`.
- **`ironhorse-oracle-sanitizers`** fails that test and also `generated_multi_crank::converted_corpus_runs_as_crank_sequences`.
- Both fail on the last digit of two Math results:
  - `Math.asinh(1.7)`: oracle `1.300820426840647`, Ironhorse `1.3008204268406467`
  - `Math.acosh(2.3)`: oracle `1.475044781241425`, Ironhorse `1.4750447812414251`

These failures are not caused by this PR:
- The same two values fail on every sibling ratchet PR on base `llm-9a14ddf` today. I checked the CI runs for promise-finally-any, with-binding-deleted, typedarray-change-by-copy and async-from-sync.
- This is the known Math-result mismatch (stage3-math cases 054/055) that started when CI moved to the Ubuntu 26.04 runner image.
- The fix is draft PR #1585 (still open and unmerged).

The macOS leg (`test (24.x, macos-15)`) first failed in a daemon test, `http-content-plane.test.js`, which this Rust-only PR doesn't touch. I re-ran that job once and it passed.

**Follow-up, parked:** `endojs-endo-but-for-bots-pr1602-weave-after-pr1585` is blocked on https://github.com/endojs/endo-but-for-bots/pull/1585. When #1585 merges, the unblock watcher will promote it. It will then weave #1602 onto a fresh llm snapshot, confirm the two oracle checks go green, and re-run the gauntlet. Until #1585 lands, the gauntlet stays halted.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1602-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1946092 cached reads)
- Output: 8293 tokens
- Cost: $1.1957583999999999
- Wall-clock: 3229s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
