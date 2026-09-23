Inbox empty. Work complete. 

---

## Completion report

**Job:** Incorporate mhofman's repro-setup clarification into the ymax0 #9 investigation, pivot to the mainnet contract-control-upgrade vector, run it, and reply to mhofman.

### What I did

1. **Reconciled the version/network mapping against the captured mainnet swing-store** (`agoric-26146641`, `host.height 26146641`, integrity ok), confirming mhofman's numbers with on-chain data:
   - devnet ymax0 = vat **v320** (no snapshot available).
   - mainnet **ymax0 = v290** (`zcf-b1-68c494…`, contract bundle `b1-68c494…`), **ymax1 = v288** (`zcf-b1-61c340…`) — both present and **non-terminated** (`vats.terminated` empty). Exactly the vat IDs he named.

2. **Pivoted the inquisitor vector** from `createVat` to the contract-control upgrade he asked for (`E(ymax0Kit.adminFacet).upgradeContract(bundleId)`, a real `E(adminNode).upgrade(...)` at the swingset layer) and **ran it through the inquisitor against the snapshot**. Result: it failed with `vatAdminService rejecting attempt to perform "upgrade"() on non-running vat "v275"`.

3. **Found the root cause of the confusion mhofman flagged:** the only ymax0 admin facet reachable from the bootstrap promise space (`ymax0Kit.adminFacet`, held by Zoe/v9) belongs to the **original, now-gone** ymax0 instance, vat **v275** (`v275.options` absent, not in `vat.dynamicIDs`). The live v290/v288 instances carry separate admin facets Zoe holds privately, not exposed in any promise-space kit. So earlier runs were never touching the live deployment.

4. **Empirical finding:** every on-chain ymax contract bundle in the snapshot (`1cfec/867596/078729/68c494` ymax0, `61c340` ymax1) carries the wide `hex.js` `flatMap` yet flattens to only 3–5 `flatMap`s and imports **clean** through a real on-chain worker (latest `b1-68c494…`/v290 reaches the benign post-import `lacks buildRootObject()`). The current mainnet deployment is **below** the 4096-slot threshold; the over-threshold failing bundle is **not in the mainnet snapshot**.

### What changed
- **Posted the reply to mhofman** on kriskowal/garden#9 ([comment 4848527254](https://github.com/kriskowal/garden/issues/9#issuecomment-4848527254)): corrected plan, the verified version mapping, the stale-kit root cause, the bundles-import-clean finding, and two concrete asks (the actual devnet "v320" failing bundle, and a handle to the live v290/v288 contract-control admin facet).
- **Committed to `main2`** (`789a6f8ff`): corrected the `agoric-chain-snapshot` skill's vector note — the bootstrap `ymax0Kit` is stale (v275), the faithful target is the live v290/v288, current mainnet bundles are sub-threshold, and added the `repro/repro-upgrade-driver.mjs` pointer.

### Follow-ups (carried in the #9 reply, awaiting mhofman)
- Need the actual failing devnet "v320" ymax0 contract bundle (id or build) to upgrade v290 to — the snapshot lacks an over-threshold bundle.
- Need confirmation of how the real upgrade reaches the live v290/v288 admin facet (deploy capability / governance contract-control message), since the bootstrap kit is stale.
Once both arrive, the control/patched upgrade of v290 can run end-to-end on real mainnet state.

**Self-improvement:** Landed the corrected vector understanding into the `agoric-chain-snapshot` skill so the next inquisitor run does not repeat the stale-bootstrap-kit (`v275`) mistake and knows the live targets are v290/v288.
