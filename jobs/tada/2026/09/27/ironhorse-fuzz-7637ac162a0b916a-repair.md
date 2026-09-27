Finding `7637ac162a0b916a` is a false alarm from the test harness, not an Ironhorse engine bug. It's already fixed on the standing branch, and I've added regression tests and documented it on the standing PR, endojs/endo-but-for-bots#1298.

**Where it stood:** the earlier attempt left no commits, PR comment or journal record for this finding, so I started over.

**Reproduction:** the input matched its expected sha256. I ran `cargo +nightly-2026-08-15 fuzz run differential_regexp` at the recorded SHA `38ca1d1893` and it failed with `match meter ironhorse=490355884032 pin=729612288`.
- The 6-byte input becomes a 29-group backreference-heavy pattern (flag `i`, subject `"b"` from offset 0). It fails to match only after 7,482,237 metered steps, so the full meter value is larger than a 32-bit field can hold.
- The XS reference engine used for comparison (the "oracle") stored its 64-bit meter in a 32-bit field. That wrapped the value: 729612288 = 490355884032 − 114·2³².
- This is the same kind of harness defect as earlier findings `5d122a6fc10babd9` and `ac8a8e3d9d3d7f96`. The real fix is commit c8497fd88b, which widened the oracle's field and is already on the standing branch. Ironhorse itself was always correct, so I changed no engine code.

**Changes, in commit `a498407bfe` on `kriscendobot:ironhorse-fuzz-findings`:**
- `rust/engine/ironhorse-vm/tests/fixtures/finding-7637ac162a0b916a.input.bin`: the exact input bytes.
- `rust/engine/ironhorse-vm/tests/finding_7637ac162a0b916a_regexp_meter_overflow.rs`: a regression test that builds without the XS oracle or its `c/moddable` submodule. It rebuilds the case from the saved bytes and checks the pattern, the non-match, the 29 capture slots and the full meter value. It also checks that the meter is not the wrapped 32-bit value.
- `rust/engine/ironhorse-fuzz/src/regexp.rs`: a new test, `finding_7637ac162a0b916a_regexp_meter_overflow_agrees`, which checks that Ironhorse and the widened oracle now agree.
- Both tests pass locally, and so do the other 14 regexp finding tests. rustfmt is clean.

**Pull request and gauntlet:**
- I pushed with a fetch/rebase/push loop. `ensure-pr.sh --find-only` found the existing standing PR, #1298, so no duplicate was opened.
- I posted the write-up for this finding as a comment on the PR: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5855264358
- #1298's gauntlet (`endojs-endo-but-for-bots-pr1298-gauntlet`) is already running, now in its panel stage, so I didn't post another. The PR stays draft.

**Follow-ups:**
- The journal file `ironhorse-fuzz/standing.md` says generation 2 on branch `ironhorse-fuzz-findings-2`. That branch doesn't exist; the open standing PR is #1298 on `ironhorse-fuzz-findings`, which is where this job told me to push. Someone should reconcile that journal file.
- The project checkout has an unrelated, uncommitted change to `packages/floot/package.json` (an escaped character written out as `—`). It predates my work, and I left it alone.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-7637ac162a0b916a-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 13 on 3 host(s) (9 unmetered)
- Input: 54 tokens (1712777 cached reads)
- Output: 13262 tokens
- Cost: $1.1915073999999999 (9 engagement(s) unpriced)
- Wall-clock: 1652s
- Model(s): claude-opus-4-8 ×2, claude-opus-5-5 ×2

<!-- garden-usage-end -->
