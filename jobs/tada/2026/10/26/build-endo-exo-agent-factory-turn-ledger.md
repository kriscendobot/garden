Implemented and pushed the turn-publication slice. Added keyed `TurnStarted`/`TurnResult`/`Published` recovery, reply-to publication, crash-cut and confinement coverage, and a provider-backed issuance example.

Opened draft PR: https://github.com/endojs/endo-but-for-bots/pull/1563

Verification: package lint and all 34 tests passed; pre-push gates passed. CI remains in progress, with unrelated runner failures for missing `tred` and unsupported `/bin/sh ulimit -u`; the gauntlet worker was notified.

Follow-up: design phases 2, 3, 4, and 6 remain with successor `minion-town-mcp-ocapn`, as recorded in the PR ledger.

Self-improvement: CI runner prerequisite checks should cover Graphviz `tred` and required shell `ulimit` support.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-exo-agent-factory-turn-ledger.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 4755s

<!-- garden-usage-end -->
