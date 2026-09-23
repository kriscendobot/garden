---
section: daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
source: endo-but-for-bots--llm-designs-daemon-capability-bus
topics: [daemon, capability-security]
status: current
title: The three architectures
parent: endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
---

The design opens with three boxed diagrams that lay out the migration
arc. The current arch is *flat-supervisor*:

```
endo (CLI) ──► node daemon ──►* node worker
```

The target arch of this design moves the supervisor *out* of Node.js
into a dedicated bus daemon — and demotes the former JS daemon to a
peer of its own workers:

```
                         ┌─► node manager  (or xs manager)
endo (CLI) ──► daemon ───┤
                         └─►* worker (node or xs)
```

The *future arch* (explicitly out-of-scope here, but the design points
to it) adds wasm workers and platform I/O as direct children of the
bus daemon:

```
endo (CLI) ─┐
daemon ──────┼─► node manager
              ├─►* node worker
              ├─►* xs worker
              ├─►* wasm worker
              └─► platform I/O (fs, net, crypto)
```

The key topology move is *workers are children of the daemon, not of
the manager*. The manager *requests* worker creation; the daemon
*owns* every subprocess. Killing the daemon terminates the whole tree.
