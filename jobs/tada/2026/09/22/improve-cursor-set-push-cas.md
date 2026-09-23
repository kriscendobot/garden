Implemented and pushed commits `db1bf226ee3` and `5118c1cf1da` to `main2`.

- Classified ordinary non-fast-forward push diagnostics as CAS contention and retry/reconcile them.
- Kept authentication, permission, local-state, and server-side hook/policy rejections loud.
- Added fixtures covering the real “failed to push some refs” diagnostic and server rejection behavior.
- Tests passed: cursor outage suite (59/59), cursor concurrency suite (8/8), Bash syntax checks, and `git diff --check`.
- Broader checks exposed unrelated existing failures in three gauntlet/information-hiding suites.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-cursor-set-push-cas.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 480s

<!-- garden-usage-end -->
