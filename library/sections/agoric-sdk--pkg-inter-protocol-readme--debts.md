---
title: Debts (µIST + virtualized debt for O(1) interest accrual)
source: packages/inter-protocol/README.md
source_repo: agoric/agoric-sdk
source_commit: 52f5366444ac021998ced6afc3a7d67c832ccdb0
source_date: 2024-06-11
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security]
status: current
notes: The virtualized-debt design is a clever O(1) algorithm for what would naively be O(n) per interest-charging period. The "normalized collateralization ratio" key is also load-bearing for liquidation ordering — keys must be time-independent so they don't change as interest accrues. Whoever implements liquidation needs to understand both pieces.
---

> Abstract: Debts are denominated in **µIST** (1 million µIST = 1 IST). Each interest charging period (e.g., daily) the actual debts in all vaults would naively need to be updated — O(n) writes. **Virtualization** makes interest charging O(1): a `compoundedInterest` value on the manager tracks accrual since launch, and a `debtSnapshot` on the vault lets the actual debt be computed on demand. **Normalized collateralization ratio**: vault keys for liquidation ordering must be time-independent, so they're stored as "actual collateral / normalized debt" rather than "actual collateral / actual debt" (which would change as interest accrues).

## Debts

Debts are denominated in µIST. (1 million µIST = 1 IST)

Each interest charging period (say daily) the actual debts in all vaults are affected. Materializing that across all vaults would be O(n) writes. Instead, to make charging interest O(1) we virtualize the debt that a vault owes to be a function of stable vault attributes and values that change in the vault manager when it charges interest. Specifically,
- a compoundedInterest value on the manager that keeps track of interest accrual since its launch
- a debtSnapshot on the vault by which one can calculate the actual debt

To maintain that the keys of vaults to liquidate are stable requires that its keys are also time-independent so they're recorded as a "normalized collateralization ratio", with the actual collateral divided by the normalized debt.

Source: [packages/inter-protocol/README.md](https://github.com/Agoric/agoric-sdk/blob/52f5366444ac021998ced6afc3a7d67c832ccdb0/packages/inter-protocol/README.md) at commit `52f53664`.
