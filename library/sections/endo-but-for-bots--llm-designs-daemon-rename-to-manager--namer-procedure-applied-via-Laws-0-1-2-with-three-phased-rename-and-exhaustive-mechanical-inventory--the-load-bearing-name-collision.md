---
section: namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
source: endo-but-for-bots--llm-designs-daemon-rename-to-manager
topics: [daemon, agent-conventions, repository-governance]
status: current
title: The §load-bearing-name-collision
parent: endo-but-for-bots--llm-designs-daemon-rename-to-manager--namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
---

The §What-is-the-Problem-Being-Solved section names the exact
collision:

> *`packages/daemon/src/daemon.js` and its peer `daemon-*.js`
> power modules carry the orchestration responsibilities of an
> Endo instance: formula graph, controller table, host/guest
> provisioning, worker management, gateway, mail. None of those
> responsibilities require the OS-level meaning of "daemon" (a
> long-running detached background process).*

The §JS-not-the-daemon observation: with the Rust `endor`
supervisor, the same JS code is hosted in *two distinct ways*:

1. **In-process XS machine** on a dedicated `std::thread`
   (`endor daemon`'s default) — *there is no separate OS process
   for the JS at all*.
2. **Node.js child of `endor`** under `ENDO_MANAGER_NODE=1` —
   *the JS is supervised by Rust and is plainly not the daemon*.

*In both cases the Rust side is the daemon and the supervisor.
The JS side is the orchestration layer that the supervisor
hosts.*

The §Rust-already-calls-it-manager precedent: Rust source uses
`ManagerMode`, `ENDO_MANAGER_NODE`, `spawn_inproc_xs_manager`.
*The JS side has not caught up*. The §asymmetric-vocabulary-
across-boundary problem: same code is called "daemon" on the JS
side and "manager" on the Rust side, *confusing anyone
straddling the boundary*.
