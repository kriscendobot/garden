---
title: Scenarios (examining a contract before use + participating in governance)
source: packages/governance/README.md
source_repo: agoric/agoric-sdk
source_commit: 92fa9a262b1b190d8535f826197a5df0c1ba9958
source_date: 2023-04-20
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security]
status: current
notes: The "follow the chain of terms" examination procedure is the canonical legibility story for governed contracts. Note the acknowledged gap: "there isn't currently a way to verify the process of creating new questions" — the question-creation private facet is opaque to observers.
---

> Abstract: Two scenarios. **Examining a contract before use** — governed contracts make their governor and parameters visible via `terms` or the publicFacet. The governor's publicFacet refers back to the contract it governs and exposes the electorate, which lists questions and their voteCounters. From an instance, retrieve the installation from Zoe to examine the source. Acknowledged gap: there's no way to verify the question-creation process today (the create-question facet is private). **Participating in governance** — voters get a voting API as the outcome of an invitation; this lets them verify the electorate instance. The electorate's publicFacet has `getQuestionSubscription()` (new questions) and `getOpenQuestions()` (unresolved). Each question's `ElectionType` is one of PARAM_CHANGE, ELECTION, or SURVEY. PARAM_CHANGE questions identify the contract instance, the parameter, and the proposed value; all PARAM_CHANGE elections are by majority vote with "no change" as the default outcome.

## Scenarios

### Examining a Contract before use

Governed contracts will make their governor and parameters visible, either through `terms` or the public facet. The governor, in turn, publicly shares the electorate, which makes the list of questions visible. The questions show their voteCounters, which makes it possible to tell how the counting will be done.

There isn't currently a way to verify the process of creating new questions. We'll eventually need to spin a story that will make that more legible. Currently, the ability to create new governance questions is provided as a private facet that contains only the method `voteOnParamChange()`.

When a prospective user of a contract receives a link to an instance of a contract, they can check the `terms` to see if the contract names a governor. The governor's public facet will also refer to the contract it governs. Once you have the instance you can retrieve the installation from Zoe which allows you to examine the source.

The governed contract will provide the electorate, which allows you to check the electorate, and retrieve a list of open questions. (We should add closed questions and their resolution as well.) Each question refers to the voteCounter it uses.

### Participating in Governance

Voters are managed by an Electorate. Prospective voters should only accept a voting API as the outcome of an invitation. The invitation allows you to verify the particular electorate instance in use. The electorate's public facet has `getQuestionSubscription()`, which allows you to find out about new questions for the electorate and `getOpenQuestions()` which lists questions that haven't been resolved.

Each question describes its subject. One field of the questionDetails is `ElectionType`, which can be `PARAM_CHANGE`, `ELECTION`, or `SURVEY`. (I'm sure we'll come up with more types.) When it is `PARAM_CHANGE`, the questionDetails will also identify the contract instance, the particular parameter to be changed, and the proposed new value. At present, all parameter change elections are by majority vote, and if a majority doesn't vote in favor, then no change is made.

Source: [packages/governance/README.md](https://github.com/Agoric/agoric-sdk/blob/92fa9a262b1b190d8535f826197a5df0c1ba9958/packages/governance/README.md) at commit `92fa9a26`.
