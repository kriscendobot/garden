---
created: 2026-06-30
updated: 2026-07-03
author: gardener
---

# Skill: agoric-chain-snapshot

Obtain a real Agoric mainnet swing-store and feed it to **inquisitor** to
reproduce, and verify a fix for, a contract-upgrade failure on real chain state.
This is the lever for kriskowal/garden#9: the ymax0 v320 incarnation 70->71
upgrade aborts when the contract bundle is installed, because building the
`@agoric/internal/src/hex.js` `decodings` table with a wide `.flatMap(...)`
materializes ~1,024 live reference slots and tips the XS value stack past its
fixed 4,096-slot budget. The fix replaces that `.flatMap(` with a
`new Map` + `for` + `.set()` loop. Prior work confirmed the fix against the
**stock prebuilt xsnap-worker** (synthetic); this skill is the **real-chain
cross-check** through inquisitor on a captured mainnet swing-store.

All of this stays on the `kriscendobot/agoric-sdk` fork and bot-owned forks.
Nothing here touches upstream `agoric/agoric-sdk`: no comments, no reviews, no
cross-references, no issue/PR opens or closes. See `roles/COMMON.md`
§ External-repo etiquette, *Project scope: agoric/agoric-sdk*.

This is the **reproduction lever** in a larger debugging picture. The engine-level
reading of *why* the value stack overflows (width-not-depth, symbolication, the
targeted `flatMap`->loop versus the coarse taller-`stackCount` remedy) is
[xs-debugging](../xs-debugging/SKILL.md); reading the failure out of the swingset
slog / flight recorder is [slog-debugging](../slog-debugging/SKILL.md). All three
are reached from the fixer's project debugging sub-role
([roles/fixer/subroles/agoric-sdk.md](../../roles/fixer/subroles/agoric-sdk.md)).

## The two capture scripts

- `scripts/agoric/fetch-polkachu-snapshot.sh` — **bot-runnable, no credentials.**
  Pulls a public Polkachu Agoric snapshot (`agoric_<height>.tar.lz4`), extracts
  ONLY the `data/agoric` subtree (the Tendermint databases stream past
  unwritten), reads `host.height`, runs `PRAGMA integrity_check`, and with
  `--vacuum` writes a standalone WAL-free `swingstore.sqlite`. Prefer this.
- `scripts/agoric/fetch-chain-snapshot.sh` — pulls a `data/agoric` swing-store
  off a **follower over ssh**. Needs follower credentials the bot does not have,
  so it is the operator's path, not the bot's.

## Where the cached snapshot lives (check here first)

A snapshot is tens of gigabytes over the wire, so `fetch-polkachu-snapshot.sh`
defaults its output into a **per-host cache directory that is not checked into
git** and survives across jobs:

```
$GARDEN_SNAPSHOT_CACHE
  (default: ${GARDEN_STATE:-$HOME/.garden-state}/cache/agoric-snapshots)
```

laid out one directory per snapshot height: `<cache>/agoric-<height>/`. Inside
each is the extracted `data/agoric/swingstore.sqlite`, the optional vacuumed
`swingstore.sqlite`, and a `provenance.json` sidecar (next section).

This path is under `$GARDEN_STATE` (`$HOME/.garden-state`), which the garden's
`.gitignore` already excludes as a top-level dotfile, so the cache can never
enter tracked history or block a watchman fast-forward. **Before re-pulling from
Polkachu, look here**: if a valid `swingstore.sqlite` for the height is already
present the script reuses it (`--refresh` forces a re-download), and
`--use-cached` reuses the newest cached snapshot with no network resolution at
all. If the cache is empty, that is expected on a fresh host (each host keeps its
own cache); fetch once or socialize a copy from a peer (below).

## Provenance: the metadata sidecar

Beside the cached swing-store the script writes `provenance.json` recording
exactly what the artifact is and when it was acquired:

```json
{
  "schema": "agoric-snapshot-provenance/1",
  "source": "polkachu",
  "source_url": "https://snapshots.polkachu.com/snapshots/agoric/agoric_<height>.tar.lz4",
  "snapshot_height": "<height>",
  "host_height": "<host.height from kvStore>",
  "swingstore_sha256": "<sha256 of swingstore.sqlite>",
  "swingstore_bytes": "<size>",
  "acquired_at": "<UTC ISO timestamp>",
  "acquired_by_host": "<GARDEN identity>",
  "acquired_by_tool": "scripts/agoric/fetch-polkachu-snapshot.sh"
}
```

