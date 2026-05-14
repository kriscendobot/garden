---
title: Usage (Address ↔ Bank ↔ Wallet 1:1:1)
source: packages/smart-wallet/README.md
source_repo: agoric/agoric-sdk
source_commit: 2e7e93fb6e84caf203dcb62c1290437b3418836b
source_date: 2022-09-13
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security]
status: current
notes: The doc carries `???` placeholders about double-provisioning behavior at both steps 2 and 3 — these are unresolved design questions, not just documentation gaps. `namesByAddress` and `board` are global; `myAddressNamesAdmin` is per-account-provisioned.
---

> Abstract: The provisioning sequence: (1) generate an address off-chain; (2) provision an account using that address — creates a Bank as a side effect; (3) create a Wallet using the Bank, which includes Virtual Purses that translate `getAmount` calls down to the Golang layer. Per-address invariant: 0 or 1 wallets per Cosmos address. There's a 1:1:1:1 relationship across Address ↔ Bank ↔ `myAddressNamesAdmin` ↔ Wallet. `namesByAddress` and `board` are shared globally. Two unresolved `???` questions in the doc: double-provisioning an address (probably a Cosmos transaction failure), double-wallet-creation from a bank (unspecified).

## Usage

There can be zero or one wallets per Cosmos address.

1. Generate an address (off-chain)
2. Provision an account using that address, which causes a Bank to get created
   ??? What happens if you try to provision again using the same address? It's a Cosmos level transaction; maybe that fails.
3. Create a Wallet using the Bank (it includes the implementation of Virtual Purses so when you getAmount it goes down to the Golang layer)
   ??? What happens if you try to create another wallet using that bank?

1 Address : 0/1 Bank
1 Address : 1 `myAddressNamesAdmin`
1 Bank : 0/1 Wallet

By design there's a 1:1 across all four.

`namesByAddress` and `board` are shared by everybody.

`myAddressNamesAdmin` is from the account you provision.

Source: [packages/smart-wallet/README.md](https://github.com/Agoric/agoric-sdk/blob/2e7e93fb6e84caf203dcb62c1290437b3418836b/packages/smart-wallet/README.md) at commit `2e7e93fb`.
