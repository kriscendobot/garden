Implemented and pushed commit `a1eae966e6` to `main2`.

- Classifies comment-source rc 124/137 as transient timeouts.
- Opens the shared GitHub API cooldown, logs a warning, exits cleanly, and freezes the cursor.
- Added regression coverage for both return codes: all 8 new assertions pass.
- `bash -n` and `git diff --check` pass.
- Broader suite: 356 passed, 1 unrelated gauntlet-stage assertion failed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-rc124-timeout-not-classified-transient.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 233s

<!-- garden-usage-end -->
