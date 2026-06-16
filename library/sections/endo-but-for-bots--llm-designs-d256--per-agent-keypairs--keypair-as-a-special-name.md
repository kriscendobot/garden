---
title: "`@keypair` as a special name"
source: designs/daemon-256-bit-identifiers.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, persistence, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-d256--per-agent-keypairs
---

Both `makeHost` and `makeGuest` accept a `keypairId` parameter and
register it as the `@keypair` special name. **An agent looks up its
own keypair via the same naming machinery it uses to find any other
capability** — there is no privileged side channel.

```js
// host.js
const specialNames = {
  ...platformNames,
  '@agent': hostId,
  '@self': handleId,
  '@host': hostHandleId ?? handleId,
  '@keypair': keypairId,
  '@main': mainWorkerId,
  '@endo': endoId,
  // ...
};

// guest.js
const specialNames = {
  '@agent': guestId,
  '@self': handleId,
  '@host': hostHandleId,
  '@keypair': keypairId,
};
```

This pattern — *the agent's identity is named the same way any other
capability is named* — is the same uniform-access discipline the
daemon's `@self`, `@host`, `@agent`, `@main`, `@endo` special names
embody. Adding `@keypair` makes cryptographic identity addressable
through the same lookup mechanism as the agent's worker, host, or
endo facet.

The integration with the `LOCAL_NODE` sentinel discussed in
[[endo-but-for-bots--llm-designs-dlt--local-node-sentinel]] also
relies on this: each agent's `@keypair` public key is what its
*externalized* locators use to stamp the peer-key field, while
internal storage uses `LOCAL_NODE` regardless of which agent created
the formula.
