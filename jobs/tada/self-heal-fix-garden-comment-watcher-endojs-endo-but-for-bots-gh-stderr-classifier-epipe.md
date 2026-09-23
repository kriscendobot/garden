Fixed and pushed commit `ae3415642d` to `main2`.

Changed the shared gh stderr classifiers to use here-strings, eliminating EPIPE/pipefail misclassification for large output. Extended primary-quota detection to `x-ratelimit-remaining: 0`. Added multi-megabyte regression coverage and verified the watcher emits the transient gh-api WARN with exit 0 and no FATAL. The existing LOST-FETCH-preserving quota circuit breaker remains intact.

Verification passed:

- `scripts/jobs/test/gh-api-retry-test.sh` — 39 passed, 0 failed
- `scripts/jobs/test/comment-watcher-test.sh` — passed
- `bash -n` and `git diff --check` — passed

Follow-ups: none.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-gh-stderr-classifier-epipe.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 267s

<!-- garden-usage-end -->
