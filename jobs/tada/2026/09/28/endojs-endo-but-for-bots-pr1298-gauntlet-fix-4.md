---
orchestration-failed: true
---
orchestration-failed: true

# Gauntlet fix round 4: endojs/endo-but-for-bots#1298

I applied all three must-fix items and pushed, but CI came back **RED** (`ci-wait-merge` rc 3). One of the two failures is a real bug in this PR that a random property test found. The other looks like a one-off yarn crash.

## Must-fix items applied

1. **Rename `ctor` to `constructor` (stylist).** Pushed as `faa086ab8` with `safe-push-pr-head.sh` (fast-forward from `c9accbf5d`).
   - The file is now `ironhorse-vm/tests/finding_3a6aab9d9d140c2c_regexp_constructor_frame.rs`, and the test is `exact_fuzz_input_regexp_constructor_frame_completes_with_the_pinned_value`.
   - I also renamed the matching `ironhorse-fuzz` test to `finding_3a6aab9d9d140c2c_regexp_constructor_frame_cost_gap_is_advisory` and fixed its `ctor-frame` assertion message.
   - The existing `REGEXP_CTOR_FRAME_METERING` constant is still quoted as-is.
   - The renamed VM test passes locally. The fuzz crate needs the `c/moddable` submodule to build, which this checkout lacks, so CI is the check for that one.
2. **Wrong commits cited in the description (integrator).** I rewrote the PR description (15.6 KB down to 5.2 KB). It now names only commits on the branch: `7564281b3`, `8686311f3`, `8eb8ca1d4`, `4eb8a5f34`, `e86b0df8d`, `a4ea35a8c`, `63a36d937` and `c0c8ea377`. The missing `fdb9fef6e` and the nonexistent commit subject are gone.
3. **Description vs. diff scope (integrator).** The six per-finding sections are replaced by a summary grouped into four classes: regexp match-meter overflow, `.source`/`toString` truncation, surface cost gaps, and Number spelling (dtoa and ties). Each class names its fix commit and lists its IDs compactly. I checked that every listed ID appears on the branch.

I did not do the pruner's summary-fix (trimming the regression-test docstrings) or the should-fix and comment-only items.

## CI: 2 of 34 checks failed at `faa086ab8`. Both passed at `c9accbf5d`.

- **`test-ironhorse-oracle`: a real bug in the PR.** The proptest `decimal_numbers_agree_exactly_when_their_doubles_are_equal` (`ironhorse-fuzz/src/lib.rs:2088`) failed on `bits = 14041238451009349672, ulps = 0`.
  - That double is exactly `-125343939420064.625`, so the 17-digit spellings `…064.62` and `…064.63` are equally close and both round-trip.
  - The oracle side (`ryu`) returns `.62`, which is the even choice ECMA-262 asks for. The IronHorse side (`ironhorse_text::number::std_shortest_digits`, which uses Rust's `{:e}`) returns `.63`. Because the two spell the same double differently, `results_agree` reports a disagreement.
  - So the VM's spelling does not round exact ties to even, the same class as the `d87697d49a5f8f67` even-tie finding. It passed before only because proptest picks random inputs.
  - Suggested fix:
    - Make `std_shortest_digits` (or the VM speller) resolve ties to even, or use `ryu` digits on the VM side as well.
    - Add `cc 41ab67bf1f5200d8d387a7c530f4f25fbf348f85f946f36ff3ba2c764dece405` to `ironhorse-fuzz/proptest-regressions/lib.txt`, or add a literal tie test.
- **`test-thixotrope-ironhorse`: most likely a one-off yarn crash.** Yarn crashed during its resolution step with "The `onCancel` handler was attached after the promise settled." My commit only touches Rust files. A re-run should clear it.

I stopped here as the stage requires. The next round needs to fix the tie spelling and re-run the thixotrope job.

<!-- gauntlet-stage-result: fix=still-pending -->

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1298-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2299870 cached reads)
- Output: 14197 tokens
- Cost: $1.3731699999999998
- Wall-clock: 1941s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
