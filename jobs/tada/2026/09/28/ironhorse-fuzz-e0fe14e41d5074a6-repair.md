Finding `e0fe14e41d5074a6` is fixed and regression-locked on the standing branch `ironhorse-fuzz-findings`, and I've documented it on PR #1298. I didn't change any code this session: an earlier claimant had already pushed the regression test (20da8f94bf), and the fix was already on the branch.

**Reproduction**
- I rebuilt the input from the journal's `input_base64`, and its sha256 matches `0863e8c3…1fb1e98`.
- At the finding's commit `38ca1d1893` (llm), the fuzz run panicked with `result: oracle="51298814379687936" ironhorse="51298814379687940"`. The program works out to `226492415*226492415 + 327155712`.
- Both engines computed the same number. XS (the oracle the fuzzer compares against) prints the exact integer, while Ironhorse prints the shortest spelling that reads back to the same number, as the JavaScript spec requires. This is the same XS number-printing class as finding `05264cccae42245a`.

**Fix**
- The fix is fdb9fef6e0, already on the branch: the oracle now reports the exact number, and the fuzz harness compares Numbers bit for bit instead of comparing XS's printed text.
- The finding's commit (`38ca1d1893`) doesn't contain that fix, which is why the fuzzer flagged it.
- On the branch head, the same input runs clean with `cargo +nightly-2026-08-15 fuzz run differential_source … -runs=1`.

**Regression test**
- 20da8f94bf adds `ironhorse-vm/tests/finding_e0fe14e41d5074a6_large_integer_dtoa.rs`. It replays the exact bytes and asserts the spec spelling `51298814379687940`. It needs neither the oracle nor the moddable submodule.
- I ran it and it passes. Its commit message says it fails if the shared number formatter is broken.

**PR #1298**
- `ensure-pr.sh --find-only` found #1298 (still a draft), so no new PR was opened.
- I posted the finding's write-up: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5864960783
- A gauntlet for #1298 is already running (`endojs-endo-but-for-bots-pr1298-gauntlet`, with `fix-2` in progress). This commit only adds a test, so I didn't start a second one; the running gauntlet will cover the current branch head.
- At the time I checked, 18 checks had passed, 7 were skipped and 8 were still running. None had failed.

I deleted the temporary checkout I used for the reproduction; the project checkout is otherwise as I found it. No follow-ups are needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-e0fe14e41d5074a6-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 3 host(s) (4 unmetered)
- Input: 28 tokens (766866 cached reads)
- Output: 5859 tokens
- Cost: $0.6926332 (4 engagement(s) unpriced)
- Wall-clock: 1617s
- Model(s): claude-opus-5-5 ×3

<!-- garden-usage-end -->
