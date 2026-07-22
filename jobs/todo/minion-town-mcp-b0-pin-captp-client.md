---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-07-22T16:05:36Z -->

# B0: pin and port the CapTP client

Repository: kriscendobot/minion.town.

Implement B0 from designs/mcp-daemon-guest-tools.md §7. Choose and record the pinned endojs/endo-but-for-bots llm commit in deploy/aws/scripts/deploy-endo-daemon.sh and in a provenance header. Port the thin netstring CapTP client as src/endo/captp-client.ts, adding the four npm dependencies pinned to the daemon lockfile versions. Keep it transplant-shaped for later @endo/mcp extraction.

Validation required: run the TypeScript typecheck and a unit test that exercises framing against a scripted netstring peer without a daemon. Report commands and observed results. This B0 work folds into the B1 PR, so prepare/push the appropriate project branch and leave a clear handoff for B1.
