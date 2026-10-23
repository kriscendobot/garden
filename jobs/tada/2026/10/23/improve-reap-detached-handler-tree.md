Implemented and pushed commit `32faa8fe0a7` to `main2`.

- Replaced the handler process-group cleanup with bounded `reap_process_tree`.
- Added regression coverage for a `setsid` descendant in a separate process group.
- Verified `handler-orphan-reap-test.sh` (17/17) and `terminal-handler-failure-reap-test.sh` (6/6).
- The broader monk integration fixture remains independently broken because its temporary tree lacks `scripts/jobs/bin`; its process-tree unit checks passed.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-reap-detached-handler-tree.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 273s

<!-- garden-usage-end -->
