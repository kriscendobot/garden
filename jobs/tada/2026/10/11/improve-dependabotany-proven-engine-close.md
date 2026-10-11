Implemented and pushed commit `10afd91e5172` to `main2`.

- Added deterministic revalidation, fixed verdict/journal recording, and idempotent closing for unchanged Node-engine conflicts on bot-owned Dependabot PRs.
- Botanist dispatch now occurs only when revalidation fails; transient action failures defer safely.
- Added per-PR terminal ledger handling without draining unrelated embargoes.
- Tests passed: handler 4/4, preflight 43/43, syntax and diff checks.
- Broad suite reached unrelated existing failures in scaler logging and deferred-plan rendering.
- An accidental test comment on closed PR #1174 was immediately deleted; the test seam was corrected.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-dependabotany-proven-engine-close.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 719s

<!-- garden-usage-end -->
