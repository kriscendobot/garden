---
section: daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
source: endo-but-for-bots--llm-designs-daemon-capability-bus
topics: [daemon, capability-security]
status: current
title: The incremental syscall migration — the unbounded phase
parent: endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
---

§Phase 4 (logging) and §Phase 5 (progressive syscall migration) lay
out the *daemon-progressively-assumes-platform-I/O* arc:

- **Phase 4 — logging**. Workers send `[0, "log", {level, message},
  0]` to the daemon instead of writing to stderr. Daemon collects
  logs, writes them to per-worker log files and/or a unified log
  with structured metadata. Demonstrates the syscall pattern.

- **Phase 5 — open-ended candidate list**:

| Syscall | Replaces | Rationale |
|---------|----------|-----------|
| `fs.read` / `fs.write` | `node:fs` | Most impactful; enables daemon-side caching and access control |
| `net.listen` / `net.connect` | `node:net` | Enables daemon-side socket management |
| `crypto.random` / `crypto.hash` | `node:crypto` | Small surface, easy to verify |

Each syscall: define verb + payload; implement handler in daemon;
replace Node.js call in bus powers with envelope send; verify
manager functions identically. *This phase is unbounded — it
proceeds as far as is useful without requiring completion.*

The §Security Considerations section names the security payoff:
*workers that obtain all I/O through daemon syscalls can be fully
confined — they need no direct access to the filesystem or network*.
The daemon controls process configuration; macOS `sandbox-exec`,
Linux namespaces + seccomp can confine workers. Handles are
unforgeable within the envelope protocol: *a worker can only address
handles that the daemon has explicitly routed to it*. This provides a
capability discipline *at the daemon level* that complements CapTP's
object-capability discipline *within the JavaScript layer* — two
ocap-disciplined layers stacked.
