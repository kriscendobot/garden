---
title: Hydrate at presentation
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

When a locator is needed — for display, for sharing, for an invitation
— it is rebuilt from the stored key plus the peer's *current* hints:

```js
const formulaKey = await petStore.read(petName);
const { node: peerKey } = parseId(formulaKey);
const { addresses: hints } = await getPeerInfo(peerKey);

const locator = formatLocatorWithHints(formulaKey, formulaType, hints);
```
