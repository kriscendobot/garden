Pinned PR #1594 at base `9a14ddf660912ed624e2d9047671d43e3a2f0cec` and head `10a1297e11f25bc6ec292886ab4e76a04dfa70ae` in an isolated checkout. The deterministic read-only pre-pass failed, so no juror panel was dispatched and no PR review was posted.

<!-- gauntlet-style-prepass-output-begin -->
probe no-plain-reexport         fail (exit 1)
  fail: packages/daemon/src/interfaces.js:1025 new plain named re-export from './worker-facet-interface.js' lacks a @deprecated JSDoc pointing importers at the original; make it a deprecated compatibility shim and migrate importers, or mark the file reexport-policy-exempt
result: 1 failing stage(s); address and re-run.
<!-- gauntlet-style-prepass-output-end -->

Self-improvement: nothing this time.
<!-- gauntlet-stage-result: panel=prepass-failed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1594-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 105s

<!-- garden-usage-end -->
