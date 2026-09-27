Confirmed the fix is already landed on `origin/main2`:

- Live-holder clone-lock timeouts now exit quietly with `GARDEN_OFFLINE_RC` instead of producing a FATAL.
- Definite local/auth/corruption failures remain loud.
- CI watcher clones are now per-repository, reducing contention further.
- Verified with:
  - `cursor-outage-cooldown-test.sh`: 61 passed
  - `fetch-timeout-test.sh`: 24 passed
  - `ci-watcher-test.sh`: 85 passed

No additional changes were necessary; the worktree remains clean.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-ci-watcher-lock-busy-outage-classify.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 104s

<!-- garden-usage-end -->
