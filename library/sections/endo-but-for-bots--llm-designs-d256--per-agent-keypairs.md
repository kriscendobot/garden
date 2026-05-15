---
title: Per-agent keypairs — KeypairFormula, agent integration, and the `@keypair` special name
source: designs/daemon-256-bit-identifiers.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, persistence, agent-conventions]
status: current
---

Beyond the daemon's *root* keypair, **each host and guest agent has
its own Ed25519 keypair**, stored as a `keypair` formula in the formula
graph. This puts agent identities on the same footing as every other
durable artifact the daemon manages.

## `KeypairFormula`

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

## Agent formula updates

Both `HostFormula` and `GuestFormula` gain a required `keypair` field:

```typescript
type HostFormula = {
  type: 'host';
  handle: FormulaIdentifier;
  hostHandle: FormulaIdentifier;
  keypair: FormulaIdentifier;
  worker: FormulaIdentifier;
  inspector: FormulaIdentifier;
  petStore: FormulaIdentifier;
  mailboxStore: FormulaIdentifier;
  mailHub: FormulaIdentifier;
  endo: FormulaIdentifier;
  networks: FormulaIdentifier;
  pins: FormulaIdentifier;
};

type GuestFormula = {
  type: 'guest';
  handle: FormulaIdentifier;
  keypair: FormulaIdentifier;
  hostHandle: FormulaIdentifier;
  hostAgent: FormulaIdentifier;
  petStore: FormulaIdentifier;
  mailboxStore: FormulaIdentifier;
  mailHub: FormulaIdentifier;
  worker: FormulaIdentifier;
};
```

The `keypair` field is a formula identifier (not the key material
itself) — the formula graph's normal indirection keeps the host /
guest formula JSON small and ensures keypair lifecycle is independent
of (and visible to) the agent's other dependencies.

## Formulation flow

When a host or guest is formulated, `formulateKeypair()` generates a
fresh Ed25519 keypair, hex-encodes the keys SES-safely, and writes it
as a keypair formula:

```js
const formulateKeypair = async () => {
  const keypair = await generateEd25519Keypair();
  const publicKeyHex = Array.from(keypair.publicKey, byte =>
    byte.toString(16).padStart(2, '0'),
  ).join('');
  const privateKeyHex = Array.from(keypair.privateKey, byte =>
    byte.toString(16).padStart(2, '0'),
  ).join('');
  const keypairFormulaNumber = await randomHex256();
  const formula = {
    type: 'keypair',
    publicKey: publicKeyHex,
    privateKey: privateKeyHex,
  };
  const { id: keypairId } = await formulate(keypairFormulaNumber, formula);
  return { keypairId };
};
```

The returned `keypairId` is then included in
`formulateHostDependencies` and `formulateGuestDependencies`, then
stored on the host/guest formula.

## `@keypair` as a special name

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

## See also

- [[per-agent-keypair]] — concept page collecting all sections that touch this idea.
- [[delegates-and-epithets]] — the principal/delegate identity model built on per-agent keypairs.
- [[revocation-by-withdrawal]] — revoking an agent is revoking its `keypair` formula.
- [[formula-graph]] — keypair formulas are one of the 26 formula types.
