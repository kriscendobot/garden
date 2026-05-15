---
role: designer-security
status: seed
authored: 2026-05-15
---

# Designer landing: capability-security and policy engineering

## When this landing is your starting point

You are designing a capability-policy mechanism, a revocation
discipline, a confined-capability allowlist or trust-on-first-bind
flow, an authentication or authorization boundary, an
anti-impersonation property, or any threat-model claim. If the
question is *"who is allowed to do what, and how is that enforced?"*
or *"what stops a hostile peer from doing X?"*, the material below is
your corner of the library.

## Start here (read first, in this order)

1. **[`capability-security`](../topics/capability-security.md)** topic page — by far the densest topic in the library (117 sections). Skim the *Sections* table to see the corpus shape; the table itself is the orienting move.
2. **[delegates-and-epithets](../concepts/delegates-and-epithets.md)** — Endo's identity-relationship model: obligatory + verifiable + deniable claims on Handles, propagated through delegation chains. The *deniability* axis is what distinguishes this from naive signature schemes.
3. **[revocation-by-withdrawal](../concepts/revocation-by-withdrawal.md)** — the fourth revocation mechanism alongside caretakers / revocation lists / expiry. Stronger than caretakers (which must remain alive) and revocation lists (which must propagate).
4. **[caretaker-pattern](../concepts/caretaker-pattern.md)** — Handle / HandleControl split; identity / action facet split for connectors. The capability-security pattern that makes revocation effective without delegate cooperation.
5. **[six-aspects-of-sharing](../concepts/six-aspects-of-sharing.md)** — the Karp/Stiegler/Close taxonomy: *dynamic, chained, cross-domain, composable, attenuated, accountable, revocable*. A working checklist for any new delegation mechanism.

## Topics in scope

- **[`capability-security`](../topics/capability-security.md)** — the canonical home (117 sections).
- **[`hardened-javascript`](../topics/hardened-javascript.md)** — the substrate; lockdown, taming, intrinsics-discipline (90 sections).
- **[`patterns`](../topics/patterns.md)** — interface guards, method-shape matching; many security claims live in patterns (29 sections).
- **[`persistence`](../topics/persistence.md)** — formula store is the authority for what's durable; revocation discipline rests on it.
- **[`captp`](../topics/captp.md)** + **[`ocapn`](../topics/ocapn.md)** — wire-level security boundaries and cross-peer authentication.
- **[`agent-conventions`](../topics/agent-conventions.md)** — security-relevant agent identity (`@keypair`, `NETS`, `@self`).

## Concepts in scope

- [delegates-and-epithets](../concepts/delegates-and-epithets.md) — agent identity with verifiable + deniable relationship claims.
- [caretaker-pattern](../concepts/caretaker-pattern.md) — Handle / HandleControl + identity / action facet splits.
- [revocation-by-withdrawal](../concepts/revocation-by-withdrawal.md) — the fourth revocation mechanism.
- [six-aspects-of-sharing](../concepts/six-aspects-of-sharing.md) — Karp/Stiegler/Close checklist.
- [formula-persistence-thesis](../concepts/formula-persistence-thesis.md) — *user agency over retention, fast convergence, timely revocation* — security framing of the daemon's persistence strategy.
- [cohort-destruction](../concepts/cohort-destruction.md) — partition response; the boundary at which an unreachable capability becomes inconsequential.
- [four-tables-coordinated-retention](../concepts/four-tables-coordinated-retention.md) — *local agency always authoritative* discipline for cross-peer retention.
- [per-agent-keypair](../concepts/per-agent-keypair.md) — Ed25519 identity per agent; *revoking an agent is revoking its keypair formula*.
- [local-node-sentinel](../concepts/local-node-sentinel.md) — internal storage uses a sentinel rather than any specific agent's key; externalization stamps per agent.
- [pass-invariant-handle-equality](../concepts/pass-invariant-handle-equality.md) — connector guarantee; same backing identity → same formula identifier (relied on for de-duplication without trust).
- [sentinel-with-rationale](../concepts/sentinel-with-rationale.md) — *deliberately-unreachable value + why-it-cannot-collide* — applied whenever you reach for a magic value.

