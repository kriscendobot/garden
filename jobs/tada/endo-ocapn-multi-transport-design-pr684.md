Completed design PR #886: https://github.com/endojs/endo-but-for-bots/pull/886

- Updated `ocapn-network-transport-separation` with multi-transport `.np` hints, separate TCP+CBOR and WebSocket listener API, stable peer identity, migration, and tests.
- Pushed commit `d6322cc64b`.
- Documented on PR #684 that WebSocket work remains deferred pending this refactor.

Verified: `git diff --check`, Prettier, and Mermaid parse all passed.

Follow-up: implement the staged refactor before resuming #684.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-ocapn-multi-transport-design-pr684.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 505s

<!-- garden-usage-end -->
