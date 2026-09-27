- Reproduced finding `cfdc1a28296f23a1` at the recorded SHA: the XS oracle truncated `10,809,376,768` to `2,219,442,176`. The existing causal fix `c8497fd88b` correctly widens the oracle meter; the Ironhorse port was already correct.
- Added exact binary/pattern fixtures plus submodule-free VM and differential regression tests in commit `6edbe4228f`; pushed to `ironhorse-fuzz-findings` and confirmed it remains in PR #1298’s live history.
- Proved the regression load-bearing by restoring the 32-bit truncation and observing the original divergence, then reverting and passing both targeted tests, the pinned fuzz replay, rustfmt, and all eight pre-push probes.
- Documented the finding and verification in PR comment https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5855953649.
- Current successor-head CI has 22 successful checks and no failures, including format, oracle, sanitizer, release, macOS, calibration, and XS checks; four longer jobs remain pending. The standing gauntlet previously halted at panel round 2 after its stage exhausted retries, so another review round remains follow-up.
- Broader local verification only found pre-existing host/environment failures, including the known `math_determinism` host-libm mismatch. Unrelated warm-cache changes were preserved and excluded.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-cfdc1a28296f23a1-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (4 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (4 engagement(s) unpriced)
- Wall-clock: 3451s

<!-- garden-usage-end -->
