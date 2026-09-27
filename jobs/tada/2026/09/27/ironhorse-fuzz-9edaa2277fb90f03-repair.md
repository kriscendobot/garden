Finding 9edaa2277fb90f03 is reproduced, classified, locked with a regression test, and pushed to the standing PR, endojs/endo-but-for-bots#1298. The engine port needed no new fix, because this is another case of a comparison problem that fdb9fef6e0 already fixed on the branch.

**Where things stood:** the previous attempt had committed nothing for this finding. The branch `ironhorse-fuzz-findings` had no commit for it and PR #1298 had no comment about it, so I started over.

**Reproduction:**
- I decoded the input from the journal finding, and its sha256 matches `3add4181…4891d2`.
- At the fuzzed SHA `38ca1d18`, `cargo +nightly-2026-08-15 fuzz run differential_source … -runs=1` crashes with `result: oracle="55169095435288576" ironhorse="55169095435288580"`.
- At the branch tip the same run completes cleanly.

**Cause:** the input generates a program whose value is 234881024², an exactly representable number. The XS oracle prints it as `55169095435288576`, while ironhorse prints the shortest spelling the JavaScript spec requires, `55169095435288580`. Both strings are the same number, so ironhorse was correct. The fuzz harness now compares numbers by value rather than by their printed text (fdb9fef6e0), which is why the tip no longer crashes.

**Changes (commit 29ec1a9e67, pushed to `kriscendobot:ironhorse-fuzz-findings` with a fetch/rebase/push loop):**
- `rust/engine/ironhorse-vm/tests/finding_9edaa2277fb90f03_large_integer_dtoa.rs` plus the fixture `fixtures/finding-9edaa2277fb90f03-input.bin`. This test doesn't need the `c/moddable` submodule. It replays the exact bytes, compiles and runs the program, and checks the result is `55169095435288580` and that both spellings are the same number. It passes.
- `rust/engine/ironhorse-fuzz/src/lib.rs`: a new test, `finding_9edaa2277fb90f03_large_integer_dtoa_agrees`, runs the same input against the real XS oracle. It passes, and rustfmt is clean.

**PR:** `ensure-pr.sh --find-only` found PR #1298, so nothing new was opened. I added a comment documenting this finding: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5855167251. The PR's required gauntlet, `endojs-endo-but-for-bots-pr1298-gauntlet`, was already running when I pushed: its clean and viability steps are done and the panel was in progress. I didn't start a second one, and I haven't checked that it will pick up the new head. PR #1298 stays draft.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-9edaa2277fb90f03-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (3 unmetered)
- Input: 42 tokens (1415203 cached reads)
- Output: 10096 tokens
- Cost: $1.0596326 (3 engagement(s) unpriced)
- Wall-clock: 593s
- Model(s): claude-opus-4-8 ×1, claude-opus-5-5 ×1

<!-- garden-usage-end -->
