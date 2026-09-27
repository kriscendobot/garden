The crash reproduced at the fuzzed SHA, and the fix was already on the branch, so I added the regression tests and documented the finding on the standing PR #1298. No engine code changed.

- **Reproduced:** I decoded the input from the journal finding file and its sha256 matched `5ab98e6f…48bf8f9`. At `38ca1d18`, `cargo +nightly-2026-08-15 fuzz run differential_regexp` panicked with `match meter ironhorse=4973199360 pin=678232064`. The two values differ by exactly 2^32. At the current branch head the same input runs clean.
- **Cause:** the XS reference engine's test shim (the oracle) was storing its match meter in 32 bits and wrapping, so the reported divergence was false. This is the same oracle bug as finding `5d122a6fc10babd9`, and commit c8497fd88 already widened those fields. The Rust port was always correct. The input builds a nested `{1,2}`-group pattern with flag `s` against `"aaabaaaa"`, which doesn't match; the port gets the same answer, with 75885 metered steps (4973199360 raw).
- **Regression tests (commit cef749199e on `ironhorse-fuzz-findings`):**
  - `ironhorse-vm/tests/finding_7072dc2d72d9e2fd_regexp_meter_overflow.rs` plus the fixture `finding-7072dc2d72d9e2fd.input.bin`. It replays the exact bytes and pins the non-match, the captures and the full meter value, and it builds without the oracle or submodule.
  - A differential test in `ironhorse-fuzz/src/regexp.rs` that checks the case against the widened oracle.
  - Both pass locally.
- **CI formatting fix:** the branch was failing CI's pinned `cargo +1.88.0 fmt --check` because of the earlier `5eeb0aadb2004075` lock and a peer's `6ca7a76e0bfe3435` lock that landed while I worked. I fixed both (in cef749199e and 1fdd683d75), and the check is now clean at the head.
- **PR:** `ensure-pr.sh --find-only` found the existing open #1298, so nothing new was opened. The write-up is at https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5854991157.
- **Gauntlet:** one was already running on #1298 (panel round 1, `endojs-endo-but-for-bots-pr1298-gauntlet`), so I didn't start a duplicate. Whether it reviews the new head `1fdd683d75` depends on that job; I didn't verify it.

**Follow-up:** `cargo clippy --all-targets` on `ironhorse-fuzz` shows warnings in `lib.rs` and `snapshot.rs`, in code this job didn't touch. CI runs clippy without `--all-targets`, so they probably don't fail CI.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-7072dc2d72d9e2fd-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 9 on 2 host(s) (6 unmetered)
- Input: 56 tokens (2080657 cached reads)
- Output: 13229 tokens
- Cost: $1.3299994000000002 (6 engagement(s) unpriced)
- Wall-clock: 1565s
- Model(s): claude-opus-4-8 ×2, claude-opus-5-5 ×1

<!-- garden-usage-end -->
