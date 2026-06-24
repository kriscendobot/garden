---
source: packages/smart-wallet/README.md
source_repo: agoric/agoric-sdk
source_commit: 2e7e93fb6e84caf203dcb62c1290437b3418836b
source_date: 2022-09-13
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
section_count: 4
status: current
notes: This README is older (2022-09-13) and carries explicit `???` placeholders. The Design section points at `src/AttackersGuide.md` for security requirements (not yet ingested). The Testing section openly admits there are no automated tests for the on-chain smart wallet. Flag for staleness review when the chain-test situation changes.
---

> Abstract: The smart wallet — `walletFactory` provisions and manages user wallets. Four sections: usage (Address ↔ Bank ↔ Wallet 1:1:1 provisioning sequence with open `???` questions about double-provisioning behavior), design (capability and Cosmos-signed dual-channel requirement; explicitly NON-requirement: multiple purses per brand; pointer to AttackersGuide.md for security), notifiers section (manual tab-based testing procedure for on-chain notifiers), and the underlying frame.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/agoric-sdk--pkg-smart-wallet-readme--overview.md) | capability-security, exo | current |
| [usage](../sections/agoric-sdk--pkg-smart-wallet-readme--usage.md) | capability-security | current |
| [design](../sections/agoric-sdk--pkg-smart-wallet-readme--design.md) | capability-security | current |
| [notifiers](../sections/agoric-sdk--pkg-smart-wallet-readme--notifiers.md) | testing, tooling | current |

## Source

[packages/smart-wallet/README.md](https://github.com/Agoric/agoric-sdk/blob/2e7e93fb6e84caf203dcb62c1290437b3418836b/packages/smart-wallet/README.md) at commit `2e7e93fb`.
