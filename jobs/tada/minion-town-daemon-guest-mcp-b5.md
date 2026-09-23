Implemented B5 on https://github.com/kriscendobot/minion.town/pull/20 (commit `5162b34`).

Removed toy tools/state and `mcp/minions:*` wiring; guest tools are now required even when the daemon is unavailable. Updated PKCE client, server/deployment docs, Cognito/CDK config, and added deliberate Cognito cleanup script.

Verified: typecheck, build, shell syntax, and 76 targeted tests passed. Full `npm test` is blocked by missing cached `viem` dependencies in two SIWE suites.

Not deployed: B4 PR #19 remains open, so no green prior-stage evidence exists. Deployed fresh `tools/list` and E1-E4 remain unverified; local fresh-session tests confirm only `guest_*` tools.

Self-improvement: nothing this time.