Read it to confirm a cached artifact's height and age before trusting it. A
chain-tip snapshot is fine for this reproduction (inquisitor injects the bundle
and runs the core-eval against whatever swing-store it is handed; the exact
historical upgrade height is not required), but the sha256 and `acquired_at`
let a later reader tell two captures apart and decide whether to refresh.

## Socializing a copy across hosts (gentler than Polkachu)

The garden runs on multiple hosts and any one host may not hold a given
snapshot. Pulling a copy from a **peer host's cache** is far gentler on Polkachu
than re-streaming tens of gigabytes:

```
scripts/agoric/fetch-polkachu-snapshot.sh --from-host kriscendobot@<peer-host> --vacuum
```

`--from-host` rsyncs the peer's `$GARDEN_SNAPSHOT_CACHE` into this host's cache
(`--ignore-existing`, so a snapshot already held is not reclobbered), then takes
the `--use-cached` path with no Polkachu request. It needs `rsync` and ssh
reachability to the peer (the same path `fetch-chain-snapshot.sh` already
assumes between hosts). If the peer's cache path differs, point at it through
the peer's `$GARDEN_SNAPSHOT_CACHE`. Re-pull from Polkachu only when no peer
holds the snapshot.

## Procedure

1. **Try the cache / a peer first.** `--use-cached` if this host has one;
   `--from-host <peer>` to socialize; only then a fresh Polkachu pull.
2. **Prerequisites for a fresh pull:** `curl`, `lz4`, `tar`, and (for `--vacuum`
   / inspection) `sqlite3`; `rsync` for `--from-host`; `wget` for `--download`.
   On a bare host: `sudo apt-get install -y lz4 sqlite3 rsync wget`.
3. **Capture:**
   ```
   scripts/agoric/fetch-polkachu-snapshot.sh --vacuum
   ```
   The full ~tens-of-GiB stream is downloaded (tar cannot seek a single
   compressed stream); only `data/agoric` lands on disk. `--download` saves a
   resumable archive first so extraction can be retried without re-streaming.
4. **Build inquisitor's host** in a `kriscendobot/agoric-sdk` worktree (vendored
   yarn, immutable install): `node .yarn/releases/yarn-4.12.0.cjs install
   --immutable`. Expect a non-fatal `better-sqlite3` native-build warning and two
   standing `chain-utils.js` cosmic-proto `tsc` errors (sandbox artifacts, not
   regressions) per the `build-agoric-internal-hex` notes.
5. **Build the worker bundles `createVat` needs** (the bare immutable install
   does NOT generate them, and `createVat` fails `ENOENT … .sha256` without them):
   ```
   ( cd packages/xsnap-lockdown && node scripts/build-bundle.js )
   ( cd packages/swingset-xsnap-supervisor && node scripts/build-bundle.js )
   ```
