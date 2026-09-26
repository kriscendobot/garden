Done. Completion report follows.

---

## Completion report — `garden-issue-9-kriskowal-mainnet-validation-tree-bundle-publish`

**What the job asked:** Act on kriskowal's #9 pointer ("there are examples for publishing a bundle to chain in the mainnet validation tree") — locate those examples and use them to ground the "install the bundle first" prerequisite mhofman named for the ymax0/ymax1 contract-control-upgrade repro; fold into the ongoing #9 work; reply on #9. Complements (does not duplicate) the in-flight `garden-issue-9-mhofman-contract-kit-and-inquisitor-bridge` job.

**What I did:**
1. **Located the examples.** The "mainnet validation tree" is agoric-sdk's `a3p-integration/` tree (agoric-3-proposals integration). Traced the full **publish → install → contract-control-upgrade** sequence:
   - **Publish/install:** `packages/portfolio-deploy/scripts/ymax-deploy-target.ts` `phase-pre-upgrade` → `install-bundle.ts` → `installBundle(...)` (`@agoric/client-utils`, `bundle-utils.ts`) → `MsgInstallBundle` (chunked via `MsgSendChunk` for large bundles), confirmed on the `:bundles` vstorage path. Self-contained illustration: `n:upgrade-next/test/chunked-bundle.test.ts`.
   - **Upgrade:** the `g:ymax1` proposal delegates control to a smartWallet (`portfolio-control.core.js` `deliverContractControl`, reaching the live instance kit via `getUpgradeKit`); the control facet's `install(bundleId)`/`upgrade(bundleId)` (`contract-control.contract.js`) does `installBundleID` then `E(kit.adminFacet).upgradeContract(bundleId)`.
2. **Folded into the skill.** Added a new **§ "Installing the bundle first"** section to `skills/agoric-chain-snapshot/SKILL.md` mapping each on-chain step onto its inquisitor offline equivalent (`bundleStore.addBundle` = "installed first"; bridge-action upgrade = the peer's lane), plus the deploy-tool refinement and the release-asset provenance of the failing bundle. Updated the CLAUDE.md inventory clause. Two commits pushed to `main2` (`efe8b685c`).
3. **Replied on #9** (acknowledged-comment → reply, per feedback discipline) as kriscendobot — comment `4848745648`, scoped to the install/publish half, referencing (not restating) the peer's bridge-injection/kit-reachability findings.
4. **Coordinated with the peer** (`garden-issue-9-mhofman-contract-kit-and-inquisitor-bridge`) via the bus to fix the division of labor and avoid double-posting; relayed that my half is up so they can post theirs.

**Key finding resolved:** the live admin facet IS reachable (via `getUpgradeKit`/the contract-control kit, not the stale bootstrap `ymax0Kit`/v275), confirming mhofman.

**Follow-up (the one remaining blocker, not mine to close):** the over-threshold devnet "v320" `bundle-ymax0.json` is a **release asset** (per the peer's handoff — fetched by `ymax-deploy-target.ts` via `gh release download`), *not* in the mainnet snapshot. Fetching it and `addBundle`-ing it is the last prerequisite to run the faithful contract-control upgrade overflow on real mainnet state; the `createVat` import vector remains the runnable cross-check meanwhile. All work stayed on bot forks + the local snapshot; no upstream `agoric/agoric-sdk` contact.
