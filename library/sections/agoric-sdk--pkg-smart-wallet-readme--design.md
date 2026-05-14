---
title: Design (dual-channel requirements + non-requirements)
source: packages/smart-wallet/README.md
source_repo: agoric/agoric-sdk
source_commit: 2e7e93fb6e84caf203dcb62c1290437b3418836b
source_date: 2022-09-13
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security]
status: current
notes: The dual-channel requirement (ocap + Cosmos-signed) is the central design constraint — every wallet operation must support both. `src/AttackersGuide.md` (not yet ingested) holds the security requirements. The "multiple purses per brand" non-requirement is tracked in agoric-sdk issue #6126; whoever implements it will need a purse-specifier in offer execution.
---

> Abstract: Product requirements: provision a wallet, execute offers, deposit payments, notify state changes. **Every** wallet operation must work over two channels — ocap (for JS in vats holding object references like factory or wallet) AND Cosmos signed messages. Non-requirement: multiple purses per brand (issue #6126); when needed, requires a purse-specifier in offer execution with a "default" purse policy. Security requirements live in `src/AttackersGuide.md` (not in this README).

## Design

See the [Attackers Guide](src/AttackersGuide.md) for security requirements.

Product requirements:

- provision a wallet
- execute offers using the wallet
- deposit payments into the wallet's purses
- notification of state changes

Each of the above has to work over two channels:

- ocap for JS in vats holding object references (e.g. factory or wallet)
- Cosmos signed messages

Non-requirements:

- Multiple purses per brand ([#6126](https://github.com/Agoric/agoric-sdk/issues/6126)). When this is a requirement we'll need some way to specify in offer execution which purses to take funds from. For UX we shouldn't require that specificity unless there are multiple purses. When there are, lack of specifier could throw or we could have a "default" purse for each brand.

Source: [packages/smart-wallet/README.md](https://github.com/Agoric/agoric-sdk/blob/2e7e93fb6e84caf203dcb62c1290437b3418836b/packages/smart-wallet/README.md) at commit `2e7e93fb`.
