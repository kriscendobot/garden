Opened and merged endojs/endo-but-for-bots#1363 into `llm` with merge commit `1aba3ca8dd`; the upstream two-parent merge history remains intact.

CI exposed lockdown failures in fast-check’s assignment-based dictionary mapper. Added atomic fix `7257ade3e4`, generating CopyRecords via `Object.fromEntries`. All 27 executed CI checks passed; 8 change-gated checks skipped as designed. Local verification included pass-style lint/types, Prettier, five marshal test runs, patterns’ 699 tests, and a 20,000-sample lockdown probe.

Posted and updated the PR completion summary. No follow-ups remain.

Self-improvement: routed the fast-check/SES lockdown gotcha to the liaison for project guidance.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-sync-llm-master-20260929-pr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 4470s

<!-- garden-usage-end -->
