---
title: Governance (overview — Electorates + VoteCounters + ElectionManagers)
source: packages/governance/README.md
source_repo: agoric/agoric-sdk
source_commit: 92fa9a262b1b190d8535f826197a5df0c1ba9958
source_date: 2023-04-20
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security, exo]
status: current
notes: The "self-describing" property of Electorates + VoteCounters is the load-bearing legibility story — voters and observers can verify that a vote means what it claims to mean. The QuestionSpec shape (method UNRANKED/ORDER, issue, positions, electionType, maxChoices) is the canonical question representation. PARAM_CHANGE is the structured electionType used most commonly.
---

> Abstract: A general framework for governance via three layers. **Electorate** — a set of voters; two kinds today: committees (elected or appointed) and stakeholders (in review). The electorate must exist before questions can be posed. **ElectionManager** — manages one Electorate's questions; specifies which VoteCounter is used per question. **VoteCounters** — pluggable counting strategies: majority, approval, proportional, quadratic, instant-runoff, etc. **QuestionSpec** has `{method, issue, positions, electionType, maxChoices}`; method is UNRANKED or ORDER (latter for STV/IRV); electionType distinguishes PARAM_CHANGE from string-issue questions. **Voters** get a voterFacet via invitation, subscribe with the electorate for new questions, cast votes by sending selected positions to their trusted electorate. The Electorate/VoteCounter design supports verifying counting and who-can-vote without constraining question-creation; ElectionManagers fill that gap. ContractGovernor is the canonical ElectionManager example.

# Governance

This package provides Electorates and VoteCounters to create a general framework for governance. It has implementations for particular kinds of electorates and different ways of tallying votes.

The electorates and VoteCounters are self-describing and reveal what they are connected to so that voters can verify that their votes mean what they say and will therefore be tabulated as expected.

Any occasion of governance starts with the creation of an Electorate. Two kinds exist currently that represent committees (elected or appointed) and stakeholders (Stakeholder support is in review). The electorate may deal with many questions governing many things, so the electorate has to exist before any questions can be posed.

The next piece to be created is an ElectionManager. (Contract Governor, one implementation, is discussed below). An ElectionManager deals with a particular Electorate. It supports creation of questions, and can manage what happens with the results. The ElectionManager is responsible for specifying which VoteCounter will be used with any particular question. Different VoteCounters will handle elections with two positions or more. The architecture supports vote counters for [majority decisions](https://en.wikipedia.org/wiki/Majority_rule), [approval voting](https://en.wikipedia.org/wiki/Approval_voting), and [proportional representation](https://en.wikipedia.org/wiki/Proportional_representation), as well as [quadratic](https://en.wikipedia.org/wiki/Quadratic_voting), [instant runoff](https://en.wikipedia.org/wiki/Category:Instant-runoff_voting), and more esoteric approaches.

When a question is posed, it is only with respect to a particular Electorate, (which identifies a collection of eligible voters) and a particular vote counting contract. The QuestionSpec consists of `{ method, issue, positions, electionType, maxChoices }`. The issue and positions can be strings or structured objects. Method is one of UNRANKED and ORDER, which is sufficient to describe all the most common kinds of votes. A vote between two candidates or positions uses UNRANKED with a limit of one vote. ORDER will be useful for Single Transferable Vote or Instant Runoff Voting. ElectionType distinguishes PARAM_CHANGE, which has structured questions, from others where the issue is represented by a string.

We recommend that each position should describe what will happen if it's the vote winner. When some of the options are just saying "don't do the thing", it's helpful to identify which thing they're not doing. See the ContractGovernor section below for examples.

When posing a particular question to be voted on, the closingRule has to be specified. When voters are presented with a question to vote on, they have access to QuestionDetails, which includes information from the QuestionSpec, the closingRule, and the VoteCounter instance. The VoteCounter has the Electorate in its `terms`, so voters can verify it.

Voters get a voting facet via an invitation, so they can reliably identify the Electorate. They can subscribe with the electorate to get a list of new questions. They can use the questionHandle from each update from the subscription to get the questionDetails. Voters cast their vote by sending their selected position(s) to their electorate, which they know and trust.

This structure of Electorates and VoteCounters allows voters and observers to verify how votes will be counted, and who can vote on them, but doesn't constrain the process of creating questions. ElectionManagers make that process visible. ContractGovernor is a particular example of that that makes it possible for a contract to publish details of how its parameters will be subject to governance.

Source: [packages/governance/README.md](https://github.com/Agoric/agoric-sdk/blob/92fa9a262b1b190d8535f826197a5df0c1ba9958/packages/governance/README.md) at commit `92fa9a26`.
