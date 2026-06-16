---
section: daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
source: endo-but-for-bots--llm-designs-daemon-capability-bus
topics: [daemon, capability-security]
status: current
title: The platform-pair table — what *bus-* prefixes denote
parent: endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
---

The §Relationship to the existing daemon table is the design's most
load-bearing index:

| Platform | Manager entry | Powers module | Worker entry | Worker powers |
|----------|--------------|---------------|-------------|---------------|
| Node.js (in-process) | `daemon-node.js` | `daemon-node-powers.js` | `worker-node.js` | `worker-node-powers.js` |
| Bus (Node manager) | `bus-daemon-node.js` | `bus-daemon-node-powers.js` | `bus-worker-node.js` | `bus-worker-node-powers.js` |
| Bus (XS manager) | `bus-daemon-rust-xs.js` | — | `bus-worker-xs.js` | — |

The `-node.js` / `-node-powers.js` module convention already
anticipated multiple platform backends; the bus is a *new platform
pair* that introduces a new role (manager) where the old role
(in-process daemon) used to live. The design explicitly resolves a
naming confusion: *the bus-daemon-*.js files implement the manager
role, not the daemon role*. The `bus-` prefix denotes participation
in the capability-bus protocol, not a role; the daemon *is* the bus,
and these files describe the wire format that the manager, workers,
and the daemon all speak. The `daemon` in the filename is kept for
symmetry with the formula-runtime's existing `daemon-*` files.
