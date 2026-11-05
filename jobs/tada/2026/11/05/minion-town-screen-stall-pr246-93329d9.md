Cause: the screener’s GitHub read was repeatedly deferred with rc 75 by the host-wide primary-quota cooldown. Direct evidence reported `API rate limit already exceeded for user`; the latch was owned by `receipt:kriscendobot-ymax-stdio-mcp:PR source:primary-quota <- comment:source-timeout-fanout` and expires at 2026-11-05 05:51:03 UTC. `garden-proxy` logged neither screener notes nor a warning because the wrapper silently converted rc 75 to success. The MCP heartbeat was healthy (`ok`, 19 tools at 04:54:01Z).

Fixed and pushed commit `4dd011d253c13735a1f9b04a4f4799508f1d266b` to `main2`. The screener now preserves transient diagnostics, counts consecutive deferred/failed ticks, raises a coalesced watchdog notice after three failures, and closes it upon recovery. Documentation and regression coverage were added.

Verification: `python3 scripts/jobs/test/minion-town-screening-test.py` passed all 38 tests; shell syntax and `git diff --check` passed.

PR #246 remains unattested with no conductor while the valid quota cooldown is active. Normal proxy ticks will retry after expiry; no screening gate was bypassed and the delegation was not resumed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-screen-stall-pr246-93329d9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 764s

<!-- garden-usage-end -->
