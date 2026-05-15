---
title: Network registration — `registerAgentKey` so the network layer can route inbound connections
source: designs/daemon-agent-network-identity.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5ab5e48d80c5d925bcec2d142606d7555bfad7ed
source_date: 2026-03-18
source_authors: [Kris Kowal]
topics: [daemon, ocapn, capability-security]
status: current
---

Once a daemon hosts multiple agents, each with its own Ed25519
keypair, **the network layer needs to know which agent an inbound
connection is targeting.** A remote peer connects with a specific
public key in mind; without registration, the network has no way to
route the connection.

## Registration flow

> *Each installed network (accessible through the NETS formula) needs
> to know the public keys of all active agents so the network layer
> can accept and negotiate connections on behalf of any persona.*

1. **On agent creation**, the daemon registers that agent's public
   key with *every installed network*.
2. **Each agent tracks its own set of retained agents** (via its pet
   store) and maintains the list of known keys for each installed
   network *incrementally*.
3. **On inbound connection**, the network identifies the target local
   agent by matching the target public key against its registry.

## Interface

```typescript
interface EndoNetwork {
  // ... existing methods ...
  registerAgentKey(
    publicKey: string,
    agentId: FormulaIdentifier
  ): Promise<void>;
  unregisterAgentKey(publicKey: string): Promise<void>;
}
```

The interface is **additive**:

> *Networks that do not support multi-key registration simply ignore
> the calls. The daemon root keypair is always registered as the
> default.*

This shape — *new capability optional, old default preserved* — is the
same backward-compatible-extension pattern that
[[endo-but-for-bots--llm-designs-dlt--method-additions]] uses: never
break existing method signatures; layer new affordances on as
non-required extensions.

## Why this is its own concern

Network registration is *not* the same as peer authentication. The
OCapN-Noise handshake (see
[[endo-but-for-bots--llm-designs-ocapn-noise-network--session-establishment]])
authenticates that a peer holds a specific keypair. Registration
answers the prior question: *which of the agents on this daemon is
this inbound connection trying to reach?* The OCapN-Noise handshake
then proves that the agent is who it says it is.

This separation is the same split-by-responsibility pattern that the
daemon design cluster repeats elsewhere:

- `CryptoPowers` generates keypairs; `DaemonicPersistencePowers` stores
  them (see [[endo-but-for-bots--llm-designs-d256--identifier-migration-and-crypto-powers]]).
- Per-agent NETS controls *which addresses are advertised* (see
  [[endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets]]);
  network registration controls *which agent receives an inbound
  connection*.

## Dependencies

This work depends on two prior designs:

- [[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]] —
  provides the per-agent Ed25519 keypairs.
- [`ocapn-network-transport-separation`](endo-but-for-bots--llm-designs-ntsep--design-conceptual-model)
  — the network abstraction layer that will implement
  `registerAgentKey`. (See the ntsep design's conceptual-model
  section for the four-layer OCapN hierarchy that this interface
  lives in.)

It is also blocked on
[[endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets]]
because the *agents to register keys for* are discovered via the
agent's NETS membership, not via a daemon-wide registry.

## See also

- [[per-agent-keypair]] — the cryptographic substrate this registration interface routes against.
- [[delegates-and-epithets]] — agents that need network registration are precisely the agents that may carry epithets and present verifiable identity claims.
- [[caretaker-pattern]] — `registerAgentKey` is *additive* on the `EndoNetwork` interface; networks without multi-key support ignore the calls — the same backward-compatible-extension shape as `dlt`'s method-additions discipline.
