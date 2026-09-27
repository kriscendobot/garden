**Report: fix-garden-ci-gauntlet-retry-viability-tests**

The garden's `checks` workflow on `main2` is green again: run `36305555339` at `773813fb507` passed, and it includes all three of my commits. The run on my own last commit was cancelled because the next push to `main2` superseded it.

**The two named suites had one shared cause, and it was the tests that were out of date.** Commit `6de4bf5a57e` (2026-09-18, "date-shard tada completion writers (stage 2)") changed `finish_gauntlet` so completion reports go to dated subfolders, `jobs/tada/<yyyy>/<mm>/<dd>/<base>.md`. That commit updated the gauntlet tests under `scripts/jobs/test/` but missed `tests/checks/test_gauntlet_stage_retry_budget.sh` and `tests/checks/test_gauntlet_viability_gate.sh`. Both still read the old flat path `jobs/tada/<base>.md`, so every assertion about a finished gauntlet failed. That includes the `cat: .../jobs/tada/overtaken.md: No such file or directory` lead. The gauntlet code itself behaved correctly.

- **Fix `f0e157d21ed`:** both suites now look up reports by name across the dated subfolders, the same way the sibling suites already do. No assertion was loosened. Results: retry-budget 16/0, viability-gate 9/0, `tests/checks/run.sh` 12/0.

**Why nobody saw it for days:** CI was red before 09-24 as well; `6de4bf5a57e`'s own run on 09-18 already failed. The shellcheck step failed first on every run from 09-18 until `2dabc3e1ca1` (09-23), so "Run focused tests" never ran. Those shellcheck failures hid this break until 09-24.

**Two more failures were hidden behind these and are also fixed.** Once the two suites passed, later tests in the same CI step ran for the first time:

- **`6f1413c8026`:** `scripts/jobs/test/journal-entry-project-test.sh` had a path hardcoded to this machine (`mktemp -d /home/kris/...`), introduced in `3cc1ad83122`. It now uses `$HOME`, which works on any host.
- **`71c75d83047`:** `scripts/jobs/muster-pilot.sh` created its temp folder inside `$GARDEN_SCRATCH` without first creating that folder. The folder is gitignored, so on a fresh checkout (a new instance, or the CI runner) the pilot crashed before doing anything. This was a real bug in the script, not just in its test. It now runs `mkdir -p` first; I checked this on a fresh `git archive` export with no scratch folder.

**Local verification:** shellcheck, the `bash -n` syntax check and every test in the CI list passed locally. The `scripts/jobs/test/` tests from quota-calibration through docs-claim-accuracy were also run with a different `$HOME` to mimic the runner.

**Follow-up:** `scripts/jobs/test/cursor-outage-cooldown-test.sh` subtest (d3) failed 2 assertions once during my full local run, while the host was busy. It passed 61/0 on three standalone runs and in CI, so it looks timing-sensitive: it gives a background fetch only 2 seconds to start (100 × 0.02s). If it shows up red again, the fix is a longer or event-based wait. I didn't change it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-garden-ci-gauntlet-retry-viability-tests.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 94 tokens (3634858 cached reads)
- Output: 16468 tokens
- Cost: $1.7774835999999996
- Wall-clock: 2576s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
