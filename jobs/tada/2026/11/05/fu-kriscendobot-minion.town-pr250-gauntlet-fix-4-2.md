Fixed `ci-wait-merge.sh` so missing `checks:read` reports CI UNKNOWN instead of ordinary red, preventing erroneous shepherd dispatches.

Added regression coverage for annotation-forbidden and Actions-only fallback failures. `ci-wait-merge-test.sh`: 170 passed, 0 failed. Pushed commit `c32bd63c625` to `origin/main2`.

Follow-ups: none.
Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-kriscendobot-minion.town-pr250-gauntlet-fix-4-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 260s

<!-- garden-usage-end -->
