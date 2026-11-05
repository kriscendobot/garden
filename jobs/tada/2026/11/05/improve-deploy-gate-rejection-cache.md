Implemented and pushed commit `92f3d7b0bd9` to `main2`.

- Added SHA-keyed deploy-gate rejection records containing final suite results and diagnostic paths.
- Identical rejected candidates now fast-reject without rerunning suites or duplicating journal/inbox errors.
- New candidate SHAs naturally run a fresh gate; emergency overrides clear cached rejection state.
- Added regression coverage for persistence, fast rejection, diagnostic retention, duplicate suppression, and SHA invalidation.
- Verification: 220 deploy tests passed. The remaining 14 self-swap/strand fixture failures were reproduced unchanged on the baseline (210 passed, same 14 failures).
- Self-improvement: nothing this time.
- Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deploy-gate-rejection-cache.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 609s

<!-- garden-usage-end -->
