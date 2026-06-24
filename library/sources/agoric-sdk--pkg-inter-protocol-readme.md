---
source: packages/inter-protocol/README.md
source_repo: agoric/agoric-sdk
source_commit: 52f5366444ac021998ced6afc3a7d67c832ccdb0
source_date: 2024-06-11
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
section_count: 5
status: current
notes: The IST/Vaults/VaultFactory/VaultManager architecture is the agoric-sdk's flagship economic application. The "virtualized debt" pattern (compoundedInterest on manager + debtSnapshot on vault) is a non-trivial design — O(1) interest charging instead of O(n). The "normalized collateralization ratio" key is the load-bearing data-structure invariant for liquidation ordering. Cross-cuts with capability-security (multi-facet attenuation around Vaults), zoe (where the contract runs), notifier (StoredPublishKit publishing of metrics), and casting (the off-chain reader).
---

> Abstract: Inter Protocol is the IST-stable-coin core of the Agoric economy. By governance: a singleton **VaultFactory** creates a **VaultManager** per collateral asset type. Anyone makes a **Vault** by putting up collateral and requests IST against it. Liquidation triggers when the debt:collateral ratio exceeds a governed threshold and a price check confirms undercollateralization. Five sections: overview (the IST/Vault/VaultManager hierarchy), Persistence (one-line note: state survives restarts via Agoric collections), Debts (µIST + virtualized debt via compoundedInterest + debtSnapshot for O(1) interest accrual; normalized collateralization ratio for time-independent liquidation keys), Reading data off-chain (StoredPublishKit + the canonical `published.*` key hierarchy: vaultFactory, auction, reserve, priceFeed, psm, committees), Demo (manual three-tab chain + client + REPL procedure).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/agoric-sdk--pkg-inter-protocol-readme--overview.md) | capability-security, exo | current |
| [persistence](../sections/agoric-sdk--pkg-inter-protocol-readme--persistence.md) | capability-security | current |
| [debts](../sections/agoric-sdk--pkg-inter-protocol-readme--debts.md) | capability-security | current |
| [reading-data-off-chain](../sections/agoric-sdk--pkg-inter-protocol-readme--reading-data-off-chain.md) | tooling | current |
| [demo](../sections/agoric-sdk--pkg-inter-protocol-readme--demo.md) | tooling, getting-started | current |

## Cross-references

- The `published.vaultFactory.*` key hierarchy is consumed via `@agoric/casting` (`agoric-sdk--pkg-casting-readme--*`).
- The StoredPublishKit pattern is documented in `agoric-sdk--pkg-zoe-readme--reading-data-off-chain` and built on `agoric-sdk--pkg-notifier-readme--*`.

## Source

[packages/inter-protocol/README.md](https://github.com/Agoric/agoric-sdk/blob/52f5366444ac021998ced6afc3a7d67c832ccdb0/packages/inter-protocol/README.md) at commit `52f53664`.
