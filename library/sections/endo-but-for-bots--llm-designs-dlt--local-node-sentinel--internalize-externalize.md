---
title: Internalize / externalize
source: designs/daemon-locator-terminology.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bccee2841e52eb5e42ec5b5be4fcbe1e66d60a42
source_date: 2026-03-17
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
parent: endo-but-for-bots--llm-designs-dlt--local-node-sentinel
---

```js
const internalizeLocator = (locator, isLocalKey) => {
  const { number, node, formulaType } = parseLocator(locator);
  const normalizedNode = isLocalKey(node) ? LOCAL_NODE : node;
  const id = formatId({ number, node: normalizedNode });
  return { id, formulaType, addresses: addressesFromLocator(locator) };
};

const externalizeId = (id, formulaType, agentNodeNumber) => {
  const { number, node } = parseId(id);
  const peerKey = node === LOCAL_NODE ? agentNodeNumber : node;
  return formatLocator(formatId({ number, node: peerKey }), formulaType);
};
```

**Round-trip invariant.** For local formulas:

```
internalId  (abc:LOCAL_NODE)
  → externalizeId(id, type, agentKey) → locator with agentKey
  → internalizeLocator(locator, isLocalKey) → abc:LOCAL_NODE
  = internalId  ✓
```

For remote formulas, the node is preserved through both operations.
