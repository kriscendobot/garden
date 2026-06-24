---
title: Dehydrate at ingestion
source: designs/daemon-locator-terminology.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bccee2841e52eb5e42ec5b5be4fcbe1e66d60a42
source_date: 2026-03-17
source_authors: [Kris Kowal]
topics: [daemon, persistence, capability-security]
status: current
parent: endo-but-for-bots--llm-designs-dlt--dehydration-and-hydration
---

When a locator arrives — from another peer, from user paste, from a
chat message — its formula key and its hints are split apart:

```js
const { peerKey, formulaAddress, hints, formulaType } = parseLocator(locator);
const formulaKey = formatId({ number: formulaAddress, node: peerKey });

// Durable store: the stable reference
await petStore.write(petName, formulaKey);

// Separate update: refresh the peer's connection hints
await addPeerInfo({ node: peerKey, addresses: hints });
```

The pet store row holds the formula key, **never** a locator. Hints
land in a separate per-peer record where they can be replaced wholesale
on each fresh arrival.
