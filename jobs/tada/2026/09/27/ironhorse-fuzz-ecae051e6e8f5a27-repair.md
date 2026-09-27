Finding ecae051e6e8f5a27 is diagnosed and now has a regression test on the standing branch. The engine needed no fix: ironhorse's output is correct and the XS reference engine (the fuzz oracle) is the one that's wrong. I did not run the PR's gauntlet.

**Reproduction**
- I rebuilt the 10-byte input from the journal's `input_base64`; its sha256 matches `08008aee…0c7d`.
- At the fuzzed SHA `38ca1d18` the pinned `cargo +nightly-2026-08-15 fuzz run differential_source` crashes with a differential divergence. The generated program is `(922746880 * (-(377487360 + (922746880 / 17.5))))`: XS gives `-396980243939421600` and ironhorse gives `-396980243939421630`.
- At the standing branch tip `6b74f34e23` the same input runs clean.

**Diagnosis**
- The result is exactly the double `-396980243939421632`. Ironhorse prints the shortest string that converts back to that double, as the spec requires. V8 prints the same.
- XS's spelling does not convert back to that double; it lands on the neighbouring one. This is the same "large-integer dtoa spelling" class as earlier findings.
- The existing fix `4b95dc199e`, already on the branch, makes the fuzz harness check Number spelling against the spec rather than against XS. That is why the tip no longer reproduces.

**What changed** (commit `4a66b6eb7c`, pushed to `ironhorse-fuzz-findings` after a fetch and rebase)
- A new `ironhorse-vm` test, `rust/engine/ironhorse-vm/tests/finding_ecae051e6e8f5a27_large_integer_dtoa.rs`, replays the exact bytes from `fixtures/finding-ecae051e6e8f5a27.input.bin`. It checks the program completes with the correct spelling, and that XS's spelling is a different double. It builds without the XS submodule.
- A test in `ironhorse-fuzz/src/lib.rs`, `finding_ecae051e6e8f5a27_large_integer_dtoa_agrees`, runs the same program against XS and requires no divergence. It would have failed at `38ca1d18`.
- The new `ironhorse-vm` test and all 56 `ironhorse-fuzz` `finding_*` tests pass, and the pinned-nightly rustfmt check is clean.

**Standing PR**
- `ensure-pr.sh --find-only` found the existing standing PR, endojs/endo-but-for-bots#1298 (still a draft); its head is now `4a66b6eb7c`.
- I posted the diagnosis for this finding as a PR comment: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5856177165

**Follow-ups**
- CI is pending on the new head.
- The gauntlet is the one step of the procedure I skipped. The earlier findings on this PR also left it for the PR's next review round, and gauntlets now start only on an explicit "run the gauntlet #1298". Say that when you want the review.
- The durable input path on the leader host doesn't exist on this host; the journal copy was enough.
- I couldn't check my inbox because the journal clone timed out.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-ecae051e6e8f5a27-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 9 on 2 host(s) (7 unmetered)
- Input: 42 tokens (1366701 cached reads)
- Output: 11281 tokens
- Cost: $1.0726882 (7 engagement(s) unpriced)
- Wall-clock: 1203s
- Model(s): claude-opus-4-8 ×1, claude-opus-5-5 ×1

<!-- garden-usage-end -->
