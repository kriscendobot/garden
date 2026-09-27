## Completion report: ironhorse-fuzz-37e026fd30cbae19-repair

Finding 37e026fd30cbae19 is not an engine bug: ironhorse computes the correct value and only spells it differently from XS. The standing branch already handles it, so I added regression tests and made no engine change. I did not start a gauntlet on the standing PR.

**Reproduction**
- I rebuilt the input from the journal's `input_base64` and checked its sha256: `647d3c14…5d36`, 3 bytes, `1b 55 09`.
- It reproduces at the fuzzed SHA 38ca1d18. I built that SHA in a temporary worktree, and `cargo +nightly-2026-08-15 fuzz run differential_source` panicked with `result: oracle="-51298814505517056" ironhorse="-51298814505517060"`.
- The input generates `(((-(false * 226492416)) * (-(false * 226492416))) + (-((-226492416) * (-226492416))))`. Its value is the exactly representable double −51298814505517056 (−729·2⁴⁶).
- Both strings parse to the same double. XS's `fx_dtoa` prints the exact integer. Ironhorse prints the shortest decimal that round-trips, which is what the spec requires.
- At the standing tip `ironhorse-fuzz-findings` (62e4981211) the input runs clean. Commit fdb9fef6e0 already compares Number results by the oracle's exact double. This is the negative twin of finding 67a52af412f03a7b.

**What changed** (commit 4bcda27361, pushed to `kriscendobot:ironhorse-fuzz-findings`)
- **VM regression test:** `rust/engine/ironhorse-vm/tests/finding_37e026fd30cbae19_large_integer_dtoa.rs`, plus the input fixture `tests/fixtures/finding-37e026fd30cbae19-input.bin`. It builds without the XS oracle or the moddable submodule. It replays the exact bytes through the pinned grammar, compiles and runs the program in the VM, and asserts it completes with `-51298814505517060`. It also asserts that this and the XS spelling are the same double.
- **Fuzz-side test:** `ironhorse-fuzz/src/lib.rs` gains `finding_37e026fd30cbae19_large_integer_dtoa_agrees`, which asserts `differential_check` against the XS oracle agrees on this input.
- Both tests pass and `cargo fmt --check` is clean.

**Standing PR**
- `ensure-pr.sh --find-only` found the existing endojs/endo-but-for-bots#1298, so no new PR was opened.
- I posted the finding and its resolution as a comment: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5854555819

**Follow-ups**
- **Gauntlet:** under the manual-gauntlet rule only you start one, and the earlier repairs on #1298 didn't either. It needs "run the gauntlet #1298".
- **Inbox:** I couldn't read this job's inbox at the start because the journal clone timed out.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-37e026fd30cbae19-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 2 host(s) (5 unmetered)
- Input: 50 tokens (1650153 cached reads)
- Output: 12271 tokens
- Cost: $1.1539465999999998 (5 engagement(s) unpriced)
- Wall-clock: 981s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
