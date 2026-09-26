Clean stage complete for PR #50.

- Added coverage for `whoami` identity output, baseline-only scope access, and default-deny behavior for unmapped tools.
- Fixed `whoami` to report static-policy identities as `admin` even when they also have a provisioned guest account.
- Coverage improved: `server.ts` lines 95.41% -> 98.13%, branches 53.65% -> 59.52%; `scopes.ts` branches 50% -> 100%.
- Checked for orphaned toy-tool code; no dead source code remained.
- Pushed commit `142f1459d79843129bd0f96e74843b091dfc5612`.
- Verified `npm run typecheck` and `npm test`: 220 tests passed, 3 skipped.
- CI completed successfully at the current PR head.
- Self-improvement: nothing this time.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-port-whoami-tool-20260819-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 356s

<!-- garden-usage-end -->
