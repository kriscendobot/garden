---
handed-off: minion-town-claude-cli-production-deploy-fix-20261004
deliverable-complete: false
---
PR #150 merged as `fd60577f4a9127e670474daad844010395ebbfde`, but production verification failed.

- Push CD run `37228046918` failed; targeted app redeploy `37228426404` was dispatched and also failed.
- Root cause: the artifact contains `node_modules/@endo/claude -> ../../vendor/endo-claude`, but its tarball omits `vendor`.
- Rollback restored commit `a378bb3d…` without restoring the prior systemd unit, leaving `minion-mcp` crash-looping with `ENDO_CLAUDE_ENABLED=1`.
- SSM evidence: `NRestarts` rose 99→102 in 12 seconds; the route returned `000`; enabled/unavailable wiring logs were absent. `endo-daemon` remained active. Rendered Claude variables were present; `MemoryMax=1610612736`.
- Alerted the maintainer and posted urgent successor `minion-town-claude-cli-production-deploy-fix-20261004`, now claimed, owning availability recovery, packaging/rollback fixes, deployment verification, and subsequent canary posting.
- The canary was not posted because its production precondition failed.
- No repository changes were made.
- Self-improvement: nothing this time.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-claude-cli-production-enable-verify-20261004.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 438s

<!-- garden-usage-end -->
