Diagnosed `test-xs` as stale Ironhorse baselines introduced by the rebase. Added 48 expected-failure entries across 24 Ironhorse and SES-Ironhorse baselines, committed and pushed as `582b542fe`.

Verified the CI-equivalent `yarn test:xs` and hardened262 lint locally. All 24 CI checks passed, including `test-xs`: https://github.com/endojs/endo-but-for-bots/actions/runs/33180740337

Posted the completion summary and re-requested kriskowal’s review. PR #1077 remains open and unmerged.

Follow-up: posted `local-verify-endo-test-xs-parity` to close the local verification gap and pin the correct Moddable XS runtime.

Self-improvement: captured the `test:xs` and XS-version parity gap in the durable follow-up job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1077-shepherd-20260828.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1796s

<!-- garden-usage-end -->
