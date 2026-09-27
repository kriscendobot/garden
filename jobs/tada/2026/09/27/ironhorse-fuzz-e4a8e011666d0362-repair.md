## Completion report: `ironhorse-fuzz-e4a8e011666d0362-repair`

**Outcome:** This finding is not an engine bug, so no engine fix was made. The port's result matches XS exactly; only the cost count differed, and the fuzz check now treats that difference as advisory. I added two regression tests to the standing branch and documented the case on the standing PR, endojs/endo-but-for-bots#1298.

**Reproduction**
- I rebuilt the input from the journal's `input_base64` and confirmed its sha256 is `1c3ef6ed…80876d5` (3 bytes). The file on the leader host was not reachable from this host.
- **At the finding SHA `38ca1d1893`** the crash reproduces: `differential_regexp_surface` panics with `computrons: oracle=186 ironhorse=187`.
- **The generated program** is `new RegExp("(?:[abc]+?(?:…){1,2}…){1,2}", "").exec("b\n0"); m ? m.index : -1`. The pattern cannot match, and both engines return `-1`.
- **Cause:** this is a cost-count gap, not a correctness defect. It is the same class as the earlier findings `1cb63ec6f8e6fc22` and `2cc2ac67ba7e9b9f`. The fuzz check (`differential_check_meter_v4`) no longer fails on an XS cost mismatch, so at the branch tip the target runs this input clean.

**What changed:** commit `6b74f34e23` on `ironhorse-fuzz-findings`, pushed with a fetch/rebase/push loop.
- **New test in `ironhorse-vm`:** `rust/engine/ironhorse-vm/tests/finding_e4a8e011666d0362_regexp_surface_meter.rs`. It builds without the Moddable submodule or the XS oracle. It replays the exact input's bytecode and symbols, stored as fixtures, and asserts the program completes with result `-1`. The cost count is deliberately not pinned, so future cost-table changes won't break it.
- **Fixtures:** `rust/engine/ironhorse-vm/tests/fixtures/finding-e4a8e011666d0362.{input,bytecode,symbols}.bin` and `.expected-result.txt`.
- **New test in `ironhorse-fuzz`:** `finding_e4a8e011666d0362_regexp_exec_cost_gap_is_advisory` in `ironhorse-fuzz/src/lib.rs`. It checks the generated program's shape and that `differential_check_meter_v4` returns `Ok`.
- Both new tests pass locally and `cargo fmt --check` is clean.

**Standing PR**
- `ensure-pr.sh --find-only` found the existing PR #1298 (still a draft), so nothing new was opened.
- I posted a comment on #1298 describing this finding and how it was resolved: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5855871664
- CI on head `6b74f34e23` passed: 15 checks passed (all ironhorse legs, the oracle sanitizers, macOS and format), 7 were skipped, none failed.

**Follow-ups**
- I did not start a review gauntlet. Under the current rules only the maintainer can start one, with "run the gauntlet #1298".
- The inbox check at the start failed because the journal clone timed out.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-e4a8e011666d0362-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 2 host(s) (4 unmetered)
- Input: 54 tokens (1934517 cached reads)
- Output: 13042 tokens
- Cost: $1.2652553999999996 (4 engagement(s) unpriced)
- Wall-clock: 2526s
- Model(s): claude-opus-4-8 ×1, claude-opus-5-5 ×1

<!-- garden-usage-end -->
