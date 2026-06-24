---
section: daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
source: endo-but-for-bots--llm-designs-daemon-capability-bus
topics: [daemon, capability-security]
status: current
title: Deadlock prevention — the spawn-tree discipline
parent: endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
---

§Deadlock prevention inherits a discipline from the `endo-engo`
prototype: the daemon maintains a **spawn tree** recording
parent-child relationships (logical, not OS-level — *all* processes
are OS-level children of the daemon). Synchronous calls (`nonce > 0`)
are only permitted from child to ancestor in the *logical* tree or
to the control plane (handle 0). The `canBlock(caller, callee)` check
prevents cycles. Asynchronous messages (`nonce = 0`) are always
permitted.

In the bus arch, the logical spawn tree is:

```
daemon → manager → workers
```

So: workers can synchronously call the manager or the daemon. The
manager can synchronously call the daemon. *Sibling workers cannot
synchronously call each other* — they use asynchronous messages via
the manager's CapTP layer. The discipline is what lets the daemon
guarantee the spawn graph is a DAG; CapTP layers above the daemon
inherit the same liveness property.
