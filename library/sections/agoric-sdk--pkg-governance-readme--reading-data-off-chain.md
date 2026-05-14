---
title: Reading data off-chain (published.committee.questions + demo)
source: packages/governance/README.md
source_repo: agoric/agoric-sdk
source_commit: 92fa9a262b1b190d8535f826197a5df0c1ba9958
source_date: 2023-04-20
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [tooling]
status: current
notes: Two publishing surfaces. Governed contracts publish alongside the contract they're governing (delegates to that contract's StoredPublishKit). Committee contracts publish their questions directly. The `Economic_Committee.latestQuestion` key is the same one called out in `agoric-sdk--pkg-inter-protocol-readme--reading-data-off-chain` under `published.committees.Economic_Committee.{latestQuestion, latestOutcome}`.
---

> Abstract: Two off-chain publishing surfaces for governance. **Governed contracts** publish along with the contract they're governing — see `agoric-sdk--pkg-inter-protocol-readme--reading-data-off-chain` for the canonical pattern. **Committee contracts** publish their questions: follow `published.committee.questions` (or a specific committee's keys like `published.committees.Economic_Committee.latestQuestion`) via `makeFollower` + `iterateLatest` from `@agoric/casting`. Demo: standard three-tab chain + cli + follow pattern. Note: `published.committees.Economic_Committee.latestQuestion` only exists once an `.addQuestion()` call has executed.

## Reading data off-chain

Governed contracts publish along with the contract they're governing. See [../inter-protocol/README.md].

Committee contracts also publish the questions posed. These can then be followed off-chain like so,

```javascript
  const key = `published.committee.questions`; // or whatever the stream of interest is
  const leader = makeDefaultLeader();
  const follower = makeFollower(storeKey, leader);
  for await (const { value } of iterateLatest(follower)) {
    console.log(`here's a value`, value);
  }
```

### Demo

Start the chain in one terminal:

```sh
cd packages/cosmic-swingset
make scenario2-setup scenario2-run-chain-economy
```

Once you see a string like `block 17 commit` then the chain is available. In another terminal,

```sh
# shows keys of the committees node
agd query vstorage keys 'published.committees'
# shows keys of the economic committee node
agd query vstorage keys 'published.committees.Economic_Committee'
# follow questions
agoric follow :published.committees.Economic_Committee.latestQuestion
```

Note that there won't be `'published.committees.Economic_Committee.latestQuestion` until some `.addQuestion()` call executes.

Source: [packages/governance/README.md](https://github.com/Agoric/agoric-sdk/blob/92fa9a262b1b190d8535f826197a5df0c1ba9958/packages/governance/README.md) at commit `92fa9a26`.
