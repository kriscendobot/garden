Implemented and committed `2bd839e` on draft PR https://github.com/kriscendobot/minion.town/pull/171, stacked on #166’s frozen head.

Added automatic production checks for:

- Pinned Claude harness version, signed manifest, binary digest, ownership, and disabled updates via scoped AWS/SSM access.
- Claude stdio MCP confinement, using #167’s root-canary helper contract and reporting `skipped: no root canary credential` until available.

Production validation passed the harness check and all seven existing checks; confinement skipped as designed. All three PR CI checks passed. Follow-up: #167 must provide the root canary credential before confinement can pass automatically.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-arc-prod-validation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1087s

<!-- garden-usage-end -->
