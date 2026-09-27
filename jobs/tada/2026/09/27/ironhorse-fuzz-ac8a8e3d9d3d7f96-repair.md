## Completion report: ironhorse-fuzz-ac8a8e3d9d3d7f96-repair

This finding was a false alarm from the XS test oracle, not a bug in the Ironhorse engine. The fix already existed, so I added only regression tests, pushed them to the standing branch, and documented the case on the standing PR.

**Reproduction**
- I recovered the 11-byte input from the durable artifact on this host and checked that its sha256 is `806a67c0…70f9d18c1f38093`.
- The input generates a 15-group pattern of backreference groups followed by lookbehinds, with flag `m`, matched against `" ccc"` from offset 0. It does not match, but only after 596085 metered backtracking steps, so the match meter is `39065026560`, above `u32::MAX`.
- **At the finding SHA `38ca1d1893`** I built a throwaway checkout against the real XS oracle and got `match meter ironhorse=39065026560 pin=410320896` (410320896 = 39065026560 − 9·2³²). The match result and all captures agreed.
- **Cause:** the XS oracle stored its 64-bit meter in a 32-bit field. This is the same kind of finding as 5d122a6fc10babd9 and 8ea950859db8a5f7. The actual fix is `c8497fd88b` (widening the oracle's meter fields), which the standing branch already has.
- **At the branch head** the oracle returns the full-width meter and agrees with Ironhorse.
- **No engine change:** Ironhorse was always correct, so changing it to match the wrapped oracle value would be wrong.

**What changed** (commit `6673b4f3c9`, pushed to `kriscendobot:ironhorse-fuzz-findings` after fetching and rebasing onto its latest tip):
- `ironhorse-vm/tests/finding_ac8a8e3d9d3d7f96_regexp_meter_overflow.rs` plus the exact input as a fixture. This test builds without the XS oracle or its submodule. It regenerates the case from the exact bytes and pins the pattern, the non-match, the 15 captures and the full-width meter. It also asserts that the meter is not the old 32-bit wrapped value.
- `ironhorse-fuzz/src/regexp.rs`: a new test, `finding_ac8a8e3d9d3d7f96_regexp_meter_overflow_agrees`, which checks that Ironhorse and the widened oracle agree on this case.
- **Test results:** the new vm test and all 44 `finding_` tests in the ironhorse-fuzz lib pass against the real oracle, and pinned `cargo fmt` is clean. I did not run the full `ironhorse-vm` suite.

**Standing PR**
- `ensure-pr.sh` found the existing endojs/endo-but-for-bots#1298 and created no new PR.
- I posted a comment documenting this finding and its solution: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5855228183
- **Gauntlet:** the gauntlet already in progress for #1298 (`endojs-endo-but-for-bots-pr1298-gauntlet`) is at its panel stage, with the clean and viability stages done. I did not post a second one or check that it picked up the new head commit. The PR stays draft.

**Follow-ups:** none for this finding. Ironhorse needs no change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-ac8a8e3d9d3d7f96-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 56 tokens (1769670 cached reads)
- Output: 14676 tokens
- Cost: $1.215822 (2 engagement(s) unpriced)
- Wall-clock: 698s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
