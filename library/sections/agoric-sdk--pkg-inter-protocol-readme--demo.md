---
title: Demo (manual three-tab chain + client + REPL procedure)
source: packages/inter-protocol/README.md
source_repo: agoric/agoric-sdk
source_commit: 52f5366444ac021998ced6afc3a7d67c832ccdb0
source_date: 2024-06-11
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [tooling, getting-started]
status: current
notes: The REPL example shows the canonical `agoricNames.lookup` → zoe.getPublicFacet → makeVaultInvitation flow. The `history[-1]` references depend on the REPL's history numbering and won't match between sessions. Demonstrates the brand-equality requirement: `atomBrand` must be the same object reference both to look up the collateral manager and to construct the proposal.
---

> Abstract: The demo procedure spans three terminals. **Tab 1**: chain (`make scenario2-setup scenario2-run-chain-economy`). **Tab 2**: chain ready when "block N commit" appears, then `agd query vstorage keys 'published.vaultFactory'` to list vaultFactory keys, `agoric follow :published.vaultFactory.managers.manager0.metrics` to follow metrics, `make scenario2-run-client` for prompt. **Tab 3** (`agoric open --repl`): scripted REPL session that looks up VaultFactory via agoricNames, gets the public facet from zoe, fetches IST and ATOM brands (required for proposal — both must be same object as the collateral manager expects), constructs a proposal `{give: Collateral, want: IST}`, withdraws ATOM from the wallet's purse, calls `makeVaultInvitation`, calls `zoe.offer(invitation, proposal, payments)`, retrieves `getOfferResult()`.

### Demo

Start the chain in one terminal:

```sh
cd packages/cosmic-swingset
make scenario2-setup scenario2-run-chain-economy
```

Once you see a string like `block 17 commit` then the chain is available. In another terminal,

```sh
# shows keys of the vaultFactory
agd query vstorage keys 'published.vaultFactory'
# lists vaults
agd query vstorage keys 'published.vaultFactory.managers.manager0.vaults'
# follow metrics
agoric follow :published.vaultFactory.managers.manager0.metrics
```

Start a new terminal to get a prompt.

```sh
cd packages/cosmic-swingset/
make scenario2-run-client
```

In yet another,

```
cd packages/cosmic-swingset/t1
agoric open --repl
```

Connect the wallet and use its REPL as follows. Comments are for explanations and can't be parsed by REPL. The history numbers may be different for your shell. `history[-1]` means whatever number the last history output was.

```
# get an instance of the VaultFactory
vaultFactoryInstance = E(home.agoricNames).lookup('instance', 'VaultFactory')
# get its public facet
vaultFactoryPublicFacet = E(home.zoe).getPublicFacet(vaultFactoryInstance)
# get a reference to the minted brand (soon to be IST)
E(home.agoricNames).lookup('brand', 'IST');
stableBrand=history[-1]
# get a reference to the collateral brand
E(home.agoricNames).lookup('brand', 'ATOM')
atomBrand=history[-1]
# get a reference to the collateral manager, using history because the brand must be the same object
collateralManager = E(vaultFactoryPublicFacet).getCollateralManager(atomBrand)
# proposal
proposal = ({
  give: { Collateral: { brand: atomBrand, value: 1000n } },
  want: { IST: { brand: stableBrand, value: 1n } },
})
# get the ATOM purse
E(home.wallet).getPurses()
# get the "ATOM" purse
atomPurse = history[-1][0][1]
# prepare funds
E(atomPurse).withdraw(proposal.give.Collateral)
collateral = history[-1]
# make a vault invitation to the collateral manager
invitation = E(collateralManager).makeVaultInvitation()
# make the offer with invitation, proposal, payments
seat = E(home.zoe).offer(invitation, proposal, { Collateral: collateral})
# get the offer result
E(seat).getOfferResult()
```

Source: [packages/inter-protocol/README.md](https://github.com/Agoric/agoric-sdk/blob/52f5366444ac021998ced6afc3a7d67c832ccdb0/packages/inter-protocol/README.md) at commit `52f53664`.
