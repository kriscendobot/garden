The work is complete. Here is my report.

## Completion report — `deadmail-issue-comment-4900696368`

**Intent recovered.** This was a dead-lettered issue-inbox message: mhofman (trusted COLLABORATOR) left a new comment on kriskowal/garden#29 wary of the "label-only or label-first" approach in the ymax critical-promotion prototype — noting (1) mainnet runs **both** ymax0 and ymax1, and (2) Zoe-started vats are labelled `zcf`, so "ymax" may not appear in the label at all. The original handler (`issue-kriskowal-garden-29`) had already completed, so I picked up the intent: fold the feedback into the PoC and reply on the issue thread.

**Verified his concern from source (Agoric/agoric-sdk).** `createZCFVat` names a contract vat `zcf-${contractLabel}`, and `contractLabel = instanceLabel ? ${bundleLabel}-${instanceLabel} : bundleLabel` — so the kernel `options.name` is `zcf-<bundleLabel>[-<instanceLabel>]` and need not contain the contract's own label. Both of his points confirmed.

**Structural finding.** `upgradeSwingset()` runs inside `launch()`/`ensureSwingsetInitialized()`, **before** `AG_COSMOS_INIT` delivers the upgrade plan — so `chainID` is unavailable in the version-migration. That is *why* the prior draft reached for a self-gating label. Since a bare vatID isn't safe across chains, the pin must be resolved where chainID is known.

**Code changed** (pushed to `kriscendobot/agoric-sdk@garden29-promote-ymax-critical`, PR #9, commit `07dc44fcc9`):
- Replaced the `name.endsWith('-ymax0'|'-ymax1')` selector with an explicit, chain-resolved **vatID directive** (`upgrade.promoteCriticalVats`) that the v4 migration consumes and clears; no directive → clean no-op.
- vatID resolution moved to `golang/cosmos/app/upgrade.go` under `switch ctx.ChainID()` (v288/agoric-3, v320/agoricdev-25), mirroring the `terminationTargets` precedent.
- Label/name demoted to a `zcf`-prefix **assertion guard**; a stale/mis-chained pin now fails loudly.
- Reworked tests (promote-pinned, no-op-without-directive, reject-non-live-contract-vat). JS files pass `node --check`; the ava suite is not run here (no full agoric-sdk build), consistent with the PoC's standing caveat.

**Reply posted** to issue #29 (comment 4900782068, as kriscendobot): confirms his points with citations, explains the chainID-availability constraint, summarizes the fix, and asks his two open calls — which plumbing to deliver the Go-resolved pin into the directive key, and whether v288/v320 constants are correct vs. querying the running chain.

**Follow-ups (for mhofman / a future job):** (1) wire the Go-resolved pin into the swing-store directive key ahead of reboot — the one unimplemented integration step; (2) land the a3p post-upgrade `options.critical` assertion.