6. **Reproduce + verify the hex fix** against the captured swing-store, via the
   **`createVat` vector** (see *The stale-bootstrap-kit finding* below for why the
   faithful upgrade vector mhofman asked for needs a live-instance admin facet and
   the actual failing bundle, neither of which the snapshot provides, so the
   `createVat` cross-check is the runnable stand-in). Run inquisitor
   non-interactively, piping a driver that `addBundle`s
   the v320 bundle and creates a fresh vat from it so a real on-chain worker
   imports it:
   ```
   BUNDLE_JSON=/path/to/<control|patched>-bundle.json RUN_LABEL=<label> \
   INQUISITOR_NO_REPL=1 node packages/cosmic-swingset/tools/inquisitor.mjs \
     <cache>/agoric-<height>/swingstore.sqlite < repro-driver.mjs
   ```
   The driver's core-eval (note: use the **global** `E`, not `powers.E`, and avoid
   the literal `import (` token anywhere in the eval string — SES rejects it):
   ```js
   await runCoreEval(`async powers => {
     const vas = await powers.consume.vatAdminSvc;
     const bc = await E(vas).getBundleCap(${'`'}b1-${'${bundle.endoZipBase64Sha512}'}${'`'});
     await E(vas).createVat(bc, { name: 'ymax0repro' });   // imports the bundle
   }`);
   ```
   - **Control** (stock real v320 `bundle-ymax0`) → `Vat Creation Error: Stack
     meter exceeded` — the XS value stack is exhausted **during** the bundle
     import (this metered worker's rendering of the chain's `exited: stack
     overflow`, exit 12).
   - **Patched** (the `flatMap`->loop `hex.js`, bot fork PR #7 / the
     `debug/xs-stack-overflow-methodology` branch) → the bundle imports cleanly
     and fails only at the benign post-import `vat source bundle lacks
     buildRootObject()` check (a raw contract bundle has no `buildRootObject`),
     proving module evaluation got **past** the overflow.
   The patched/control delta is exactly one `.flatMap(` removed (10->9) in the
   flattened `portfolio.contract.bundle.js` — the `@agoric/internal/src/hex.js`
   `decodings = new Map(encodings.flatMap(...))` rewritten to a `new Map` + `for`
   + `.set()` loop. Verified on `agoric-26146641` (2026-06-30, kriskowal/garden#9
   [comment](https://github.com/kriskowal/garden/issues/9#issuecomment-4848214817)).

## Installing the bundle first: the mainnet-validation-tree publishing examples

mhofman's correction (2026-06-30,
[comment](https://github.com/kriskowal/garden/issues/9#issuecomment-4848584090))
is that **the bundle is network- and instance-agnostic; it just needs to be
installed first**, and the faithful test is an **upgrade of the live deployment
as a contract-control message**, not a fresh deploy. kriskowal then pointed at
the **examples for publishing a bundle to chain in the mainnet validation tree**
([comment](https://github.com/kriskowal/garden/issues/9#issuecomment-4848697844)).
The "mainnet validation tree" is agoric-sdk's **`a3p-integration/`** tree (the
agoric-3-proposals integration that validates upgrades against agoric-3 =
mainnet). Those examples give the full **publish → install → contract-control
upgrade** sequence, of which "install first" is the opening step. The references,
all on the read-only `kriscendobot/agoric-sdk` checkout:

1. **Publish the bundle to chain (the bundle-publishing example).** Two grades of
   example exist. The **deploy tool** is the faithful one:
   `packages/portfolio-deploy/scripts/ymax-deploy-target.ts` runs the real
   mainnet deploy in two phases — `phase-pre-upgrade` (which installs/publishes
   the bundle via `recordBundleInstall` → `packages/portfolio-deploy/scripts/
   install-bundle.ts`) and `phase-upgrade` (the contract-control upgrade in
   step 3). `install-bundle.ts` gzips the bundle JSON, calls
   `installBundle(...)` from `@agoric/client-utils`, signs and broadcasts, then
   **watches the `:bundles` vstorage path for `installed === true`** to confirm
   the bytes landed. The smaller, self-contained illustration of the same helper
   is `a3p-integration/proposals/n:upgrade-next/test/chunked-bundle.test.ts`,
   which drives `installBundle({ bundleJson, chunkSizeLimit, submitter, gzip,
   sha512, signAndBroadcast })` directly. The helper
   (`packages/client-utils/src/bundle-utils.ts`) builds a `MsgInstallBundle`
   (small bundles ride inline as a gzipped `compressedBundle`; large ones are
   split into `MsgSendChunk` messages keyed by a `chunkedArtifact` sha512
   manifest, then finalized by `MsgInstallBundle`). A `MsgInstallBundle`
   transaction is precisely "publish the bundle bytes to chain"; it is what makes
   the bundle's `b1-…` id resolvable so a later `installBundleID` can find it.
   **Where the bundle comes from:** `ymax-deploy-target.ts` fetches it as a
   **release asset** (`bundle-ymax0.json` / `bundle-ymax1.json`) from the
   agoric-sdk release page via `gh release download <tag> --pattern …`, per
   mhofman's pointer that the release page carries the prior ymax0/ymax1
   deployment info. The **over-threshold (devnet "v320") `bundle-ymax0.json`**
   that actually overflows is one of these release assets — it is *not* present in
   the mainnet snapshot (every on-chain ymax bundle there imports clean), so the
   faithful upgrade repro depends on fetching that release asset.
2. **Delegate contract control to a smartWallet (the a3p ymax proposals).**
   `a3p-integration/proposals/g:ymax1` (README: *"doesn't deploy a new ymax
   contract; rather creates a contract control delegating upgrade etc. to an
   Agoric Opco smartWallet … also updates the ymax0 (alpha) contract control
   instance"*) runs the core eval
   `packages/portfolio-deploy/src/portfolio-control.core.js`
   (`delegatePortfolioContract`). That eval reaches the **live** instance kit via
   `consume.getUpgradeKit(contractName)` (falling back to the promise-space
   `${contractName}Kit`) and calls `deliverContractControl({ name,
   controlAddress, initialPrivateArgs, kit })`. The a3p driver
   `g:ymax1/ymax-util.js` (`submitYmaxControl`) submits the
   `eval-<name>-control.js` + permit pair through
   `agd tx gov submit-proposal swingset-core-eval`.
3. **Redeem control + trigger the upgrade (the smartWallet `invokeEntry` path).**
   `g:ymax1/use-invitation.js` → `ymax-util.js redeemInvitation` sends a
   smart-wallet `executeOffer` bridge action to the ymaxControl address — the
   normal contract-control trigger mhofman named. The control facet itself
   (`packages/deploy-script-support/src/control/contract-control.contract.js`)
   exposes `install(bundleId)` → `E(zoe).installBundleID(bundleId)` and
   `upgrade(bundleId)` → `E(kit.adminFacet).upgradeContract(bundleId,
   privateArgs)`. Because `kit.adminFacet` here is the **live** instance's admin
   facet (obtained via `getUpgradeKit`/`deliverContractControl`), this is the path
   that reaches v290/v288 — *not* the stale bootstrap `ymax0Kit` (v275). It also
   answers mhofman's surprise that "the contract kits should still be available in
   bootstrap space": they are, but via the `getUpgradeKit` power and the
   contract-control kit, not the raw promise-space `${name}Kit`.

   The **operations** counterpart of the same `upgrade(bundleId)` path (useful for
   the concrete ymaxControl addresses and a non-a3p driver) is the ymax-ops tree:
   `multichain-testing/ymax-ops/` (`Makefile`, `deploy-design-releases.md`) drives
   `packages/portfolio-deploy/scripts/{install-bundle,ymax-upgrade,wallet-admin}.ts`;
   `ymax-upgrade.ts` fetches the `ContractControl` handle from the deployer's
   smart-wallet store (`WALLET_KEY` = `YMAX_CONTROL_WALLET_KEY`) and calls
   `ymaxControl.upgrade({ bundleId, privateArgsOverrides })` over `sendBridgeAction`.
   The Makefile pins the ymaxControl smart-wallet address per target, which is the
   `controlAddress` the injected bridge action must originate from:

   | target | ymaxControl smart-wallet address |
   | --- | --- |
   | ymax0-main | `agoric1e80twfutmrm3wrk3fysjcnef4j82mq8dn6nmcq` |
   | ymax0-devnet | `agoric10utru593dspjwfewcgdak8lvp9tkz0xttvcnxv` |
   | ymax1-main | `agoric18dx5f8ck5xy2dgkgeyp2w478dztxv3z2mnz928` |

**Mapping the sequence onto the inquisitor offline repro.** inquisitor drives a
captured swing-store, not a live chain, so each on-chain step has an offline
equivalent:

- Step 1 (publish `MsgInstallBundle`) → seed the bundle bytes into the snapshot's
  bundle store: `await swingStore.kernelStorage.bundleStore.addBundle(bundleID,
  bundle)` (already in § Procedure). This is the literal "installed first"
  prerequisite — without it `installBundleID(bundleId)` cannot resolve the bundle.
- Steps 2–3 (deliver control + `executeOffer` upgrade) → inject a bridge action
  through inquisitor that drives the contract-control `upgrade(bundleId)` against
  the live v290/v288 admin facet reached through `getUpgradeKit` (the
  inquisitor-bridge half of #9; the
  `garden-issue-9-mhofman-contract-kit-and-inquisitor-bridge` lane). The bundleID
  it references is the one seeded in step 1.

So the contract-control upgrade vector now has a complete, example-grounded
prerequisite: **publish/seed the bundle, then invoke `upgrade(bundleId)` on the
live instance's contract-control facet.** This also retires missing-input (2) in
the note below — the live admin facet *is* reachable (via `getUpgradeKit`/the
contract-control kit).

**Missing-input (1) is now RESOLVED (2026-07-01, kriskowal/garden#9).** The
over-threshold (devnet "v320") `bundle-ymax0.json` is a **downloadable release
asset** on the agoric-sdk `ymax-v0.3.2606-beta3` release (866,401 bytes;
`gh release download ymax-v0.3.2606-beta3 --repo agoric/agoric-sdk --pattern
bundle-ymax0.json`). It flattens to **10 `.flatMap(`** call sites (the on-chain
mainnet bundles flatten to only 3–5 and import clean), including the `hex.js`
`decodings = new Map(RI.flatMap(...))` table. With that asset in hand the
reproduce+validate was run on `agoric-26146641` through the `createVat` import
vector below:

- **Control** (stock beta3 `bundle-ymax0.json`, bundleID `b1-7b73897d…`) →
  `Vat Creation Error: Error: Stack meter exceeded` — the XS value stack
  overflows **during** the bundle import.
- **Patched** (one `.flatMap(` removed, 10→9: the `hex.js` decodings table
  rewritten to a `new Map` + bounded `for` + `.set()` loop; module `sha512` and
  the `compartment-map.json` entry updated, re-zipped via `@endo/zip`,
  bundleID `b1-6648cdf3…`) → `Vat Creation Error: Error: vat source bundle lacks
  buildRootObject() function` — the module **imported and evaluated cleanly**,
  reaching the benign post-import check (a raw contract bundle has no
  `buildRootObject`), i.e. it got **past** the overflow point.

The single-`.flatMap(` delta flips the outcome from overflow to clean import on
real mainnet swing-store state through a real on-chain XS worker. This is the
first run with the genuine over-threshold release asset (prior rounds had the
bundle wiped or used the `createVat` stand-in without it). The still-more-faithful
EV-direct contract-control upgrade vector (`upgrade(bundleId)` on
`kslot('ko25961078')`, the live ymax0 `ContractControl`, verified present and
v1-owned on this snapshot) remains subject to the documented overlay
wallet-bridge caveat, so the `createVat` A/B above is the decisive cross-check.

## Notes

- **The stale-bootstrap-kit finding (why `ymax0Kit.adminFacet` is the wrong
  upgrade target), corrected per mhofman (2026-06-30,
  [comment](https://github.com/kriskowal/garden/issues/9#issuecomment-4848426883)).**
  The original failure was a **devnet** upgrade of ymax0 (vat `v320` there).
  No devnet snapshot is available, but mainnet is believed to reproduce, and the
  faithful test is an **upgrade of the live mainnet deployment** as a
  contract-control upgrade message. On `agoric-26146641` the **live** instances
  are **ymax0 = v290** (`zcf-b1-68c494…`) and **ymax1 = v288** (`zcf-b1-61c340…`),
  both present and non-terminated (`vats.terminated` is empty). Crucially, the
  only ymax0 admin facet reachable from the bootstrap promise space
  (`ymax0Kit.adminFacet`, held by Zoe / `v9`) belongs to the **original, now-gone**
  ymax0 instance, vat `v275` (`v275.options` absent, not in `vat.dynamicIDs`), so
  `E(ymax0Kit.adminFacet).upgradeContract(...)` fails *before any worker spins up*
  with `vatAdminService rejecting attempt to perform "upgrade"() on non-running
  vat "v275"`. The live v290/v288 instances carry separate admin facets that Zoe
  holds privately per instance, not exposed in any **promise-space** kit on the
  snapshot; reaching them is the real contract-control upgrade path. The driver
  for this (now-superseded) promise-space vector is committed as
  `repro/repro-upgrade-driver.mjs`.
- **The delegated contract-control finding (the faithful upgrade path mhofman
  pointed to), per mhofman 2026-06-30 ([comment](https://github.com/kriskowal/garden/issues/9#issuecomment-4848598136)).**
  mhofman was right that the contract *kits* are reachable from bootstrap space —
  `ymax0Kit` is present at `v1.vs.vc.5.symax0Kit` and its `adminFacet`/`creatorFacet`/
  `instance` all resolve (owned by Zoe, `v9`). The catch is only that *that*
  bootstrap kit's `adminFacet` drives the **original, now-terminated** instance
  (vat `v275`); the live deployment's control was **delegated** out of the
  promise space by the `delegatePortfolioContract` core-eval
  (`packages/portfolio-deploy/src/portfolio-control.core.js`), which builds a
  `ContractControl` (`@agoric/deploy-script-support/src/control/contract-control.contract.js`)
  from the **live** instance's `UpgradeKit` and **delivers it to a smart wallet**.
  That control object is present in the snapshot, saved in the control account's
  wallet store (`v43.vs.vc.1144877.symaxControl` for ymax0 and
  `v43.vs.vc.1146656.symaxControl` for ymax1, each → an `Alleged: ContractControl`).
  The control accounts are hardcoded in
  `@agoric/portfolio-api/src/portfolio-constants.js` (`CONTROL_ADDRESSES`,
  `YMAX_CONTROL_WALLET_KEY = 'ymaxControl'`): ymax0-main
  `agoric1e80twfutmrm3wrk3fysjcnef4j82mq8dn6nmcq`, ymax1-main
  `agoric18dx5f8ck5xy2dgkgeyp2w478dztxv3z2mnz928`. So the live `v290`/`v288`
  admin facet **is** reachable — not via the promise space, but via
  `ContractControl.upgrade({bundleId, privateArgsOverrides})`, which internally is
  `E(liveKit.adminFacet).upgradeContract(bundleId, privateArgs)`.
- **The faithful vector: inject the smart-wallet `invokeEntry` bridge action.**
  inquisitor's `pushQueueRecord` + `runNextBlock` endowments ARE the inbound
  bridge-action injection path. The on-chain trigger for a ymax upgrade is a
  `WALLET_ACTION` from the control account carrying a smallcaps-marshalled
  `{ method: 'invokeEntry', message: { targetName: 'ymaxControl', method: 'upgrade',
  args: [{ bundleId, privateArgsOverrides }] } }`. It routes
  `actionQueue → BridgeId.WALLET → walletFactory.fromBridge → wallet.handleBridgeAction
  → invoke.invokeEntry → myStore.get('ymaxControl').upgrade(...)` → the live
  instance's `adminFacet.upgradeContract` → a fresh XS worker re-imports the
  bundle (where `hex.js` lives). The action carries **zero object slots** (its args
  are pure data), so it is hand-marshalable with `@endo/marshal` and injected
  without any board-resolved remotables. Driver:
  `repro/repro-control-upgrade-driver.mjs`. A run with a valid (below-threshold)
  `bundle-ymax0` is accepted onto the action queue and `runNextBlock` cranks the
  block to completion (controller ran 443 deliveries). **Caveat:** in the overlay
  the inbound `WALLET` bridge did **not** deliver the action to the wallet's
  `handleBridgeAction` — the block cranked routine work (auction/vault
  republishing) but wrote no `published.wallet.<address>` invocation record,
  unlike the `CORE` bridge that `runCoreEval` consumes from bootstrap. Wiring the
  inbound `WALLET` bridge handler (or reviving the control wallet) in the overlay
  is the open tooling step for the wallet-envelope-faithful run.
- **EV-direct shortcut to the same delegated control object (bypasses the wallet
  envelope).** The `ContractControl` objects are owned by `v1` (bootstrap —
  `delegatePortfolioContract` created them there before delivering to the wallet),
  krefs `ko25961078` (ymax0) / `ko25964180` (ymax1). So
  `EV(kslot('ko25961078')).upgrade({ bundleId, privateArgsOverrides: {} })` reaches
  the **same** delegated `ContractControl.upgrade` — and therefore the live `v290`
  `adminFacet.upgradeContract` — without needing the wallet inbound bridge. Driver:
  `repro/repro-cc-direct-driver.mjs`. This is the contract-control-faithful
  upgrade vector (more faithful than `createVat`); the overflow lives far below
  the wallet layer, so the EV-direct trigger exercises the identical failing
  import path. **Driver-pattern caveat:** in scripted `INQUISITOR_NO_REPL` mode
  `EV(...).upgrade(...)` returns a promise that only settles once the controller
  cranks, so `await`-ing it before driving the kernel **deadlocks**. Fire the send
  WITHOUT awaiting, then `await controller.run()` (or `runNextBlock()`) to crank
  the delivery, then read the result — the same shape `runCoreEval` uses
  internally.
- **The OVER-THRESHOLD bundle (formerly the one remaining input) is now in hand
  (2026-07-01) — it is the `ymax-v0.3.2606-beta3` release asset**, exactly what
  mhofman's "the bundle is network/instance-agnostic — it just needs to be
  installed first" pointed at. `gh release download ymax-v0.3.2606-beta3 --repo
  agoric/agoric-sdk --pattern bundle-ymax0.json` fetches it (866 KB, 10
  `.flatMap(` sites, bundleID `b1-7b73897d…`); the reproduce+validate A/B on
  `agoric-26146641` is recorded in § *Installing the bundle first* above (control
  overflows, one-`flatMap`-removed patch imports clean). Every on-chain ymax
  bundle in the snapshot
  (`1cfec/867596/078729/68c494` for ymax0, `61c340` for ymax1) carries the wide
  `hex.js` `flatMap` yet flattens to only 3 to 5 `flatMap`s and imports **clean**
  through a real on-chain worker (the latest, `b1-68c494…` / v290, reaches the
  benign post-import `lacks buildRootObject()` check), so the **current mainnet
  deployment is below the 4096-slot threshold and the over-threshold bundle is not
  in the snapshot.** The failing bundle is the **devnet "v320"** `bundle-ymax0.json`,
  which (per mhofman #4) is a **release asset** on the agoric-sdk release page —
  the deploy tooling fetches it via `gh release download <tag> --pattern
  bundle-ymax0.json` (`packages/portfolio-deploy/scripts/ymax-deploy-target.ts`,
  targets `ymax0-devnet`/`ymax0-main`/`ymax1-main` on `agoricdev-25`/`agoric-3`).
  Once that over-threshold bundle is `addBundle`d, the same
  `repro-control-upgrade-driver.mjs` injection reproduces the XS value-stack
  overflow on the faithful contract-control path. Until then, the runnable
  cross-check is the `vatAdminSvc.createVat(bundleCap)` vector below,
  which routes a high-`flatMap` bundle through the exact same on-chain worker
  import path (`compartmentImportNow` → `execute` → `hex.js` `flatMap`) where the
  overflow lives. That `createVat` vector needed a one-line **inquisitor overlay
  fix**: the
  read-only overlay's `transcriptStore` left `initTranscript` a no-op, so a
  freshly-created vatID hit `no current transcript for "vNN"`; seeding an initial
  `{startPos:0,endPos:0,hash:'<initial>',incarnation:0}` pending span on
  `initTranscript` (and moving it from `logAndMark` to `allow`) lets `createVat`
  run end-to-end against a snapshot. Carried on
  `kriscendobot/agoric-sdk` (`debug/xs-stack-overflow-methodology`).
- **Wire vs disk:** the `data/agoric` filter saves disk, not bandwidth. The
  whole archive still streams over the wire because tar cannot seek a single
  `.tar.lz4`.
- **Residual caveat on the fix:** the loop rewrite drops ~1,024 reference slots
  but leaves the ~2,000-closure flat-functor baseline, so a future module-scope
  widening could re-trip the stock stack. The durable remedy is the
  `bundle-source`/esbuild sub-module-functor lever, not this patch. Recorded on
  the methodology doc (`kriscendobot/agoric-sdk#6`).
- **stackCount vs snapshot compatibility (the taller-stack lever's risk):**
  raising the compile-time value-stack `stackCount` does NOT invalidate existing
  on-chain snapshots. The XS snapshot read path (`fxReadSnapshot` in
  `moddable/xs/sources/xsSnapshot.c`) gates only on `XS_MAJOR_VERSION`,
  `XS_MINOR_VERSION`, the architecture byte (`sizeof(txSlot)`), and a fixed
  signature string (`"xsnap 1"`); `stackCount` is none of these. It is stored in
  the snapshot's own creation atom and the restored machine is allocated from the
  snapshot's creation, not the loader binary's. So a taller binary only enlarges
  FRESH machine creations (a vat upgrade abandons the heap and starts a fresh
  worker, so the upgrade import does pick up the taller stack), while vats
  restored from old snapshots keep their snapshot's size. The remaining risk is
  determinism: a taller binary writes different snapshot bytes (hence hashes), so
  all validators must cut over in lockstep at an agreed upgrade height. The
  inquisitor round (the reproduce-and-verify step above) is the empirical
  confirmation of this: load a
  real pre-upgrade snapshot on a taller-stack worker and confirm no
  signature/version break, and confirm the v320 upgrade is the fresh-machine
  path. Recorded on kriskowal/garden#9 (the slot-accounting reply).
- **Scope:** read-only analysis plus on-host runs of the open-source XS worker
  and the public bundle, on bot forks only. No upstream `agoric/agoric-sdk`
  interaction.

## Contract-control upgrade result (mhofman's #9 protocol, run to completion 2026-07-01)

The full three-step contract-control upgrade protocol was run through inquisitor
against the cached `agoric-26146641` swing-store and posted to kriskowal/garden#9
(comment 4851105447). Reproducible procedure and observed outcomes:

- **Target/driver.** ymax0's delegated `ContractControl` is kref `ko25961078`
  (owner `v1`; `v43.vs.vc.1144877.symaxControl`; ymax1 is `ko25964180`). The live
  ymax0 ZCF vat is `v290` (`zcf-b1-68c494-ymax0`), current incarnation read from
  `swingStore.kernelStorage.transcriptStore.getCurrentSpanBounds('v290').incarnation`
  (was **38**). Drive the upgrade with
  `controller.queueToVatObject(kslot('ko25961078'), 'upgrade', [{ bundleId, privateArgsOverrides:{} }], 'ignore')`
  → the CC calls `E(kit.adminFacet).upgradeContract(bundleId, privateArgs)`.
- **The bundleId is the CONTRACT bundle, not the ZCF vat source.** v290's
  `.source.bundleID` is the ZCF bundle `b1-9cfcc99e…`; the contract bundle it runs
  is `b1-68c494…` (from the vat name). `ContractControl.upgrade({bundleId})` /
  Zoe `upgradeContract(contractBundleId)` expect the **contract** bundle
  (`portfolio.contract`), which ZCF re-imports in a fresh worker (where hex.js
  overflows). Passing the ZCF source bundle is the classic mistake.
- **Observation caveat + the concurrent-observer driver.** The inquisitor overlay
  cannot service the post-upgrade smart-wallet/vstorage traffic, so the full block
  never quiesces and `await EV(cc).upgrade()` (run-utils `queueAndRun`) **hangs**
  (matches the prior "await-then-run deadlocks" note). Instead: enqueue via
  `controller.queueToVatObject` for a kpid, start `controller.run()` **without
  awaiting it**, and poll the overlay incarnation + `controller.kpStatus(kpid)` on
  a `setTimeout` loop. The upgrade delivery cranks in the first ~0s (a new
  incarnation span opens immediately in ALL cases — do NOT read "span opened" as
  success). Driver: committed as `repro/cc-upgrade-driver2.mjs`; run with
  `INQUISITOR_MAX_VATS_ONLINE=50`.
  Note `kunser(controller.kpResolution(kpid))` returns an Error — log
  `err.message`/`err.stack`, never `JSON.stringify(err)` (renders `{}`); call
  `kpResolution` **once** (repeat calls → `refCount underflow`).
- **Success vs failure signal.** SUCCESS = the upgrade-result promise does **not**
  reject and the fresh worker's span reaches the full `[249702,249706)` (clean
  import). FAILURE = the promise **rejects** with `Error: vat-upgrade failure`,
  span truncated at `[249702,249705)`, and the preserved slog carries the
  delivery-level cause `{"#error":"Stack meter exceeded","errorId":"error:liveSlots…"}`
  (swingset's rendering of XS `E_STACK_OVERFLOW`, exit code 12, from
  `manager-subprocess-xsnap.js`). Preserve the slog before inquisitor's
  `shutdown()` removes the testdb: copy the newest
  `/tmp/testdb-*/flight-recorder.bin` and `grep -c 'Stack meter exceeded'`.
- **The three bundles (source-built portfolio.contract repro pair, A/B-validated
  to overflow/clear at stock `stackCount=4096` on inquisitor's own xsnap worker
  via `surface.mjs`, an ad-hoc raw-XS surface probe that ran the `hex.js`
  `decodings` build directly on the worker; it was an ephemeral `/tmp/xs6` helper
  and was not preserved — the committed `repro/cc-upgrade-driver2.mjs` is the
  durable, in-overlay equivalent):**
  - baseline = current on-chain `b1-68c494…` (release `ymax-v0.3.2606-beta2`) →
    upgrade **succeeds**, inc 38→39, clean.
  - beta3 = `b1-2595e4b7…` (`/tmp/xs6/b3src-ctl.zip`, hex.js `flatMap`, 10
    `.flatMap(`) → upgrade **fails**: `Stack meter exceeded` ×30 / exit-12;
    `surface.mjs` on the same worker → `STACK_OVERFLOW {"code":12}`.
  - patched beta3 = `b1-78f80faf…` (`/tmp/xs6/b3src-loop.zip`, `flatMap`→`for`
    loop, 9 `.flatMap(`) → upgrade **succeeds**, inc 38→39, clean, no overflow.
  Build the inquisitor JSON bundle from a zip's base64 with
  `endoZipBase64Sha512 = sha512hex(base64string)`, `bundleID = 'b1-'+sha512`.
