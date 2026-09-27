## Completion report: ironhorse-fuzz-05264cccae42245a-repair

Finding 05264cccae42245a was a false alarm from the test harness, not a bug in the Ironhorse port, and it is now fixed. I added regression tests, pushed both to the standing branch, and all of PR #1298's CI checks pass.

**Reproduction.** I rebuilt the 3-byte input from the journal and its sha256 matched `fe91a16f…9f52`. The failure still reproduced at the current branch tip (`d92733049f`), not just at the older fuzzed SHA:
- The generated program is a shift/product expression.
- The failure was `result: oracle="51298827675632340" ironhorse="51298827675632344"`.

**Cause.** Ironhorse and the XS oracle compute the same double, `51298827675632344`; the oracle confirms `<program> === 51298827675632344`.
- XS prints that double as `51298827675632340`. That decimal is exactly halfway between two adjacent doubles, and standard rounding reads it back as `…336`, a different value.
- The spec's rule for printing numbers needs all 17 digits here, so Ironhorse's `51298827675632344` is correct and matches V8.
- The existing comparison re-parsed XS's printed string, landed on the wrong double, and reported a divergence that wasn't there.

**Fix (commit `fdb9fef6e0`).**
- **XS shim:** it now records the exact double of a Number result before converting it to a string, exposed as `OracleOutcome::result_number()`.
- **Comparison:** `results_agree` compares finite Numbers bit-for-bit against that value (with `+0` equal to `-0`) instead of re-parsing XS's text. This is also stricter than before: the old approach could have hidden a real off-by-one-step difference between the engines. Everything that isn't a finite Number is compared as before.

**Regression tests.**
- `rust/engine/ironhorse-vm/tests/finding_05264cccae42245a_tie_dtoa.rs` needs no submodule. It compiles and runs the finding program, asserts the correct result, and checks that XS's printed form reads back as a different double.
- `ironhorse-fuzz` test `finding_05264cccae42245a_tie_dtoa_agrees` replays the exact input bytes through `gen_program` and `differential_check`.
- `comparison.rs` has unit tests for the new rule, including that an off-by-one-step difference is no longer hidden.
- Commit `755a83f319` is formatting only, on the earlier `a7755caa51aa9320` test file, which was failing `cargo fmt --check`.

**Verification.**
- `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1` now exits 0.
- The `ironhorse-fuzz` library tests pass 64/64, including all the earlier number-printing regression tests.
- The `xs-oracle` tests pass, and the new `ironhorse-vm` test passes 2/2.
- Clippy reports only existing `is_multiple_of` warnings, none from this change.

**Branch and PR.** I pushed `d92733049f..755a83f319` to `kriscendobot:ironhorse-fuzz-findings`. `ensure-pr.sh` adopted the standing PR endojs/endo-but-for-bots#1298 (draft) rather than opening a new one. I documented the finding in a PR comment: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5854085667. I waited for CI on the new head, and every check on #1298 passes.

**Gauntlet not started.** The job asked me to run the gauntlet, but under the manual-gauntlet rule only the maintainer starts one ("run the gauntlet #1298"). The earlier finding repairs on this PR didn't start one either, so I left it for the maintainer.

**Follow-ups.**
- Older findings of this kind (from project SHAs before `fdb9fef6e0`) only need a regression test. A new one on a later SHA would be a real value difference between the engines.
- I saved a memory note recording this.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-05264cccae42245a-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 2 host(s) (6 unmetered)
- Input: 96 tokens (4155047 cached reads)
- Output: 28189 tokens
- Cost: $2.2177734000000004 (6 engagement(s) unpriced)
- Wall-clock: 4372s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
