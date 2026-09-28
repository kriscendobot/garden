---
handed-off: endojs-endo-but-for-bots-pr1298-gauntlet
deliverable-complete: false
---
Implemented and pushed finding `27824c75429b8581` to the standing branch/PR.

- Reproduced the original exit-77 mismatch at project SHA `38ca1d1893`: XS emitted `57983845202395136`; Ironhorse correctly emitted the equivalent ECMA-262 shortest form `57983845202395140`.
- Confirmed the causal oracle-policy fix already exists in generalized commit `02c92f512f`.
- Added commit `9746e6da29`: an exact 11-byte fixture and load-bearing, submodule-free `ironhorse-vm` regression test. A deliberate formatter regression made the test fail, confirming its sensitivity.
- Verified the live standing head still contains the commit after concurrent peer advances.
- Adopted and documented [PR endojs/endo-but-for-bots#1298](https://github.com/endojs/endo-but-for-bots/pull/1298), including reproduction, root cause, regression proof, and verification evidence.
- Passed the focused unit test, pinned fuzz replay, Rust formatting, workspace clippy, and fuzz-target build.
- Full local verification encountered unrelated environment/concurrency failures: missing Moddable ESLint dependency, absent `zizmor`, daemon test port collision, and docs OOM.
- Preserved the pre-existing unrelated `packages/floot/package.json` modification.

The resumed standing gauntlet completed panel round 2 with `must-fix`; active orchestration `endojs-endo-but-for-bots-pr1298-gauntlet` has posted fix stage `endojs-endo-but-for-bots-pr1298-gauntlet-fix-2`, which owns the review fixes, CI wait, and subsequent panel round.

Self-improvement: nothing this time.


## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `558a9b7d`; this job presented `d65c6567540a3ac34c5a4bb43cf1f028462f359d`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-27824c75429b8581-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 3 host(s) (6 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (6 engagement(s) unpriced)
- Wall-clock: 4693s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
