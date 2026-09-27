Finding `1dc231089278c110` (target `differential_regexp`) was not an engine bug, so I made no engine fix. I added regression tests to the standing branch and documented the case on the standing PR, endojs/endo-but-for-bots#1298.

**What the input does**
- The 3-byte input (`68 68 bc`, sha256 matches the finding) generates a deeply nested alternation of `\n*`, `0*` and `0{1,3}`. It has no flags and runs against `"00\n00"` starting at offset 2.
- The correct result is a match of the single `"\n"` at `(2, 3)`. Node/V8 gives the same result.
- Before that match the engine backtracks 83,775 steps, which puts the raw match meter at 5,490,278,400. That is larger than the 32-bit maximum.

**Why it was reported**
- The reference engine the fuzzer compares against is XS, via the `xs-oracle` wrapper. At the fuzzed base (`38ca1d18`), the wrapper stored XS's meter in a 32-bit field. It reported 1,195,311,104 (the value wrapped at 2^32), and the fuzzer read that as a divergence.
- This is the same meter-truncation problem as earlier findings (`5d122a6f…`, `407764ab…`, `8b8afc47…`, `c99f800f…`, `a172d6ab…`, `12aca768…`). The wrapper fix (`c8497fd8`) is already on the standing branch and on `llm`.
- **Not reproduced on the standing branch:** `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1` exits 0. Ironhorse and XS agree exactly on the match, the capture `(2,3)` and the meter. I did not re-run the fuzzed base, which the wrapper fix predates.

**What I committed** (commit `ef5a0ac668` on `ironhorse-fuzz-findings`, which is #1298's head)
- `rust/engine/ironhorse-vm/tests/finding_1dc231089278c110_regexp_meter_overflow.rs`: needs neither the XS wrapper nor the submodule, so it runs in CI. It uses a copy of the generated pattern and pins the match, the capture and the full 64-bit meter. It also asserts the meter is not the wrapped 32-bit value.
- `rust/engine/ironhorse-vm/tests/fixtures/finding-1dc231089278c110.input.bin`: the exact input bytes.
- `ironhorse-fuzz` test `finding_1dc231089278c110_regexp_meter_overflow_agrees`: replays the fixture bytes through the Ironhorse-vs-XS comparison and expects agreement. It needs XS, so it only runs locally.
- Both new tests pass locally.
- A peer had just added a sibling test (`12aca768c2e73c73`) at the same spot in `regexp.rs`. I resolved the rebase conflict by keeping both tests, and the push landed first try (`97ff21c414..ef5a0ac668`).

**PR**
- `ensure-pr.sh` adopted the existing #1298 (draft, base `llm-387ea66`), so no new PR was opened. The comment documenting the finding is https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5854187597.
- I did not stage a gauntlet. Under the manual-gauntlet rules a maintainer starts it with "run the gauntlet #1298", as with the earlier findings.

**Follow-ups:**
- These false findings keep coming because the fuzz service's checkout (`.garden-state/ironhorse-fuzz/project`) is still at `38ca1d18`, which predates the wrapper fix. Moving that checkout to the current `llm` would stop them.
- My inbox check at the start timed out because the journal clone was offline, so I couldn't read any messages.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-1dc231089278c110-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 13 on 2 host(s) (10 unmetered)
- Input: 60 tokens (2177396 cached reads)
- Output: 17626 tokens
- Cost: $1.5258472000000003 (10 engagement(s) unpriced)
- Wall-clock: 1908s
- Model(s): claude-opus-4-8 ×2, claude-opus-5-5 ×1

<!-- garden-usage-end -->
