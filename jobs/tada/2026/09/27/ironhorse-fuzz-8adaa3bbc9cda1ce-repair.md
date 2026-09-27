Finding `8adaa3bbc9cda1ce` is locked with a regression test and documented on the standing PR. No engine fix was needed: the crash was an oracle-comparison artifact that an earlier fix on this branch already handles.

**What I did**
- **Input:** decoded the input from the journal finding into a file and checked it. The sha256 matches `ae3640c0…d0821bd`; it is 3 bytes.
- **Reproduced:** at the fuzzed SHA `38ca1d18` (after setting up the pinned nightly and the `c/moddable` submodule), the target panicked with `result: oracle="2513641910770335700" ironhorse="2513641910770336000"`. At the tip of the standing branch the same input runs cleanly.
- **Cause:** the program works out to the double `2513641910770335744`. XS's `fx_dtoa` prints it in a longer form than the shortest one; Ironhorse prints the shortest form that round-trips, as ECMA-262 requires. Both strings parse to the same IEEE-754 double, so Ironhorse was always correct. This is the known large-integer number-printing class. The fix, fdb9fef6e0 (compare Number results by the oracle's exact double), was already on the branch, so I made no source change.
- **Regression tests,** commit `a0b1f49d50`, pushed to `kriscendobot:ironhorse-fuzz-findings` with a fetch/rebase/push loop:
  - `rust/engine/ironhorse-vm/tests/finding_8adaa3bbc9cda1ce_large_integer_dtoa.rs` plus the exact input bytes in `tests/fixtures/`. It builds without the submodule, replays the bytes through the pinned grammar, checks the program completes with the shortest result, and checks that both spellings are the same double.
  - `ironhorse-fuzz` test `finding_8adaa3bbc9cda1ce_large_integer_dtoa_agrees`, which checks agreement against the real XS oracle.
  - Both tests pass locally and `cargo fmt --check` is clean.
- **PR:** `ensure-pr.sh --find-only` found the standing PR, endojs/endo-but-for-bots#1298, which is still a draft. Its head is now `a0b1f49d50`. I posted the case and its explanation as a PR comment: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5855111542
- **Gauntlet:** one is already running on #1298 (`endojs-endo-but-for-bots-pr1298-gauntlet`, at the panel stage), and it will pick up the new head. I did not post a duplicate.

**Follow-ups:** none required. The project worktree still has changes left by the node_modules cache prefill (`packages/floot/package.json` and untracked compartment-mapper fixtures); they are unrelated and were not committed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-8adaa3bbc9cda1ce-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 2 host(s) (4 unmetered)
- Input: 46 tokens (1556896 cached reads)
- Output: 10534 tokens
- Cost: $1.1281392 (4 engagement(s) unpriced)
- Wall-clock: 1219s
- Model(s): claude-opus-4-8 ×1, claude-opus-5-5 ×1

<!-- garden-usage-end -->
