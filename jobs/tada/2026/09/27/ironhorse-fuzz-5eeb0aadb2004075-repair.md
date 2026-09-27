## Finding `5eeb0aadb2004075` (`differential_regexp`): the port was already correct, so I only added regression tests

This is another case of an old XS-oracle bug, not a bug in the Ironhorse port. The oracle used to cut the regexp match meter down to 32 bits. I added regression tests that lock the case in and amended the standing PR endojs/endo-but-for-bots#1298. No port code changed.

**Reproduction**
- The input file's sha256 matches the finding (`34f722ff…c673`, 30 bytes).
- The service's prebuilt binary at the fuzzed SHA `38ca1d18` crashes with: `match meter ironhorse=11901468672 pin=3311534080`.
- The difference is exactly 2·2³², which is the 32-bit truncation.
- The generated case is a nested alternation of `.*.*.*`, `\D+` runs and lookarounds, with no flags, against `"11111111"` at offset 0.
- Every path needs a non-digit, so there is no match. V8 agrees (`exec` returns `null`).
- The port runs 181602 steps, and 181602 × 65536 = 11901468672, so its full-width meter is correct.

**The fix**
- The fix is the existing oracle change `c8497fd88`, which widened the meter fields to 64 bits. It is already on the standing branch and on `llm`.
- On the standing branch, `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1` exits 0. I ran it against the full XS oracle, using a temporary link to the warm `c/moddable` checkout, which I removed before committing.

**What changed (commit `1219e436fe` on `ironhorse-fuzz-findings`, pushed first try)**
- **New test in `ironhorse-vm`:** `finding_5eeb0aadb2004075_regexp_meter_overflow.rs`, plus the exact input bytes as `fixtures/finding-5eeb0aadb2004075.input.bin`.
  - It needs no submodule, so CI runs it.
  - It pins the no-match, the captures `[(-1,-1)]` and the full meter value `11_901_468_672`.
  - It passes.
- **New test in `ironhorse-fuzz/src/regexp.rs`:** `finding_5eeb0aadb2004075_regexp_meter_overflow_agrees`.
  - It checks the case against the fixed oracle, expecting `Ok(false)` because both engines agree there is no match.
  - It passes locally; CI does not run this crate.

**Standing PR**
- `ensure-pr.sh --find-only` found #1298 (draft, base `llm-387ea66`). Its head is now `1219e436fe`.
- I posted a comment on #1298 describing this case and its fix: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5854910060

**Follow-ups**
- I did not start a gauntlet. Under the manual-trigger rule it needs an explicit **run the gauntlet #1298**, as with the earlier findings on this PR.
- This class keeps coming back under new finding ids because the service fuzzes the old base SHA `38ca1d18`, which predates `c8497fd88`. Moving the fuzz service to a newer `llm` SHA would stop these duplicate findings.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-5eeb0aadb2004075-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 2 host(s) (6 unmetered)
- Input: 40 tokens (1329667 cached reads)
- Output: 10454 tokens
- Cost: $1.0176214000000001 (6 engagement(s) unpriced)
- Wall-clock: 1177s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
