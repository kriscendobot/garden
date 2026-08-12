Implemented the OAuth scope-discovery fix in kriscendobot/minion.town PR #43 (commit `121464c`).

Changed the unauthenticated `/mcp` challenge to omit its misleading subset scope while preserving the `mcp/tools` authorization gate separately. Added regression coverage for both behaviors.

Verification: 218 tests passed, 3 skipped; typecheck and diff checks passed; GitHub CI passed.

Commented on garden issue #71 and left it open. Follow-up: merge and deploy PR #43.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/issue-kriscendobot-garden-71.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 232s

<!-- garden-usage-end -->
