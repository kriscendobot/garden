---
section: stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui
source: endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge
topics: [agent-conventions]
status: current
title: The §invocation surface
parent: endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge--stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui
---

```sh
endo agent rpc [--guest <name>] [--no-session]
```

Standard input takes commands as LF-delimited JSON; standard
output emits responses and events as LF-delimited JSON. Standard
error carries logs separate from the protocol. *The host that
spawns `endo agent rpc` manages the child process.*

The §Out of scope paragraph names what's *not* in this transport:

- *MCP server compatibility.* Pi declines MCP; Endo declines too
  at the protocol level. *A user who wants MCP can write an Endo
  guest plugin that translates.* (Cycle 121's keystone's §Pi-
  specific moves Endo declines named this stance explicitly.)
- *Process-management features.* The host spawning `endo agent
  rpc` manages the child process; the Endo side does not
  implement parent management (no PTY, no resize, no bg).

The two declines are both *don't-duplicate-existing-host-
mechanisms* decisions: MCP is *separable as a guest plugin*;
process management is *the spawning host's responsibility*.
