Implemented and pushed `3674b9b2069` to `main2`.

- Added one same-session Codex rescue for nonzero exits with nonempty reports.
- Completion succeeds only if rescue exits 0 and emits the existing marker; otherwise original failure is retained.
- Added focused success/failure harness coverage (29 passing checks).
- Broader integration test was stopped after blocking in its existing worker loop.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-codex-nonzero-completion-rescue.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 359s

<!-- garden-usage-end -->
