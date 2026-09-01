---
handed-off: minion-town-blind-discovery-eval
deliverable-complete: false
---
Implemented and deployed the MCP tool rename in kriscendobot/minion.town#75.

Changed:
- Replaced `guest_*` and `clip_*` names with interface-native names.
- Resolved `list` collision as `list` and `listSites`.
- Removed legacy aliases and documented the full migration.
- Updated registrations, clients, documentation, policies, deployment checks, and fixtures.
- Added tools/list uniqueness and prefix-free contract coverage.
- Improved `evaluate` discovery and source-only defaults.

Verification:
- `npm test`: 290 passed, 5 existing real-daemon tests skipped.
- `npm run typecheck`: passed.
- `npm run build`: passed.
- GitHub CI run 33539871099: passed.
- Deployment run 33539977066: passed.

Follow-up: live blind evaluation requires AWS credentials unavailable in this worker. Posted `minion-town-blind-discovery-eval` with `requires: aws` to perform and document the exact context-free `evaluate 2 + 2` evaluation.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-remove-mcp-tool-prefixes.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 803s

<!-- garden-usage-end -->