## Cluster overviews

### Daemon security cluster (cycles 46–53)

Nine sources, dense with security claims. Read with the
[`capability-security`](../topics/capability-security.md) topic page open:

- **`dp` daemon-persistence** (PR #3121, **draft**) — the thesis: petname graph as persistence root; user agency over retention; timely revocation. *Frame for everything else.*
- **`dcp` daemon-capability-persona** — Delegates and Epithets: identity claims structurally attached to Handles; daemon-enforced chain propagation prevents epithet stripping.
- **`dcpg` daemon-cross-peer-gc** — *asymmetry of authority* — only the holder knows what they retain; one-way retention set per direction.
- **`dani` daemon-agent-network-identity** — per-agent NETS for advertised hints; persona privacy via empty NETS.
- **`d256` daemon-256-bit-identifiers** — Ed25519 alignment with OCapN-Noise; per-agent keypair formulas.
- **`dlt` daemon-locator-terminology** — LOCAL_NODE sentinel; dehydrate/hydrate boundary.

### Capability-policy cluster

- **`tofb` trust-on-first-bind** — capability-policy pattern; state machine + four decision modes (refuse / auto-add / refer-and-pin / etc.); persisted as ordinary formulas.
- **`gbta` gateway-bearer-token-auth** — agent ID as bearer token via CapTP; per-IP rate limiting; URL fragment placement; `ENDO_GATEWAY=remote` opt-in.

### Foundational papers (related-work cluster, via `dp/six-aspects-of-sharing-and-related-work`)

Waterken (masked partition + orthogonal persistence + web-keys), E
(exposed per-reference partition + sturdy refs + CapTP), Concurrency
Among Strangers, Drexler/Miller market-based GC, Distributed Electronic
Rights, Stiegler petnames. These are the lineage your security
arguments live in; cite them when an aspect of your design has prior
art.

## Conventions and constraints

- **Daemon-implements-the-invariant**: when you propose a security property, the *daemon* should write the formula or hold the facet, not the delegate. The delegate's API must not expose a path that violates the property. Recurs in cohort destruction, the LOCAL_NODE sentinel, epithet-chain propagation.
- **Structural confinement over policy**: prefer mechanisms where the wrong thing is *impossible to express* over mechanisms where the wrong thing is forbidden by policy. The pet-name-paths-as-addressing convention is the canonical example: an agent cannot message a name it does not hold.
- **Local agency authoritative for local retention**: cross-peer mechanisms are advisory to the remote, authoritative to the local; the local user's withdrawal always wins.
- **Sentinels need rationale**: when you reach for a magic value (`LOCAL_NODE`, all-zeros key, end-of-stream marker, etc.), record *why* it cannot collide with a valid value. *Why* licenses the sentinel; without it, a future reader cannot tell whether collision is impossible or merely unlikely.
- **OCapN engagement (per `garden/CLAUDE.md`)**: refer to the upstream protocol obliquely (*"the spec"*, *"the upstream protocol"*, *"the OCapN-family protocol"*); no direct comments or cross-references to `ocapn/ocapn` in outward-facing artifacts.
- **Six-aspects checklist**: before claiming a delegation mechanism is complete, walk the Karp/Stiegler/Close aspects (dynamic / chained / cross-domain / composable / attenuated / accountable / revocable) and note for each which property your design supplies and how.

## Adjacent landings

- **[designer-protocol](designer-protocol.md)** — overlaps heavily on the daemon cluster; protocol design is *how* security claims travel between peers.
- *(pending)* `designer-exo-captp-api` — Exo classes and method guards are how many security properties are *expressed* in code (interface guards, attenuation by Exo facet).
- *(pending)* `designer-language` — DSL design intersects security at policy specification.
