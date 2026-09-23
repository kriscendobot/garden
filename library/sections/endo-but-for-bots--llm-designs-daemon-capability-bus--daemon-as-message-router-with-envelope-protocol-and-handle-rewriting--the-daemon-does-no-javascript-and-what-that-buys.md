---
section: daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
source: endo-but-for-bots--llm-designs-daemon-capability-bus
topics: [daemon, capability-security]
status: current
title: "*the daemon does no JavaScript* — and what that buys"
parent: endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
---

The §What is the Problem Being Solved section lists four pressures:
(1) *process supervision with OS-level control* (signals, resource
limits, sandbox-exec / namespaces / seccomp), (2) *a message-passing
substrate not tied to a Node.js host*, (3) *a path to richer platform
services* progressively assumed by the supervisor (the syscall
migration), and (4) *decoupling from Node.js runtime concerns* — SES
lockdown, V8 quirks, and npm dependency management stay inside
workers where they belong.

The *daemon runs no JavaScript* discipline is the structural
consequence. The daemon is what `endor start` brings up; the
*manager* (the privileged child) is what runs `daemon.js` and owns
the formula graph, pet-name store, and CapTP multiplexer. The manager
can be either Node.js (`bus-daemon-node.js`) or XS-hosted inside the
same Rust binary as the daemon (`endor manager -e xs`). The Rust
daemon and the native Rust/XS worker live in the same binary: `endor`
dispatches to daemon, manager child, worker, or standalone archive
runner by subcommand.
