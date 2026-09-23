---
title: "`KeypairFormula`"
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

```typescript
type KeypairFormula = {
  type: 'keypair';
  publicKey: string;   // 64-char hex Ed25519 public key
  privateKey: string;  // 64-char hex Ed25519 private key (seed)
};
```

The key material lives **directly in the formula JSON**. The design
calls out the trade-off explicitly:

> *This keeps the formula graph as the single source of truth — keypair
> lifecycle follows formula lifecycle (deleting the formula deletes the
> keys), and no new persistence powers are needed. The private key in a
> formula JSON file has the same security posture as the existing
> `nonce` file: plaintext on disk, protected by filesystem
> permissions.*

This is consistent with the daemon's broader Formula Persistence model
(see [[endo--designs-dp--formula-graph-and-cohort-destruction]]) —
*the formula graph IS the persistence root.* A keypair is just one
more formula; revoking the agent's identity is revoking its keypair
formula.

Keypair formulas have **no dependencies** (empty `extractDeps`); their
maker simply exposes the public key:

```js
// daemon.js makers table
keypair: ({ publicKey }) => harden({ publicKey }),
```

The private key is *in* the formula JSON file but is **not** exposed
on the maker's reified value — agents look up their keypair's public
key via the maker; the private key is only accessible to whichever
code path reads the formula file directly (the daemon's own
`@-keypair` special-name resolution, the OCapN-Noise handshake code).
