---
source: packages/governance/README.md
source_repo: agoric/agoric-sdk
source_commit: 92fa9a262b1b190d8535f826197a5df0c1ba9958
source_date: 2023-04-20
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
section_count: 6
status: current
notes: Governance is agoric-sdk's contract-governance framework — Electorates + VoteCounters + ElectionManagers (of which ContractGovernor is one). Cross-cuts with inter-protocol (Economic_Committee votes on VaultFactory parameters under `published.committees.Economic_Committee.*`), zoe (governed contracts publish governance state via Zoe `terms` + `publicFacet`), and capability-security (the powerful private facet pattern: governed contract keeps its powerful creatorFacet hidden, exposes only the governor-mediated voteOnParamChange / voteOnApiInvocation / voteOnOfferFilter). The README is from 2023-04-20; some terminology may have evolved.
---

> Abstract: Contract-governance framework for agoric-sdk. Three abstraction layers: **Electorate** (a set of voters, with each voter receiving a voterFacet invitation); **VoteCounter** (one instance per question; supports majority / approval / proportional / quadratic / IRV etc.); **ElectionManager** (mediates a particular Electorate's process). **ContractGovernor** is the canonical ElectionManager: governs parameters, API invocations, and offer-filter blocking on a contract. Six sections: (1) overview — Electorate-VoteCounter-ElectionManager architecture; (2) Electorate — voterFacet + submitVote per-voter discipline; (3) ContractGovernor — the legibility story + ParamManager + Governing APIs + Governed Contracts; (4) Scenarios — examining a contract before use + participating in governance; (5) Future Extensions — additional electorates / vote counters / managers planned; (6) Reading data off-chain — committee questions published under `published.committee.questions` / `published.committees.Economic_Committee.*`.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/agoric-sdk--pkg-governance-readme--overview.md) | capability-security, exo | current |
| [electorate](../sections/agoric-sdk--pkg-governance-readme--electorate.md) | capability-security | current |
| [contract-governor](../sections/agoric-sdk--pkg-governance-readme--contract-governor.md) | capability-security, exo, patterns | current |
| [scenarios](../sections/agoric-sdk--pkg-governance-readme--scenarios.md) | capability-security | current |
| [future-extensions](../sections/agoric-sdk--pkg-governance-readme--future-extensions.md) | capability-security | current |
| [reading-data-off-chain](../sections/agoric-sdk--pkg-governance-readme--reading-data-off-chain.md) | tooling | current |

## Cross-references

- The `published.committees.Economic_Committee.{latestQuestion, latestOutcome}` keys appear in `agoric-sdk--pkg-inter-protocol-readme--reading-data-off-chain`; governance is the publisher.
- The "powerful private facet" pattern (governor holds the change-power, contract keeps the read-only-facet visible) is the canonical capability-discipline answer to "how do voters verify what they're voting on without holding the power."
- ParamManager's `makeParamManager(zoe)` vs `makeParamManagerSync()` echoes the synchronous-makers discussion in `agoric-sdk--pkg-vat-data-readme--tips-synchronous-makers`.

## Source

[packages/governance/README.md](https://github.com/Agoric/agoric-sdk/blob/92fa9a262b1b190d8535f826197a5df0c1ba9958/packages/governance/README.md) at commit `92fa9a26`.
