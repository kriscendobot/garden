---
title: Inter Protocol (overview — IST / VaultFactory / VaultManager / Vault)
source: packages/inter-protocol/README.md
source_repo: agoric/agoric-sdk
source_commit: 52f5366444ac021998ced6afc3a7d67c832ccdb0
source_date: 2024-06-11
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security, exo]
status: current
notes: The "by convention one well-known VaultFactory" + "by governance one VaultManager per collateral type" naming hierarchy is the canonical mental model for the protocol. Liquidation is triggered by the VaultManager (not the Vault itself) on a governed threshold; this is the capability-discipline answer to "who can liquidate me?" — only the manager that issued me, only via governed rules.
---

> Abstract: IST is the Agoric economy's stable token. **VaultFactory** is the well-known singleton (one per protocol instance, by convention). **VaultManager** is created by governance, one per collateral asset type. **Vault** is created by anyone who puts up collateral with the appropriate VaultManager — then can request IST backed by that collateral. Liquidation: when the debt:collateral ratio exceeds the governed threshold, the VaultManager performs a price check; if undercollateralized, it liquidates the vault.

# Inter protocol

## Overview

IST is a stable token that enables the core of the Agoric economy.

By convention there is one well-known **VaultFactory**. By governance it creates a **VaultManager** for each type of asset that can serve as collateral to mint IST.

Anyone can make a **Vault** by putting up collateral with the appropriate VaultManager. Then they can request IST that is backed by that collateral.

In any vault, when the ratio of the debt to the collateral exceeds a governed threshold, it is deemed undercollateralized. If the result of a price check shows that a vault is undercollateralized, the VaultManager liquidates it.

Source: [packages/inter-protocol/README.md](https://github.com/Agoric/agoric-sdk/blob/52f5366444ac021998ced6afc3a7d67c832ccdb0/packages/inter-protocol/README.md) at commit `52f53664`.
