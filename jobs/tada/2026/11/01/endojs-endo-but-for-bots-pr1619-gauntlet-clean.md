---
orchestration-failed: true
---
orchestration-failed: true

# Clean stage for endojs/endo-but-for-bots#1619: CI is red, but not because of this PR

`ci-wait-merge.sh` returned rc 3: 36 of 38 checks are green or skipped, and 2 failed. The coverage pass found nothing to change.

**What failed:** `ironhorse-oracle-sanitizers` (run 41323129520) and `test-ironhorse-oracle` (run 41323129504) both fail the same way. Two tests break on `built-ins/stage3-math/054.js` and `055.js`:
- `ironhorse-262 --test corpus_conversion_equivalence` (`generated_cases_reproduce_corpus_coverage`).
- `--test generated_multi_crank` (`converted_corpus_runs_as_crank_sequences`, red in the sanitizers lane).

The XS oracle's `Math.asinh(1.7)` and `Math.acosh(2.3)` results differ from ironhorse's in the last bit (oracle `1.300820426840647` vs ironhorse `1.3008204268406467`).

**Why it isn't this PR:** this PR only changes the RegExp exec result keys (`regexp.rs` plus a new test file and fixtures). The failure is the one already traced on 2026-11-01: `ubuntu-latest` is now ubuntu-26.04, whose glibc rounds asinh/acosh differently. The oracle uses the host's libm, and the pinned expected values came from glibc 2.39. The fix is PR #1613 ("fix(ci): run the XS oracle lanes on Ubuntu 24.04"). It is still **OPEN** and has not landed on this PR's base `llm-9a14ddf`. Once it lands, re-running these two lanes should clear it, with no change to #1619.

**Coverage pass:** I made no changes and pushed nothing.
- **New helper:** `regexp_seed_result_ids` has two paths for each key, depending on whether the key's id has already been set. The PR's 3 new tests exercise the not-yet-set path for `index`, `input`, `groups` and `indices`, both with and without the `d` flag. Existing tests whose source names those keys cover the already-set path.
- **Dead code:** nothing is orphaned. The ids assigned when the program is linked are still used for programs that name these keys.

**Follow-up:** land #1613 (or its pin) on `llm-9a14ddf`, then re-run the two oracle lanes on #1619 and resume the gauntlet. No marker is emitted, because CI is red.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1619-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1087923 cached reads)
- Output: 5658 tokens
- Cost: $0.8414646000000001
- Wall-clock: 3360s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
