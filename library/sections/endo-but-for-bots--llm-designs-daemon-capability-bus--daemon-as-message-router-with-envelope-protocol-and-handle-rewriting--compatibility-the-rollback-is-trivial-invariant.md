---
section: daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
source: endo-but-for-bots--llm-designs-daemon-capability-bus
topics: [daemon, capability-security]
status: current
title: Compatibility — the *rollback is trivial* invariant
parent: endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
---

§Upgrade Considerations notes that the daemon does not modify the
`endo` CLI (users set `ENDO_BIN` to switch); the Unix socket is at
the same path, so all `endo` commands work against either a
legacy-daemon-managed or bus-daemon-managed manager. The daemon does
not change the manager's state format — formula graph, pet stores,
keypairs are still managed by the manager. *Rolling back is trivial:
stop the daemon-managed manager and start a legacy in-process daemon
directly with `endo start`. No state migration is needed.* The
`-node` modules remain alongside the `bus-` modules and continue to
work independently.
