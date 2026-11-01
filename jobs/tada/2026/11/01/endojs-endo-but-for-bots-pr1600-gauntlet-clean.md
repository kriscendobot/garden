---
orchestration-failed: true
---
orchestration-failed: true

# PR #1600 gauntlet, clean stage: CI is red (2 failures, both pre-existing and not caused by this PR)

`ci-wait-merge.sh` returned **rc 3 (RED)** at head `a3482481fc`. 36 of 38 checks passed or were skipped. Two failed:

- `test-ironhorse-oracle`: `corpus_conversion_equivalence::generated_cases_reproduce_corpus_coverage` failed.
- `ironhorse-oracle-sanitizers`: the same test failed, plus `generated_multi_crank::converted_corpus_runs_as_crank_sequences`.

Both failures are only on `packages/test262-runner/test262/test/ironhorse/built-ins/stage3-math/054.js` and `055.js`. Ironhorse and the XS oracle disagree by one ulp on `Math.asinh(1.7)` and `Math.acosh(2.3)` (for example, oracle `1.300820426840647` vs ironhorse `1.3008204268406467`). This is libm drift on the CI runner, and this PR doesn't touch Math. The same two checks fail on #1599, #1548 and #1598, on both `llm` and the `llm-9a14ddf` base. These two checks will block every ironhorse PR's gauntlet until the stage3-math fix lands on the base or the two cases are re-pinned. The PR itself needs no change.

## Coverage pass
- The PR adds `%TypedArray%.prototype.toReversed`, `toSorted` and `with` (`ironhorse-vm/src/interp/natives/buffer.rs` +143, plus wiring in `boot.rs`, `native_ids.rs` and `dispatch.rs`). It adds code only, so nothing was left orphaned and there is no dead code to remove.
- The new `ironhorse-262/tests/typed_array_change_by_copy.rs` reaches every branch of the new code:
  - **toReversed:** reverses into a new copy, ignores `constructor`, handles an empty array, and preserves -0.
  - **toSorted:** sorts with and without a comparator, rejects a non-callable comparator, and rejects a receiver that isn't a typed array.
  - **with:** index checks (negative, out of range, Infinity), the order the index and value are coerced, the source shrinking or growing during coercion, and a BigInt array rejecting a removed element.
- In the sanitizer CI run, all 4 new tests pass, and so do `intrinsic_key_order` and `xs_departures`. The only failures in that run are the two stage3-math ones.
- **No follow-ups pushed.** Nothing needed changing.

## Follow-up
The maintainer or driver should decide whether to accept the known stage3-math red for this gauntlet or wait for the base to be fixed.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1600-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1234483 cached reads)
- Output: 6088 tokens
- Cost: $0.9205446
- Wall-clock: 97s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
