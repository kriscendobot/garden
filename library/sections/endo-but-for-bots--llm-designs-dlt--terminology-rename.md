---
title: Terminology rename — node/formula numbers become peer keys and formula addresses
source: designs/daemon-locator-terminology.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bccee2841e52eb5e42ec5b5be4fcbe1e66d60a42
source_date: 2026-03-17
source_authors: [Kris Kowal]
topics: [daemon, agent-conventions]
status: current
notes: Builds on the 256-bit identifier migration from `daemon-256-bit-identifiers.md`. Strict invariant — *no existing method signatures change*; this is a documentation + types + new-method overlay, not a breaking rename of the runtime API.
---

The design renames four runtime terms (and introduces two new
locator-level concepts) without changing any existing function signature.
Type aliases bridge old and new names in `types.d.ts`.

| Current term | New term | Definition |
|---|---|---|
| Node Number | **Peer Key** | Ed25519 public key (64-char hex) |
| Formula Number | **Formula Address** | Content address (SHA-256) or capability address (random 256-bit) |
| Formula Identifier | **Formula Key** | `{formulaAddress}:{peerKey}` |
| *new* | **Connection Hint** | Transport-prefixed address string (e.g., `ws:example.com:8920`) |
| *new* | **Peer Locator** | Peer key + connection hints |
| *new* | **Formula Locator** | Formula key + connection hints + type |

The choice of "peer key" / "formula address" is meant to surface the
*semantic role* of each 64-char hex string. The Ed25519 public key is
a peer's *identity*, and the formula number is the *address* (content-
or capability-) at which a value lives within that peer's daemon. The
old "node number" / "formula number" pairing was symmetric but flat;
the new pair makes the host/value relationship visible at every site
that handles the identifiers.

In `types.d.ts`:

```typescript
// Semantic aliases for existing types — same brand under the hood
export type PeerKey         = NodeNumber;
export type FormulaAddress  = FormulaNumber;
export type FormulaKey      = FormulaIdentifier;

// New first-class concepts
export type ConnectionHint  = string;
export type PeerLocator     = { peerKey: PeerKey; hints: ConnectionHint[] };
export type FormulaLocator  = {
  formulaKey: FormulaKey;
  formulaType: string;
  hints: ConnectionHint[];
};
```

The bridging-via-type-aliases discipline — preserve the brand, rename
the alias, migrate sites incrementally — keeps consumer code working
through the rename. See
[[endo-but-for-bots--llm-designs-dlt--method-additions]] for which APIs
gain new methods and which keep their existing signatures unchanged.
