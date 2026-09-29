Landed `9090b2685be` and `b89b800a91d` on `main2`.

Added repository read/write locks, coalesced fetches, freshness overrides, serialized CAS/deploy/maintenance operations, migrated callers, regression tests, and a design note.

CI passed. Contention and compatibility tests passed; existing baseline failures remained unchanged. Live-host probe: 13 requests produced one fetch—a 92.3% reduction.

Follow-up: normal fleet deployment activates the changes.

Self-improvement: updated `sibling-family-sweep` with the fresh-flag propagation lesson.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-host-local-git-repo-locks.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1810s

<!-- garden-usage-end -->
