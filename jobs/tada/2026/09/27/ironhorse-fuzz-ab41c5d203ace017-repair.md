Finding `ab41c5d203ace017` (`differential_regexp`) turned out to be a fault in the XS oracle, not the engine port. The Ironhorse port was already correct. I added a permanent regression test, pushed it to the standing branch, and documented the finding on the standing PR endojs/endo-but-for-bots#1298. No engine code changed.

The earlier attempt had committed nothing, so I started from scratch.

- **Reproduced at `38ca1d18`:** the 6-byte input's sha256 matches the recorded one. At that commit the fuzz target reports `match meter ironhorse=11163402240 pin=2573467648`. The oracle's number is the port's number cut down to 32 bits (11163402240 − 2·2³²). The oracle used to store the meter in a 32-bit field, and commit c8497fd88b (from finding `5d122a6fc10babd9`) had already widened it. That widening is the real fix, and at the branch head the same input passes. This is the same class as several earlier findings on this PR.
- **Regression test:** commit `17f1dd8ccf` on `kriscendobot:ironhorse-fuzz-findings` adds:
  - `ironhorse-vm/tests/finding_ab41c5d203ace017_regexp_meter_overflow.rs` plus the exact input as a fixture file. It rebuilds the case from those bytes and checks the match, all 31 captures, and the full meter value of 11163402240. It builds without the XS submodule.
  - a unit test in `ironhorse-fuzz/src/regexp.rs` that runs the same case against the oracle and checks both sides agree.
  - Both tests pass locally, and my new files pass `cargo fmt --check`.
- **PR:** `ensure-pr.sh --find-only` found the existing #1298 and created nothing new. The finding is written up in https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5855388909.
- **Gauntlet:** I did not post one, because a gauntlet for #1298 is already running (panel finished, `pr1298-gauntlet-fix-1` in progress). My commit only adds tests and will be reviewed as part of the PR's new head.

Follow-up: `cargo fmt --check` fails on two files from earlier commits, not mine: `ironhorse-fuzz/src/lib.rs:3010` and `ironhorse-vm/tests/finding_931a687135cabb0c_tie_dtoa.rs`. The project checkout also has an uncommitted change to `packages/floot/package.json`, which I did not touch or commit.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-ab41c5d203ace017-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 3 host(s) (4 unmetered)
- Input: 48 tokens (1451830 cached reads)
- Output: 12117 tokens
- Cost: $1.068154 (4 engagement(s) unpriced)
- Wall-clock: 887s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
