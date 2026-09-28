## Finding `2a2de75b75de4894` (`differential_source`): regression test added, no engine fix needed

The fuzzer's reproducer does fail at the recorded SHA, but it is not an Ironhorse bug, and the branch already carries the harness fix. The only new code is a regression test.

**Reproduction**
- I decoded the 3-byte input from the journal finding, and its sha256 matches `ad63534a…9e924a4e`.
- At `38ca1d1893` the program generated from the input diverges: `result: oracle="306526249411411970" ironhorse="306526249411412000"`.
- At the branch head `12f9ffc1a3`, `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1` runs cleanly.

**Cause**
The program reduces to `553648128 * 553648128 - 226492415`, which rounds to the number `306526249411411968`. XS prints it with 17 digits, and Ironhorse prints the shortest spelling that ECMA-262 requires. Both strings parse back to the same number, so the engines agree on the value. This is the known XS number-spelling class. The harness already fixes it by comparing numbers by their exact value (fdb9fef6e0 plus the later commits that unified the policy), and that fix postdates the recorded SHA.

**What changed** (commit `91f38a663d`, pushed to `ironhorse-fuzz-findings` on endojs/endo-but-for-bots)
- `rust/engine/ironhorse-vm/tests/finding_2a2de75b75de4894_large_integer_dtoa.rs`: checks the input's sha256, then compiles and runs the pinned program in the VM without the XS oracle. It asserts that the run completes with the result `306526249411412000`, and that this and XS's spelling are the same number.
- Fixtures `finding-2a2de75b75de4894.input.bin` and `finding-2a2de75b75de4894.program.txt`. The existing `vm_finding_fixtures` test regenerates the program from the input and requires the bytes to match.
- The new test and `vm_finding_fixtures` both pass, and the new file passes `rustfmt --check`.

**Standing PR**
- `ensure-pr.sh --find-only` found the existing draft PR, endojs/endo-but-for-bots#1298, whose head is now `91f38a663d`. Nothing new was opened. It also reported that the board has no `work/ironhorse-fuzz-findings` record, so the PR number was not recorded there.
- I documented the case and its resolution in a PR comment: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5866657137

**Not done / follow-ups**
- **Gauntlet not run:** under the manual-gauntlet rule only the maintainer starts one, so I did not. The maintainer can say **run the gauntlet #1298** when they want it reviewed.
- **Inbox not drained:** the one attempt, at the start, failed because the journal clone timed out. I did not retry later.
- **Unrelated local changes left alone:** the project checkout still has a modified `packages/floot/package.json` and untracked compartment-mapper fixtures. I did not commit them.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-2a2de75b75de4894-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 3 host(s) (4 unmetered)
- Input: 50 tokens (1604098 cached reads)
- Output: 10934 tokens
- Cost: $1.0903155999999998 (4 engagement(s) unpriced)
- Wall-clock: 898s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
