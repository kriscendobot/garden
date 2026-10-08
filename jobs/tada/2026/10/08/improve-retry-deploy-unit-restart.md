Implemented bounded per-unit deploy restart retries while preserving concurrent fleet restarts. Each unit now receives up to three attempts with a two-second delay; recovered units count as restarted, and only exhausted retries count as failures. Added transient and persistent failure coverage.

Verification:
- `deploy-garden-test.sh`: 187 passed, 0 failed
- `shellcheck` on `deploy-restart.sh`: clean
- `git diff --check`: clean
- Broader `run-test.sh` exposed three unrelated existing failures in scaler logging and bulletin rendering.

Pushed commit `312acb6c736` to `origin/main2`.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-retry-deploy-unit-restart.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 340s

<!-- garden-usage-end -->
