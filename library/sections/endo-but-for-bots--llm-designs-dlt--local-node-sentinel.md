---
title: LOCAL_NODE sentinel — agent-independent internal storage
source: designs/daemon-locator-terminology.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bccee2841e52eb5e42ec5b5be4fcbe1e66d60a42
source_date: 2026-03-17
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
---

Each `EndoAgent` (host, guest) on a daemon has its own Ed25519
keypair. When an agent emits a locator, it stamps the locator with
its *own* public key as the peer. But internally, formula storage uses
a single sentinel — **`LOCAL_NODE`** — in place of any local agent's
key. This is the daemon-wide pattern that makes per-agent identities
externally visible without duplicating internal state.

```js
const LOCAL_NODE = '0'.repeat(64);  // never a valid Ed25519 public key
```

Three properties fall out:

1. **One copy per formula.** Regardless of which agent created or
   views a formula, the internal identifier uses the same `LOCAL_NODE`
   peer-key suffix. The pet stores and the formula graph see one
   entry per local formula, never N entries (one per agent).
2. **Agent-independent storage.** Agents can be created and destroyed
   without rewriting any internal formula identifiers — `LOCAL_NODE`
   does not change.
3. **Per-agent externalization.** Each agent stamps outgoing locators
   with its *own* public key so the recipient knows which peer to
   contact (and so different agents on the same daemon present
   different locators for the same value — visible identity, hidden
   shared storage).

## The `localKeys` set

The daemon maintains `localKeys`, a set of known local-agent public
keys, initialized with `localNodeNumber` (the daemon root key) and
extended each time a new agent is incarnated. The predicate
`isLocalKey(node)` returns `true` for any key in this set; all agents
share the same predicate so that a sibling agent's locator is correctly
recognized as local.

## Internalize / externalize

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

## Database repair

Pet-store entries created before the LOCAL_NODE migration contain
`{number}:{localNodeNumber}` identifiers. A startup repair pass
(`repairIds`) rewrites these to `{number}:{LOCAL_NODE}` in both
in-memory state and on-disk files. The `normalizeId` helper in
`daemon.js` also transparently rewrites old-format identifiers
encountered in formula dependency references at read time, so formula
files themselves do not need rewriting — repair is on-touch.

The whole sentinel-plus-localKeys-set scheme is a worked example of
the **stable internal id, externalized per identity** pattern that
recurs across the daemon — see also the formula-key/peer-key split in
[[endo-but-for-bots--llm-designs-dlt--terminology-rename]] and the
peer-mirror/local-set asymmetry in
[[endo-but-for-bots--llm-designs-dcpg--retention-set-model]].

## See also

- [[local-node-sentinel]] — concept page collecting all sections that touch this sentinel + its `0.0.0.0`-of-Ed25519 framing.
- [[sentinel-with-rationale]] — the broader pattern this is the canonical instance of.
- [[per-agent-keypair]] — the `@keypair`-per-agent design that creates the multiplicity LOCAL_NODE resolves.
