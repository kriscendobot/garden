Finding `bf6cfbd74a7487fc` (`differential_regexp`) is a false alarm from the XS comparison oracle, not a bug in the Ironhorse port. The port is correct and needed no change, so the job's deliverable is the regression lock plus documentation on standing PR endojs/endo-but-for-bots#1298.

**Reproduction**
- The input file's sha256 matches `7438aae1…030b6` (6 bytes, `G+8h88`).
- Rebuilt at `38ca1d1893` (the SHA the finding was recorded against), `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1` panics with `match meter ironhorse=1457446060032 pin=1452146688`.
- At the tip of the standing branch `ironhorse-fuzz-findings`, the same run exits 0.

**Cause**
- The bytes generate an 822-byte nested pattern with the `m` flag, run over the subject `"\n"` at offset 0.
- The port's match meter is 22,238,862 steps × 65536 = 1,457,446,060,032, which is past `u32::MAX`. The pin value is exactly that number mod 2^32.
- At `38ca1d1893` the oracle stored the XS meter in a 32-bit field, so it wrapped. This is the same class as `f83dc8932cd3b41a`, `5565a021a8cc30bc` and `12aca768c2e73c73`.
- The oracle fix that widens that field to 64 bits (`c8497fd88`) is already on the standing branch, so no code fix was needed.

**What changed** (commit `76502b5911`, pushed to `kriscendobot:ironhorse-fuzz-findings` after rebasing onto a peer's newer commit)
- **Test fixtures:** `ironhorse-vm/tests/fixtures/finding-bf6cfbd74a7487fc.input.bin` holds the exact bytes, and `.pattern.txt` holds the pattern they generate.
- **`ironhorse-vm/tests/finding_bf6cfbd74a7487fc_regexp_meter_overflow.rs`:** a test that needs no oracle or submodule. It pins the full meter value 1,457,446,060,032 and asserts it is not the wrapped figure. It passes in release and in debug (1.4s).
- **`ironhorse-fuzz/src/regexp.rs`, test `finding_bf6cfbd74a7487fc_regexp_meter_overflow_agrees`:** asserts the bytes still generate that pattern, flags, subject and offset, pins the same meter, and checks that the XS pin now agrees. It passes.
- rustfmt is clean on the edited files. I did not re-run either test after the rebase, which only brought in a peer's separate finding test.

**Standing PR**
- `ensure-pr.sh` adopted the existing PR #1298 and created nothing new.
- I posted a comment there documenting this finding and why no fix was needed: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5855560431
- The PR's gauntlet (`endojs-endo-but-for-bots-pr1298-gauntlet`) is already running at the fix stage, so I did not post a duplicate. Its next panel pass should review this commit.

**Follow-ups:** none required. My last inbox check could not run because the inbox journal clone failed with a network disconnect, so any message sent to this job during the run went unread.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-bf6cfbd74a7487fc-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (2 unmetered)
- Input: 66 tokens (2202905 cached reads)
- Output: 14536 tokens
- Cost: $1.341037 (2 engagement(s) unpriced)
- Wall-clock: 711s
- Model(s): claude-opus-4-8 ×1, claude-opus-5-5 ×1

<!-- garden-usage-end -->
