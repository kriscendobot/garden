Restored production immediately with a reversible dark-provider systemd override; `minion-mcp` returned healthy while preserving the failed artifact.

Landed:

- kriscendobot/minion.town#155 (`f2b989f`): ships `vendor/endo-claude`, adds archive regression coverage, and rolls back the systemd unit with the artifact.
- kriscendobot/minion.town#156 (`880278b`): fixes the subsequently exposed startup-readiness race.

Verification:

- CI and deployment run `37229995905` passed.
- SSM confirmed source commit `880278b`, `@endo/claude` present, exact enabled-backend wiring log, rendered `ENDO_CLAUDE_*`, `MemoryMax=1610612736`, `/account/claude/<nonce>` returning 403 rather than 404, both services active, and restart counts stable at zero over 30 seconds.
- Regression test failed with `ENOENT` when `vendor` was removed from the archive manifest, then passed after restoration.
- Full suite passed: 808 tests, 10 skipped.

Posted `minion-town-claude-cli-production-canary-20261004` with the predecessor’s exact body. It has been claimed; I did not run the canary.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-claude-cli-production-deploy-fix-20261004.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1699s

<!-- garden-usage-end -->
