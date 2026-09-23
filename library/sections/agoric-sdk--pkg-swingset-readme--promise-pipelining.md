---
title: Promise Pipelining (chained eventual-sends, the chained-then trick, the enablePipelining caveat)
source: packages/SwingSet/README.md
source_repo: agoric/agoric-sdk
source_commit: 7d95438c0888b5f7e903e258013d30b66f2458cf
source_date: 2025-10-25
source_authors: [Richard Gibson]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send]
status: current
notes: As of this README's commit, no Liveslots-based Vats are configured with `enablePipelining: true` — the kernel cannot deliver pipelined messages speculatively yet. The pipelining feature is wire-protocol-complete (per the OCapN Implementation Guide stage 4) but not yet enabled in SwingSet's standard kernel path. Soft-flag overlap with ocapn--implementation-guide--stage-4-promise-pipelining (the wire-protocol view) and with endo--pkg-eventual-send-readme--* (the underlying primitive).
---

> Abstract: The Promise returned by an eventual-send can be used as a target itself — `E(E(bob).foo()).bar()` queues `bar` to deliver to whatever `foo` returns. By **chaining** eventual-sends without intervening `.then()`, the kernel has enough information to speculatively deliver later messages to the Vat that will produce earlier answers — avoiding unnecessary round-trips. Critical caveat as of the README's commit: this speculative delivery requires `enablePipelining: true` in the deciding Vat's configuration, **which is not currently set for any Liveslots Vats**. The latency reduction will become significant when off-host messaging is implemented.

### Promise Pipelining

In `fooP = E(bob).foo()`, `fooP` represents the (eventual) return value of whatever `foo()` executes. If that return value is also a Remotable, it is possible to queue messages to be delivered to that future target. The Promise returned by an eventual-send can be used as a target itself, and the method invoked will be turned into a queued message that won't be delivered until the first promise resolves:

```js
const db = E(databaseServer).openDB();
const row = E(db).select(criteria)
const success = E(row).modify(newValue);
success.then(res => console.log('row modified'));
```

If you don't care about them, the intermediate values can be discarded:

```js
E(E(E(databaseServer).openDB()).select(criteria)).modify(newValue)
  .then(res => console.log('row modified'));
```

This sequence could be expressed with plain `then()` clauses, but by chaining them together without `then`, the kernel has enough information to speculatively deliver the later messages to the Vat in charge of answering the earlier messages (_if the deciding Vat is configured with `enablePipelining: true`, which is not currently the case for any [Liveslots](../swingset-liveslots) Vats_). This avoids unnecessary roundtrips, by sending the later messages during "downtime" while the target Vat thinks about the answer to the first one.

This drastic reduction in latency is significant when the Vats are far away from each other, and the inter-Vat communication delay is large. The SwingSet container does not yet provide complete facilities for off-host messaging, but once that is implemented, promise pipelining will make a big difference.

Source: [packages/SwingSet/README.md](https://github.com/Agoric/agoric-sdk/blob/7d95438c0888b5f7e903e258013d30b66f2458cf/packages/SwingSet/README.md) at commit `7d95438c`.
