## Completion report: ironhorse-fuzz-79f0475dd0440b2d-repair

**Verdict:** this finding was a false alarm caused by the XS comparison engine, not a bug in the Ironhorse port. The engine fix was already on the branch, so this job adds the regression tests and records the finding on the standing PR.

**What happened**
- I rebuilt the 3-byte input from the journal finding's `input_base64`, and its sha256 matches (`df0ec7eb…f609b67`). I set up the fuzz environment: `c/moddable` from a peer worktree, `nightly-2026-08-15`, and cargo-fuzz.
- At the current branch head, `cargo fuzz run differential_regexp <input> -- -runs=1` completes without a divergence. I did not rebuild at the recorded SHA `38ca1d18`. What happened there is worked out from its source, as the earlier sibling locks did:
  - The input becomes a 20-group regexp built from backreferences, run with flag `m` on `" \n\n \n"` starting at offset 1. The port and XS agree: both match `[3, 4)` with the same 21 captures.
  - The match takes 464,407,076 metered steps, so the raw match meter is `30435382132736`, which is larger than `u32::MAX`.
  - At `38ca1d18`, XS's reporting code stored that meter in a 32-bit field (`txU4 match_meter_raw`), so XS reported `1243873280`. That mismatch is what the fuzzer flagged.
  - The fix is already on the branch: c8497fd88b widened that field to 64 bits (finding `5d122a6fc10babd9`). No engine change is needed.

**Changes: commit `976d4e005a` on `kriscendobot:ironhorse-fuzz-findings`, pushed after fetch and rebase**
- `rust/engine/ironhorse-vm/tests/finding_79f0475dd0440b2d_regexp_meter_overflow.rs` and `tests/fixtures/finding-79f0475dd0440b2d.input.bin`: a regression test that builds without the XS submodule. It replays the exact bytes and pins the match, all 21 captures, and the full 64-bit meter, including a check that the meter doesn't wrap to the 32-bit value.
- `rust/engine/ironhorse-fuzz/src/regexp.rs`: a test `finding_79f0475dd0440b2d_regexp_meter_overflow_agrees` that checks both engines agree (`differential_check_regexp` returns `Ok(true)`).
- A peer's lock for finding `822848c732a1b805` landed at the same spot in `regexp.rs` during my rebase. I resolved the conflict by keeping both tests.
- rustfmt check is clean. The new `ironhorse-vm` test passes, and all 40 `finding_` tests in `ironhorse-fuzz` pass.

**Standing PR:** `ensure-pr.sh --find-only` found the existing PR, endojs/endo-but-for-bots#1298. I posted the case and its explanation there as https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5855070579. The PR stays a draft, and I did not start a gauntlet: under the manual-gauntlet rule a maintainer triggers it with "run the gauntlet #1298".

**Follow-ups**
- None needed for this finding. It belongs to the same group as the other meter-overflow findings already locked on this branch.
- Findings from `38ca1d18` that show a meter difference that is an exact multiple of 2^32 could be classified automatically rather than each one getting its own repair job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-79f0475dd0440b2d-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (4 unmetered)
- Input: 62 tokens (2125994 cached reads)
- Output: 14922 tokens
- Cost: $1.3693347999999999 (4 engagement(s) unpriced)
- Wall-clock: 1014s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
