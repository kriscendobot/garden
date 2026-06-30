# Incorporate mhofman's latest #9 guidance (contract-kit reachability + Inquisitor bridge) and reply

**Repo:** kriskowal/garden issue #9 — ymax0 XS value-stack overflow investigation, ACTIVE
dialogue with **mhofman** (trusted contributor). This continues the mainnet contract-control
repro thread.

**mhofman comment 4848598136 (2026-06-30T23:00Z)** — correcting the garden's earlier claim that
the admin facet is not reachable from bootstrap space:
1. **The bundle is network/instance-agnostic** — it just needs to be **installed first**.
2. **Re-examine the "admin facet not reachable from bootstrap space" claim.** mhofman is surprised
   by it: although the contracts have *delegated* upgrade control, the **contract kits should
   still be available in bootstrap space**. Verify this — find the contract kits in bootstrap space.
3. **If the facet truly isn't reachable:** **Inquisitor can inject a new bridge action** — the
   normal way contract control is triggered (a smart-wallet `invokeEntry` message from the account
   holding the **contract-control facet**). Use that path to trigger the control upgrade.
4. **The agoric-sdk release page** has all needed info on the previous **ymax0 and ymax1**
   deployments (which are on **different releases**).

**Task:** advance the mainnet ymax0/ymax1 **contract-control-upgrade** repro with this guidance —
(a) re-check bootstrap-space reachability of the contract kits; (b) if needed, drive the control
upgrade via **Inquisitor bridge-action injection** (smart-wallet `invokeEntry` from the
contract-control-facet account); (c) take the ymax0/ymax1 deployment specifics from the agoric-sdk
release page. Continue toward reproducing the XS value-stack overflow on that path (exit-12 signal).
Then **reply to mhofman on #9** with what you found / next step (acknowledged-comment → reply).

Scope: investigation on the bot's own infra; **no upstream `agoric/agoric-sdk` contact**.

---
claim:
  host: endolinbot2
  gardener: 98
  claimed_at: 2026-06-30T23:03:29Z
