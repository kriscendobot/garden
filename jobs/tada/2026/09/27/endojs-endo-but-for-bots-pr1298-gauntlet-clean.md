# Gauntlet CLEAN stage for endojs/endo-but-for-bots#1298: done, no changes needed, CI green

The coverage pass found no gaps and no dead code, so I pushed nothing. CI passed at the current head `62e498121`: 34 checks, 0 failed.

- **PR:** draft, open, head `kriscendobot:ironhorse-fuzz-findings`, base `llm-387ea66`. When I started, CI at this head was still pending, so the stage was not a no-op.
- **Checkout:** isolated worktree from `ensure-project-worktree.sh`.
- **Coverage.** Most of the PR is fuzz-finding regression-lock tests and fixtures. The non-test changes are all covered by tests:
  - **`comparison.rs`:** `results_agree`/`compare_observations` now take the oracle's exact double. The new test `oracle_double_overrides_a_non_round_tripping_spelling` covers each new branch: finite-number override, one-ulp divergence, ±0, number vs non-number, and the non-finite fallback to string compare. Existing tests use `None` for the old path.
  - **XS oracle:** `endor_capture_number` in `xs_shim.c` and `result_number_bits`/`result_number()` in xs-oracle's `lib.rs` are exercised by `finding_05264cccae42245a_tie_dtoa_agrees` (Number kind) and the existing sweep over generated programs.
  - **Callers in `ironhorse-fuzz/src/lib.rs`:** the three call sites were updated.
- **Dead code:** the change removes nothing and orphans nothing. The only new helper, `results_agree_str`, is test-only and used.
- **Tests:** I did not run them locally, because building the XS oracle is heavy. I relied on CI: the ironhorse test jobs are part of the 34 checks that passed.
- **CI wait:** `ci-wait-merge.sh --no-merge` with a 3600s deadline returned rc=0 after about 2750s.

No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1298-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (633013 cached reads)
- Output: 3760 tokens
- Cost: $0.6854186000000001
- Wall-clock: 2872s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
