Coordination complete — the peer posted their install/publish half (4848745648) and folded § "Installing the bundle first" into the skill; I posted my half (4848749574); no double-post. My SKILL push (fe04e9590) and theirs both landed on main2. Inbox clear, no open actions. All deliverables done.

---

## Completion report

**Job:** Incorporate mhofman's #9 guidance (contract-kit reachability + Inquisitor bridge-action injection) and reply.

**What I did** — advanced the mainnet ymax0/ymax1 contract-control-upgrade repro against the cached `agoric-26146641` snapshot in the standing `kriscendobot/agoric-sdk` build worktree, addressing each of mhofman's four points, then replied on #9.

**Findings (all empirically grounded):**
1. **Kits *are* reachable (mhofman correct).** `ymax0Kit` is at `v1.vs.vc.5.symax0Kit`; `adminFacet`/`creatorFacet`/`instance` resolve (owned by Zoe `v9`). The nuance: that bootstrap kit's `adminFacet` drives the **original, terminated** instance (`v275`, gone), not the live deployment.
2. **Live control was delegated to the smart wallet, and it's in the snapshot.** `delegatePortfolioContract` delivers a `ContractControl` (built from the live `UpgradeKit`) to the control account's wallet — present at `v43.vs.vc.1144877.symaxControl` (ymax0) / `v43.vs.vc.1146656.symaxControl` (ymax1). Control accounts (hardcoded in `portfolio-constants.js`, key `ymaxControl`): ymax0-main `agoric1e80twfu…`, ymax1-main `agoric18dx5f8…`. `ContractControl.upgrade()` internally calls `E(liveKit.adminFacet).upgradeContract(...)` → live `v290`/`v288`.
3. **Bridge-action injection works.** inquisitor's `pushQueueRecord`+`runNextBlock` accepts a hand-marshalled **zero-slot** `WALLET_ACTION`/`invokeEntry`(`targetName:'ymaxControl'`, `method:'upgrade'`) and cranks the block (443 deliveries). Two precise gaps surfaced: the inbound **WALLET** bridge isn't wired in the overlay (no wallet invocation record — only the `CORE` bridge `runCoreEval` uses is), and an **EV-direct shortcut** exists (the `ContractControl` is owned by `v1`/bootstrap, krefs `ko25961078`/`ko25964180`, so `EV(kslot(kref)).upgrade(...)` hits it directly — with a send-then-`controller.run()` pattern, not `await`-then-run, which deadlocks).
4. **Deployment specifics** taken from `portfolio-deploy` tooling (`ymax-deploy-target.ts`, `ymax-release-policy.mjs`): targets on `agoricdev-25`/`agoric-3`; the failing bundle is the release-asset `bundle-ymax0.json`.

**The one remaining input:** the over-threshold devnet-"v320" bundle. Every ymax bundle currently *on* the snapshot imports clean (3–5 flatMaps, below the 4096-slot threshold) — exactly what mhofman's "bundle is instance-agnostic, just install it first" resolves: `addBundle` the over-threshold release bundle, then the injection reproduces exit-12.

**Changes:**
- `skills/agoric-chain-snapshot/SKILL.md` → main2 (`fe04e9590`): the delegated contract-control finding, control addresses, the invokeEntry injection + WALLET-inbound caveat + EV-direct path + driver-pattern caveat, and the corrected remaining-input (over-threshold release bundle).
- New repro drivers in the build worktree: `repro/repro-control-upgrade-driver.mjs`, `repro/repro-cc-direct-driver.mjs`, plus snapshot-archaeology scripts (`find-control-facet`, `find-ymaxcontrol`, `find-cc-kref`).
- Posted reply to mhofman on **kriskowal/garden#9** (comment `4848749574`).

**Coordination:** a peer (`…-mainnet-validation-tree-bundle-publish`) owned the install/publish half (mhofman #1 + kriskowal's validation-tree pointer); we divided cleanly and avoided a double-post — they posted `4848745648` referencing my bridge work; I posted the kit-reachability + bridge-injection half.

**Follow-ups (for whoever lands the exit-12 repro):**
1. Obtain the over-threshold devnet `bundle-ymax0.json` (release asset) — the last prerequisite.
2. Either wire the inbound **WALLET** bridge handler in the inquisitor overlay (for the wallet-envelope-faithful run) or use the **EV-direct** `ContractControl.upgrade` with the send-then-crank pattern.
