---
title: Identifier migration mechanics and the CryptoPowers interface
source: designs/daemon-256-bit-identifiers.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
---

The migration affects four concrete sites: peer identification,
formula-number generation, content addressing, and the validation
patterns that gate them. The crypto-power interface is the smallest
typed boundary the daemon code uses to express the new primitives.

## Peer identification: Ed25519 public key as node ID

The SHA-512 derived node identifier is **replaced by an Ed25519 public
key**. The daemon generates a **root keypair** at first start and
stores it at `{statePath}/keypair` alongside the existing `nonce`
file. The public key hex serves as `localNodeNumber`.

```js
// daemon.js — daemon initialization
const { keypair: rootKeypair } =
  await persistencePowers.provideRootKeypair();
const localNodeNumber = Array.from(rootKeypair.publicKey, byte =>
  byte.toString(16).padStart(2, '0'),
).join('');
```

The hex encoding uses `Array.from().join('')` rather than `Buffer`
because the daemon's worker contexts run under SES and `Buffer` is not
available there (and would not be hardened anyway).

## Formula numbers: 256-bit random

```js
// daemon-node-powers.js
const randomHex256 = () =>
  new Promise((resolve, reject) =>
    crypto.randomBytes(32, (err, bytes) => {
      if (err) {
        reject(err);
      } else {
        resolve(bytes.toString('hex'));
      }
    }),
  );
```

Used everywhere a formula number is generated for a non-content-
addressed formula (the formula graph's per-formula nonces).

## Content addressing: SHA-256

SHA-512 is replaced with SHA-256 in `makeContentSha256Store` for
content-addressed formulas (`readable-blob`, `readable-tree`).
Existing on-disk content paths are incompatible with new ones; see
the migration-notes section for the state-purge requirement.

## The CryptoPowers interface

```typescript
// types.d.ts
export type Sha256 = {
  update: (chunk: Uint8Array) => void;
  updateText: (chunk: string) => void;
  digestHex: () => string;
};

export type Ed25519Keypair = {
  publicKey: Uint8Array;  // 32 bytes
  privateKey: Uint8Array; // 32 bytes (seed)
};

export type CryptoPowers = {
  makeSha256: () => Sha256;
  randomHex256: () => Promise<string>;
  generateEd25519Keypair: () => Promise<Ed25519Keypair>;
};
```

The interface is deliberately narrow: it generates and digests, but
does **not** persist. The design notes:

> *Key persistence is not a crypto concern — it belongs in
> `DaemonicPersistencePowers`. `CryptoPowers` only generates keypairs;
> the caller is responsible for storing them via the persistence
> layer.*

This is the **separated-power** pattern — split each power into the
narrowest interface that does one thing, and let composition (or
explicit cross-power calls) handle the rest. The same discipline shows
up in how the keypair *formulas* (see
[[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]]) store key
material without touching the crypto layer.

## Validation patterns

```js
// formula-identifier.js
const numberPattern = /^[0-9a-f]{64}$/;
const idPattern = /^(?<number>[0-9a-f]{64}):(?<node>[0-9a-f]{64})$/;
```

64 chars, lowercase hex only. The patterns are the only gate between
"parsed identifier" and "string of plausible-looking hex" — any
upstream layer that constructs identifiers passes through these
regexes.

## Locator and storage path formats

The **locator format is unchanged** by this migration (only the
identifier sizes within it shrink):

```
endo://{64-char node}/?id={64-char number}&type={type}
```

The locator URL **shape** changes later in the design line, in the
locator-terminology rename
([[endo-but-for-bots--llm-designs-dlt--locator-format-evolution]]).

Storage paths split off the first two hex chars as a directory shard
for filesystem-friendly fan-out:

```
{statePath}/formulas/{head(2)}/{tail(62)}.json
```

## Branded types in `types.d.ts`

```typescript
/** A 64-character hex string identifying a formula within a node */
export type FormulaNumber = string & { [FormulaNumberBrand]: true };

/** A 64-character hex string (Ed25519 public key) identifying a node */
export type NodeNumber = string & { [NodeNumberBrand]: true };
```

The brand is what prevents arbitrary strings from being assigned where
identifiers are expected — and it is what the
[[endo-but-for-bots--llm-designs-dlt--terminology-rename]] later preserves
when aliasing `NodeNumber → PeerKey`, `FormulaNumber → FormulaAddress`.
The bridging-via-type-aliases discipline named in that design relies
on the brand being stable across the rename.
