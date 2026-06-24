---
section: endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel
source: endo-but-for-bots--llm-designs-daemon-locator-reference
topics: [daemon, ocapn]
status: current
title: The §externalize-internalize duality
parent: endo-but-for-bots--llm-designs-daemon-locator-reference--endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel
---

The §Externalization and Internalization section names the *two
operations* that bridge internal and external forms:

### `externalizeId(id, formulaType, agentNodeNumber, addresses?)`

> *Replaces `LOCAL_NODE` with the agent's own public key so that
> recipients know which peer to contact.*

```
internal id:  {number}:{LOCAL_NODE}
    → locator: endo://{agentKey}/?id={number}&type={type}
```

The §LOCAL_NODE-replaced-by-agentKey discipline: *when producing
a locator for an external audience, swap in the actual agent's
public key — the recipient must know which peer to contact*. The
sentinel is *internal-only*; external audiences see the real key.

Remote identifiers (where the node is not `LOCAL_NODE`) *pass
through with the node number unchanged*.

### `internalizeLocator(locator, isLocalKey)`

> *Recognizes any known local agent key and normalizes it to
> `LOCAL_NODE`.*

```
locator: endo://{agentKey}/?id={number}&type={type}&at={addr}
    → id: {number}:{LOCAL_NODE}
    → formulaType: {type}
    → addresses: [{addr}]
```

The §normalize-incoming-local-agent-key-to-LOCAL_NODE discipline:
*when receiving a locator, if its node is one of this daemon's
own keys, normalize to LOCAL_NODE in storage*. The reverse of
externalize. The `isLocalKey` predicate uses the daemon's
`localKeys` set (*containing all known local agent public keys*).

### The §round-trip invariant

> *For local formulas: `internalId → externalizeId →
> internalizeLocator → internalId  ✓`*

The *information-preserving-round-trip* invariant. For remote
formulas, the node number is preserved through both operations.
The discipline ensures *internal storage is canonical* — two
agents on the same daemon both store *the same internal id* for
the same remote formula, regardless of whose key was in the
incoming locator.
