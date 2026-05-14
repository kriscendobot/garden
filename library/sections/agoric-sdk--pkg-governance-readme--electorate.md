---
title: Electorate (voterFacet + submitVote per-voter discipline)
source: packages/governance/README.md
source_repo: agoric/agoric-sdk
source_commit: 92fa9a262b1b190d8535f826197a5df0c1ba9958
source_date: 2023-04-20
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security]
status: current
notes: The voterHandle-based capability discipline (submitVote can only be called with the voter's unique voterHandle) is the per-voter access-control story. The Electorate creates a new VoteCounter per question — a fresh capability surface for each vote.
---

> Abstract: An Electorate is a set of voters. Each voter receives an invitation for a voterFacet which allows voting in all elections supported by that electorate. The Electorate starts a fresh VoteCounter instance per question and holds its `creatorFacet`; that facet carries the `submitVote()` method that registers votes with the VoteCounter. The Electorate enforces that `submitVote()` can only be called with the voter's unique voterHandle — the capability discipline that ensures one voter, one ballot.

## Electorate

An Electorate represents a set of voters. Each voter receives an invitation for a voterFacet, which allows voting in all elections supported by that electorate. The Electorate starts a new VoteCounter instance for each separate question, and gets the `creatorFacet`, which carries the `submitVote()` method that registers votes with the voteCounter. The Electorate is responsible for ensuring that `submitVote()` can only be called with the voter's unique voterHandle.

Source: [packages/governance/README.md](https://github.com/Agoric/agoric-sdk/blob/92fa9a262b1b190d8535f826197a5df0c1ba9958/packages/governance/README.md) at commit `92fa9a26`.
