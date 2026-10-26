Implemented and pushed reader-side reply collapse for Fae and Lal, stacked on #1563.

- Added shared exact-reply collapse logic without changing daemon APIs.
- Covered mailbox snapshots and live conversation loops.
- Added unit tests and real-daemon crash/republication acceptance coverage preserving original `replyTo`.
- Package suites, focused acceptance tests, lint, and deterministic probes pass.
- Opened draft PR: https://github.com/endojs/endo-but-for-bots/pull/1564
- Follow-up: full factory topology remains in sibling PRs #1561 and #1562; PR #1564 is ready for its orchestrated gauntlet.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-exo-agent-factory-reply-collapse.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 3354s

<!-- garden-usage-end -->
