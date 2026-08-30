Reproduced finding `66facfd52ae8c673` and identified it as the already-fixed numeric dtoa comparison class.

Pushed commit `13ae6c6f7b` to `ironhorse-fuzz-findings`, adding exact-input regressions for `ironhorse-fuzz` and submodule-free `ironhorse-vm`. The regression fails when numeric value comparison is disabled and passes when restored.

PR [#1088](https://github.com/endojs/endo-but-for-bots/pull/1088) was adopted and [documented](https://github.com/endojs/endo-but-for-bots/pull/1088#issuecomment-5467922816). Direct repro now passes; VM suite, pre-push probes, and all 24 CI checks are green. The existing staged gauntlet owns panel/undraft follow-up.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-66facfd52ae8c673-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (3 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (3 engagement(s) unpriced)
- Wall-clock: 1521s

<!-- garden-usage-end -->
