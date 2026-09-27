Finding `6ba52f2bdc534545` (`differential_regexp_surface`) is fixed and locked with regression tests on the standing PR endojs/endo-but-for-bots#1298. The engine was not at fault: the XS oracle in the test harness cut its output short. The causal fixes were already on `llm`, so this job adds tests and changes no engine code.

**What I found.** No earlier attempt had committed or recorded any work on this finding, so I started from scratch. The recovered input matched the recorded sha256.
- **At the finding SHA `38ca1d1893`:** the input reproduced as a false result mismatch. The 5 bytes generate `new RegExp(<deeply nested disjunction>, "s").toString()`, which returns a 1963-byte string. The XS oracle stored its answer in a fixed buffer of about 1 KiB, so it kept only the first part. Ironhorse returned the full, correct string.
- **Cause:** the same harness defect as the earlier findings `493390fc03979205` and `197b32cc30bdd4fe`. It was fixed by 7fae4aea2f and 8fdef95f3c, which are both on `llm` and on the standing branch.
- **At the branch head:** the oracle's result is now byte-identical to Ironhorse's and `cargo fuzz run … -runs=1` exits cleanly. The only remaining difference is the computron count (328 vs 977), which this check treats as advisory and does not fail on.

**What changed.** Commit `04d410cce2` is pushed to `kriscendobot:ironhorse-fuzz-findings`, the head of #1298, after rebasing onto a peer's commit:
- **`ironhorse-vm/tests/finding_6ba52f2bdc534545_regexp_tostring.rs`, plus fixtures:** replays the exact input's compiled program without the oracle or the `c/moddable` submodule, and checks that it completes with the full, untruncated string.
- **`ironhorse-fuzz/tests/finding_6ba52f2bdc534545_regexp_tostring.rs`:** runs the same input against the real XS oracle. I confirmed it fails with the old oracle at `38ca1d1893` and passes at the current head.
- Both tests pass, and `cargo fmt --check` is clean.

**PR.** `ensure-pr.sh --find-only` found the existing PR #1298 rather than opening a new one; it is still a draft. I documented the finding in a PR comment: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5855211834. The review gauntlet `endojs-endo-but-for-bots-pr1298-gauntlet` is already running (panel-1 claimed) and covers the new head, so I did not start a new one.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-6ba52f2bdc534545-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 3 host(s) (3 unmetered)
- Input: 54 tokens (1859545 cached reads)
- Output: 14672 tokens
- Cost: $1.2863409999999997 (3 engagement(s) unpriced)
- Wall-clock: 691s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
