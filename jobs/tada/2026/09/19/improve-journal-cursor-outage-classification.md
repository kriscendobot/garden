Implemented and pushed commit `beb9fc3ede` to `main2`.

- Ambiguous journal-fetch `rc=1` failures now latch one shared temporary outage; sibling watchers skip quietly.
- Authentication, upstream, corruption, and local clone/repository failures remain loud and do not latch.
- Added concurrent regression coverage: 33 assertions passed across five repeated runs.
- Shell syntax and warning-level ShellCheck passed.
- Broader checks retain unrelated pre-existing gauntlet/comment-watcher failures.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-journal-cursor-outage-classification.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 540s

<!-- garden-usage-end -->
