---
title: Future Extensions (Electorates / VoteCounters / ElectionManager)
source: packages/governance/README.md
source_repo: agoric/agoric-sdk
source_commit: 92fa9a262b1b190d8535f826197a5df0c1ba9958
source_date: 2023-04-20
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security]
status: current
notes: This section is forward-looking from the README's 2023-04-20 commit. Some of these extensions may have landed since; flag for staleness check. The BinaryVoteCounter's "no change is the default" rule is the safety story for parameter-change votes.
---

> Abstract: Forward-looking architecture intentions. **Electorates**: today only a Committee electorate (opaque group of voters) exists. Plausible future: a public-vote-result electorate that gives voting facets to election winners (would require some kind of public registration of candidates). **VoteCounters**: today only `BinaryVoteCounter` (presumes two positions; assigns votes; declares majority winner; configurable default outcome — ContractGovernance uses this for "no change is default"). Future: multi-candidate counters, IRV (instant runoff), proportional representation. **ElectionManager**: a role rather than an API. The current example is ContractGovernor (manages contract-parameter changes). Future managers: take a specific action (e.g., add a new AMM collateral type) when a vote passes; run a plebiscite among stakeholders.

## Future Extensions

The architecture is intended to support several scenarios that haven't been filled in yet.

### Electorates

The initial Electorate represents a Committee, with has an opaque group of voters. The contract makes no attempt to make the voters legible to others. This might be useful for a private group making a decision, or a case where a dictator has the ability to appoint a committee that will make decisions.

Another plausible electorate would use the result of a public vote to give voting facets to the election winners. There would have to be some kind of public registration of the identities of the candidates to make them visible.

### VoteCounters

The only vote counter currently is the BinaryVoteCounter, which presumes there are two positions on the ballot and assigns every vote to one or the other or to 'spoiled'. At the end, it looks for a majority winner and announces that. It can be configured to have one of the possible outcomes as the default outcome. If there's a tie and no default, the winner is `undefined`.

ContractGovernance uses this to make 'no change' be the default when voting on parameter changes.

We should have voteCounters for multiple candidate questions. I hope we'll eventually have IRV (instant runoff) and various forms of proportional representation.

### ElectionManager

The election manager has a role in governance, but not a specific API. The manager's role is to make the setup of particular elections legible to voters and other observers. The current example is the ContractGovernor, which manages changes to contract parameters. There should also be managers that

* take some action (i.e. add a new collateral type to the AMM) when a vote passes.
* manage a plebiscite among stake holders to allow participants to express opinions about the future of the chain.

Source: [packages/governance/README.md](https://github.com/Agoric/agoric-sdk/blob/92fa9a262b1b190d8535f826197a5df0c1ba9958/packages/governance/README.md) at commit `92fa9a26`.
