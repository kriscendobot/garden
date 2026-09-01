Hardened `ci-watcher.sh` so all per-repo unit invocations derive the journal-outage latch and flock from the shared `GARDEN_ROOT`, independent of invocation-local `GARDEN_STATE`.

Extended the concurrent-outage regression to model separate per-repo state directories; it confirms six simultaneous watchers emit exactly one outage-open warning and one recovery notice.

Pushed commit `64dca4517f` to `main2`.

Verification: `ci-watcher-test.sh` passed all 62 tests. The broader suite passed 378/379; one unrelated issue-inbox stderr-format assertion failed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deduplicate-ci-journal-outage.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 282s

<!-- garden-usage-end -->
