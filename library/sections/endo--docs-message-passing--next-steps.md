---
title: Next Steps
source: docs/message-passing.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send, getting-started]
status: current
---

> Abstract: Pointers to deeper material: per-package READMEs (marshal, patterns, eventual-send, exo), the SES specification, Agoric documentation for blockchain-side use, and community discussion channels.

## Next Steps

You now understand the complete eventual send and receive stack.
Here are resources for going deeper:

### Package Documentation

For detailed API reference:
- [@endo/pass-style](../packages/pass-style/README.md) - Pass styles, Far,
  makeTagged
- [@endo/patterns](../packages/patterns/README.md) - M namespace, copy
  collections, guards
- [@endo/exo](../packages/exo/README.md) - makeExo, defineExoClass,
  defineExoClassKit
- [@endo/eventual-send](../packages/eventual-send/README.md) - E proxy,
  HandledPromise

### Advanced Topics

**CapTP**: For real network communication between machines, see
[@endo/captp](../packages/captp/README.md).
CapTP implements the Cap'n Proto protocol for capability-based RPC.

**Virtual and Durable Exos**: The exos in this guide are heap-based and don't
survive vat restarts.
For high cardinality or upgrade-survivable exos, see
[@agoric/vat-data](https://github.com/Agoric/agoric-sdk/tree/master/packages/vat-data)
which provides:
- `defineVirtualExoClass` - backed by virtual object storage
- `defineDurableExoClass` - survives vat upgrades
- `prepareExoClass` - unified API for both

**Marshal**: For details on how passables are serialized for transmission, see
[@endo/marshal](../packages/marshal/README.md).

**Stores**: For persistent collections of passables and remotables, see
[@agoric/store](https://github.com/Agoric/agoric-sdk/tree/master/packages/store).

### Design Resources

- [Object Capabilities](https://en.wikipedia.org/wiki/Object-capability_model)
- [Concurrency Among Strangers](http://www.erights.org/talks/thesis/) - Mark
  S. Miller's thesis
- [Cap'n Proto RPC Protocol](https://capnproto.org/rpc.html)
- [Agoric Documentation](https://docs.agoric.com/)

### Example Code

The [Agoric SDK](https://github.com/Agoric/agoric-sdk) contains numerous
examples of message passing patterns in production smart contracts.

---

This completes the tour of message passing in Endo.
These four packages form the foundation of safe distributed computing, enabling
you to build capability-based systems that work seamlessly from local function
calls to global network communications.

Source: [docs/message-passing.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/docs/message-passing.md) at commit `14a0b631`.
