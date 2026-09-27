# Finding 13b68e2edb67861a (`differential_regexp`): regression tests added to PR #1298, no engine change needed

This was not a bug in the Ironhorse engine. The divergence came from the XS oracle wrapping its match meter to 32 bits at the fuzzed commit `38ca1d18`. Ironhorse's answer was right, and that oracle bug is already fixed on the standing branch and on `llm` by commit `c8497fd8`. I added two regression tests and documented the case on the standing PR, endojs/endo-but-for-bots#1298.

**What the input does**
- **Input check:** I copied the saved 12-byte input into the repo as a fixture; its sha256 matches `e0c61bad…188b`.
- **Case:** it becomes a regex heavy with backreferences and flag `i`, run against `"\n\n\n0 "` starting at position 2.
- **Result:** it matches at (2,5) with all groups unset. Node gives the same result.
- **Why it diverged:** the match takes 91,920,681 metered steps, so the meter reaches 6024113750016, which is more than a 32-bit field can hold. At `38ca1d18` the oracle stored that value as `u32`, which cuts it down to 2569601024. That mismatch was reported as the crash.
- **Pattern:** this is the same kind of false report as the seven earlier findings of this type.

**Checks on the standing branch**
- `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1` exits 0.
- Ironhorse and the fixed oracle agree exactly on whether it matched, all five capture positions, and the full meter value.
- I did not rebuild at `38ca1d18` to watch it fail. Instead I confirmed the cause from the base checkout's oracle source, which has `match_meter_raw: u32`, and the wrapped value is exactly the full meter minus a multiple of 2^32.

**What changed** (commit `bbd65a4055` on `kriscendobot:ironhorse-fuzz-findings`, pushed after rebasing onto the latest remote tip; branch moved 7fe420a0b3 → bbd65a4055)
- **`rust/engine/ironhorse-vm/tests/finding_13b68e2edb67861a_regexp_meter_overflow.rs`:** checks the match, the capture positions and the full meter value. It doesn't need the XS source tree, so it runs in CI. It passes in both release and debug builds and takes 2.5s in debug.
- **`rust/engine/ironhorse-vm/tests/fixtures/finding-13b68e2edb67861a.input.bin`:** the 12-byte input.
- **`ironhorse-fuzz` test `finding_13b68e2edb67861a_regexp_meter_overflow_agrees`:** runs the input through both Ironhorse and the oracle and checks they agree. It passes, but it needs the oracle, so it only runs locally.

**PR:** `ensure-pr.sh` found the existing PR #1298 (draft, base `llm-387ea66`) and created nothing new. I posted a comment there documenting this finding: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5854442891

**Follow-ups**
- I did not start a gauntlet (full review run) on #1298, because a maintainer triggers those.
- The fuzz service still fuzzes `38ca1d18`, which has the old oracle, so it will keep reporting this same false divergence under new finding ids. Moving the fuzzed commit to one after `c8497fd8` would stop them.
- The journal's `standing.md` still says generation 2 / branch `ironhorse-fuzz-findings-2`, but the live PR and branch are generation 1 (`ironhorse-fuzz-findings`, #1298). That mismatch was already known and is still there.
- The project checkout has an uncommitted change to `packages/floot/package.json` that isn't mine; I left it uncommitted.
- I added a line about this finding to the existing memory note on this class of findings.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-13b68e2edb67861a-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 3 host(s) (5 unmetered)
- Input: 44 tokens (1513752 cached reads)
- Output: 12593 tokens
- Cost: $1.1546584000000002 (5 engagement(s) unpriced)
- Wall-clock: 1502s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
