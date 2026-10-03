Implemented and pushed commit `df58db6caf4` to `main2`.

- `clone_lock` and `ensure_clone` now treat repository-lock rc 124 as transient, log the skip, and exit with `GARDEN_OFFLINE_RC`.
- Other lock failures remain fatal.
- Added regression coverage for both paths.
- Focused repository-lock tests passed.
- Full suite encountered three unrelated existing failures in scaler and plan-queue assertions.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-rolling-deploy-ensure-clone-lock-timeout.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 353s

<!-- garden-usage-end -->
