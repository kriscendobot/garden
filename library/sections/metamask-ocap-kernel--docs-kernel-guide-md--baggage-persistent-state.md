---
title: Baggage (Persistent State)
source: docs/kernel-guide.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/kernel-guide.md
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-23
source_authors: [Dimitris Marlagkoutsos, MetaMask ocap-kernel team]
ingested: 2026-06-27
ingested_by: scholar
topics: [persistence, capability-security]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel. Baggage-stored references are ocap-kernel's durable-capability (sturdyref-like) mechanism. See [[ocap-kernel]].
---

## Abstract

**Baggage** is a durable key-value store handed to each vat (the third `buildRootObject` argument). Data in baggage survives vat restarts (**resuscitation**) and is the primary mechanism for vat state persistence. Its API mirrors a guarded map: `has(key)` → boolean; `init(key, value)` (throws if key exists); `get(key)` (throws if absent); `set(key, value)` (throws if absent); `delete(key)`. The canonical idiom is **restore-or-initialize**: on every (re)start, check `baggage.has(k)` to restore prior state, falling back to `init` on first run — and because `bootstrap` runs only once, references handed in at bootstrap (services, other vats) are typically `baggage.init`'d so a resuscitated vat can recover them without a second bootstrap. Baggage accepts primitives, hardened plain objects/arrays, and **exos and other remotable objects (including references to objects in other vats)** — but not arbitrary class instances, functions, or unhardened objects. Storing a cross-vat reference in baggage is ocap-kernel's **durable-capability** primitive: a capability that survives process death, the role Endo's formula graph plays and that E-language **sturdyrefs** named.

## Body

**Baggage** is a durable key-value store provided to each vat. Data stored in baggage survives vat restarts (resuscitation). Baggage is the primary mechanism for vat state persistence.

### API

```ts
baggage.has('myKey');        // boolean
baggage.init('myKey', value); // throws if key already exists
baggage.get('myKey');        // unknown — throws if key doesn't exist
baggage.set('myKey', newValue); // throws if key doesn't exist
baggage.delete('myKey');
```

### Common pattern: restore or initialize

```ts
export function buildRootObject(_vp, _p, baggage) {
  let counter;
  if (baggage.has('counter')) {
    counter = baggage.get('counter');
  } else {
    counter = 0;
    baggage.init('counter', counter);
  }

  let myService = baggage.has('myService') ? baggage.get('myService') : undefined;

  return makeDefaultExo('root', {
    async bootstrap(_vats, services) {
      // Only called on first launch, not on restart
      myService = services.myService;
      baggage.init('myService', myService);
    },
    increment() {
      counter += 1;
      baggage.set('counter', counter);
      return counter;
    },
  });
}
```

### What can be stored in baggage

- Primitive values (strings, numbers, booleans)
- Hardened plain objects and arrays
- Exos and other remotable objects (including references to objects in other vats)
- **Not** arbitrary class instances, functions, or unhardened objects

## Lineage note

Baggage is the SwingSet/Agoric *baggage* concept (durable per-vat KV that survives upgrade/restart), and the ability to store a *remotable reference* — including a reference to an object in another vat — is the load-bearing detail for confinement and persistence together. A reference durably held in baggage is ocap-kernel's analog of a **sturdyref** (E-language: an offline capability that can be saved and later revived, see the library's *Concurrency Among Strangers* §9 partial-failure section on `captp://` URIs + SturdyRef + swiss-number) and of Endo's persistence-by-traversal-from-petname-roots ([[formula-graph]], [[vat-and-compartment]]). The divergence: ocap-kernel persists references as baggage entries backed by `kernel-store` (SQLite, Node-native or WASM); Endo persists them as formula-graph edges reachable from petname roots. Both answer the same question — how does a capability outlive the process that held it — with different storage substrates.

Source: [docs/kernel-guide.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/kernel-guide.md) at commit `175b7c0`.
