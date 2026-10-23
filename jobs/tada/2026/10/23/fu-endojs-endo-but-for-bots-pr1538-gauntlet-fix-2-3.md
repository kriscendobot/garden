Confirmed the requested fix already landed on PR #1538 as commit `1007d2a`: retries remove stale `.endo-staging-*` directories while preserving live staging paths, with a daemon-restart regression test. No duplicate changes were needed.

Verification: all 55 `git-remote.test.js` tests passed; daemon type lint and targeted ESLint passed. CI remained in progress with no failures observed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-endojs-endo-but-for-bots-pr1538-gauntlet-fix-2-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 2603s

<!-- garden-usage-end -->
