---
title: Per-agent connection hints
source: designs/daemon-agent-network-identity.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5ab5e48d80c5d925bcec2d142606d7555bfad7ed
source_date: 2026-03-18
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
parent: endo-but-for-bots--llm-designs-dani--per-agent-connection-hints-and-null-local-node
---

Each agent / persona can independently manage **connection hints**
that control how peers reach them on the network. This builds on
per-agent NETS (see
[[endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets]]):
each agent's NETS directory determines *which transports it
advertises*; the connection hints determine *what policy applies* to
those transports.

Three example policies:

- **Require anonymizing relay.** A pseudonymous persona requires all
  inbound connections through a relay; the daemon's network address
  is never revealed.
- **Allow direct connections.** A named persona accepts direct TCP
  for lower latency.
- **Prefer specific transports.** A persona prefers WebSocket over
  raw TCP, or vice versa.

Connection hints are stored per-agent alongside the keypair:

```typescript
type AgentConnectionHints = {
  publicKey: string;                // 64-char hex Ed25519 public key
  requireRelay?: boolean;           // force connections through relay
  allowDirectConnect?: boolean;     // accept direct inbound connections
  preferredTransports?: string[];   // ordered list of transport preferences
  relayAddresses?: string[];        // specific relay nodes to use
};
```

Hints are **advisory** — the network layer uses them to configure
listener behavior and to advertise appropriate addresses to peers,
**but the agent's keypair is the ultimate identity**. A peer that
ignores the hint and connects via an unauthorized transport will
still terminate at the right agent if it presents the right keypair
during the OCapN-Noise handshake; the hints simply make the *expected
path* explicit and overridable per persona.
