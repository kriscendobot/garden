---
title: Per-agent networks — `NETS` special name on every agent
source: designs/daemon-agent-network-identity.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5ab5e48d80c5d925bcec2d142606d7555bfad7ed
source_date: 2026-03-18
source_authors: [Kris Kowal]
topics: [daemon, capability-security, agent-conventions]
status: current
---

Today, `NETS` is a special name only on the **root host**. It points
to a networks directory formula, and **all child hosts created via
`formulateHost` share the same `networksDirectoryId`.** Guests have no
NETS at all.

The goal:

> *Every agent (host and guest) gets its own `NETS` special name
> pointing to its own networks directory.*

This controls which network addresses appear as connection hints in
locators produced by that agent's `locate()`, `locateForSharing()`,
`getPeerInfo()`, and `invite()`.

## Design

1. **Root agent startup.** The root host's NETS directory is the only
   one whose networks are pinned and started on daemon startup — the
   `endo` formula references `networks`. **This is unchanged.**
2. **Agent incarnation.** When *any* agent (host or guest) is
   incarnated, the daemon formulates a new networks directory and
   wires it as the agent's `NETS` special name. The guest formula
   gains a `networks` field (currently absent).
3. **Default contents.** A newly created agent's NETS directory
   starts **empty**. The creating host can populate it (e.g., by
   copying network references from its own NETS) or leave it empty if
   the agent should not be directly reachable.
4. **Connection hint resolution.**
   `getAllNetworkAddresses(networksDirectoryId)` already accepts a
   per-directory ID — the host passes its own `networksDirectoryId`
   to `locateForSharing`, `getPeerInfo`, and invitation construction.
   No change is needed in the resolution path — only in how the
   directory ID is provisioned.
5. **Persona privacy.** An agent with an empty NETS produces locators
   *without* connection hints. Peers must already know how to reach
   the daemon through other means (e.g., they received hints from a
   different agent). **This is the foundation for anonymizing
   personas that never reveal direct addresses.**

## Formula changes

```typescript
// GuestFormula gains a networks field:
interface GuestFormula {
  type: 'guest';
  // ... existing fields ...
  networks: FormulaIdentifier;  // NEW: per-guest networks directory
}

// HostFormula already has networks — no change needed.
```

(See [[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]] for
the existing `HostFormula` / `GuestFormula` shapes; this design adds
one field to `GuestFormula`.)

## Implementation steps

1. `formulateGuestDependencies`: formulate a new networks directory
   and include `networksDirectoryId` in the returned identifiers.
2. `formulateNumberedGuest`: add `networks: identifiers.networksDirectoryId`
   to `GuestFormula`.
3. Guest maker: accept `networksDirectoryId`, wire as `NETS` special
   name.
4. Guest `extractLabeledDeps`: include `['networks', formula.networks]`.

## What this enables

The per-agent NETS is the **identity / advertisement** half of the
persona problem. It pairs with the per-agent keypair from
[[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]] to give
each agent independent control over:

- **Who reaches me** — the keypair (cryptographic identity).
- **How to reach me** — the NETS contents (advertised transports).

Two different agents on the same daemon can present completely
different network footprints — one pseudonymous-via-relay-only,
another publicly-direct-TCP-reachable — while sharing the same
underlying daemon process.

See
[[endo-but-for-bots--llm-designs-dani--per-agent-connection-hints-and-null-local-node]]
for the connection-hint policy layer that complements the NETS-as-set
of-addresses choice. See
[[endo-but-for-bots--llm-designs-dani--network-registration]] for
how the network layer routes inbound connections to the right agent
once multiple agents share a daemon.
