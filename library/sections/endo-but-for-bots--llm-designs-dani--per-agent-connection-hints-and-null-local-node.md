---
title: Per-agent connection hints and the null local-node sentinel (origin of LOCAL_NODE)
source: designs/daemon-agent-network-identity.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5ab5e48d80c5d925bcec2d142606d7555bfad7ed
source_date: 2026-03-18
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
---

## Per-agent connection hints

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

## The null local-node sentinel — origin and rationale

With multiple agent public keys on one daemon, there is no single
canonical `localNodeNumber` to embed in locally-stored formula keys.
Using any specific agent's public key would create an artificial
dependency between formula storage and agent identity. This is the
problem that the **LOCAL_NODE sentinel** solves.

> *Use 64 characters of `'0'` (`'0'.repeat(64)`) as a sentinel local
> node value in locally-stored formula keys. This is analogous to how
> `0.0.0.0` works in networking — a "this host" placeholder that is
> never a valid Ed25519 public key (since the all-zeros point is not
> on the curve).*

The `0.0.0.0`-as-this-host analogy is the framing this design
*introduces* for the sentinel discipline. It is the same idea later
landed by [[endo-but-for-bots--llm-designs-dlt--local-node-sentinel]],
but the analogy itself — and the supporting argument that
`'0'.repeat(64)` *cannot* be a valid Ed25519 key because the
all-zeros point is not on the curve — appears here first.

```js
const LOCAL_NODE = /** @type {NodeNumber} */ ('0'.repeat(64));
```

## Formula key construction

```js
// Local formula key (stored on disk)
const localId = formatId({ number: formulaNumber, node: LOCAL_NODE });

// Locator for external consumption (agent-specific)
const locator = formatId({
  number: formulaNumber,
  node: agentPublicKey,
});
```

## `isLocalId` simplification

```js
// Current
const isLocalId = id => parseId(id).node === localNodeNumber;

// Proposed
const isLocalId = id => parseId(id).node === LOCAL_NODE;
```

The proposed form drops the daemon-instance-specific
`localNodeNumber` comparison in favour of a constant sentinel,
removing a dependency on daemon-startup state.

## Inbound and outbound normalization

```js
// Inbound: locator → local formula key, recognizing any local agent's key
const normalizeInboundId = id => {
  const { number, node } = parseId(id);
  if (isKnownLocalKey(node)) {
    return formatId({ number, node: LOCAL_NODE });
  }
  return id; // remote formula, keep as-is
};

// Outbound: local formula key → locator, stamping the sharing agent's key
const externalizeId = (id, agentPublicKey) => {
  const { number, node } = parseId(id);
  if (node === LOCAL_NODE) {
    return formatId({ number, node: agentPublicKey });
  }
  return id; // remote formula, keep as-is
};
```

The pair is the basis of the externalize/internalize discipline
landed by [[endo-but-for-bots--llm-designs-dlt--local-node-sentinel]];
this design is its **origin document** and the place where the
`0.0.0.0` analogy is recorded.

## Cluster pattern: sentinel-with-rationale

The pattern *"use a deliberately-unreachable value as a sentinel,
with a rationale for why it cannot collide with valid values"* shows
up twice in the daemon design cluster:

| Design | Sentinel | Why it cannot collide |
|---|---|---|
| This design / dlt | `LOCAL_NODE = '0'.repeat(64)` for local-node component | All-zeros is not a point on the Ed25519 curve |
| The 26 formula types ([[endo-but-for-bots--llm-designs-d256--formula-types-and-security]]) | (no analogue) | n/a |

Future ingests of daemon material should record similar
"deliberately-unreachable-sentinel + rationale" pairs explicitly,
since the rationale is *what licenses* the use of the sentinel and
should not be implicit. See the **patterns** topic for related
discipline ([[endo-but-for-bots--llm-designs-dlt--local-node-sentinel]] —
stable internal id, externalized per identity).
