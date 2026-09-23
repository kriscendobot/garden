Implemented and pushed commit `986cd28d3ba242e28d700c16f68971778469461c`.

- Git and XS-backed range streams now reuse one source stream instead of rematerializing/reopening per 48 KiB window.
- Window contracts require copied bytes; XS now uses `slice`, with shared-boundary defense and backing-buffer isolation tests.
- Updated the existing changeset.
- Verification passed: Prettier, ESLint, TypeScript for platform/daemon/git, 350 platform tests, 3 git tests, and 21 affected daemon tests. Regression test failed as expected when `subarray` was temporarily restored.
- Posted the required [PR summary](https://github.com/endojs/endo-but-for-bots/pull/910#issuecomment-5212398650). PR remains draft.
- Self-improvement: notified liaison that the documented pre-push gate driver is missing; individual probes were run successfully.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/pr910-mustfix-round2-03-producer-copy.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1403s

<!-- garden-usage-end -->
