---
id: relative-routing
aliases: ["relative routing", "relative route", "search path", "searchPath", "vatASearchPath", "donorPath", "donor path", "route list", "candidate routes", "nearest reliable path", "shortest path to a peer", "connection hints as routes", "choosing a route not an address", "path-based session establishment"]
topics: [captp, ocapn, networking, capability-theory]
---

# relative-routing

Mark Miller's framing that a session with a third party is established by
**choosing a route** — the nearest, shortest, most reliable path currently
available — rather than by dialing a single fixed *absolute* address. A peer is
named by a durable, location-independent identity (its public key / VatID); *how
to reach it* is carried separately as a **set of candidate routes** from which
the connecting party selects the best one that works. Addressing is not
identity: the identity is stable, the routes are ephemeral and plural. The term
is *relative* because a route is expressed relative to where the connecting
party already is and what it can already reach — a path good enough to get there
from here, not a globally-canonical coordinate.

> **Derived from, not the original.** This page abstracts Mark Miller's
> public-domain erights.org CapTP writing and the OCapN drafts; it is a
> derived synthesis, not those primary texts. Read the linked erights sections
> for the source wording.

## Where erights writes about it

The concrete artifact is in the **three-vat Granovetter introduction**. When
Alice introduces Bob to Carol across three separate vats, Bob's vat must open a
session to Carol's host vat and *withdraw* the deposited reference. The withdraw
operation's first argument is a route list:

```e
NonceLocator <- acceptFrom(donorPath :String[], donorID :VatID, nonce :Nonce, vine :Vine)
```

Miller's own note: *"We include the `donorPath` in case the `acceptFrom` message
arrives in Carol's vat before Alice's vat has even connected."* In the companion
narrative the same argument is named `vatASearchPath`: *"At the time that the
`acceptFrom` message arrives at VatC, VatC and VatA may not yet be connected, so
VatB sends to VatC the information needed to connect to VatA."* The host vat is
handed *how to find* the donor — a **search path** — because the donor is not
assumed to sit at one already-reachable absolute address. Identity (`donorID`,
`VatID`) travels separately from reachability (`donorPath`). This is the same
separation the E tutorial and the Pluribus protocol draw between a durable
capability/VatID and the transport that currently carries it.

## How it maps onto CapTP / OCapN connection hints

The modern OCapN locator is the direct descendant of the search path. A **peer
locator** names a peer by a self-authenticating designator (its public key) plus
a transport, and carries **hints** — *"a mapping of information that should be
flexible to include any additional information that's required to route to and
initialize a session"* (the designator and transport alone must differentiate
two locations; hints are *not* used for identity). Endo's locator URL encodes
this as inline `@hint` / `at=` parameters, and the daemon treats them as
**ephemeral transport addresses**: the formula identity is stored durably, the
hints are *not* stored with it — they are looked up fresh each time a locator is
produced for sharing. A locator can therefore carry *several* candidate routes,
and the connecting party picks the best available; a peer that moved (Wi-Fi →
cellular → Tor) keeps its identity and simply advertises new hints. Relative
routing is the frame for *why* a locator carries a plural, replaceable route set
rather than one address.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [erights/captp/acceptFrom donorPath](../sections/erights--elib-distrib-captp-acceptfrom--acceptfrom-donorpath-relative-route.md) | **The primary artifact.** `acceptFrom(donorPath :String[], ...)` — a route list handed to the host vat so it can reach the donor even before a connection exists; a path of candidate routes, not an absolute address. |
| [erights/captp/three-vat introduction narrative](../sections/erights--elib-distrib-captp-providefor--three-vat-introduction-narrative.md) | The `provideFor`/`acceptFrom` deposit-and-withdraw narrative in which `vatASearchPath` appears; the E/Pluribus ancestor of the OCapN handoff. |
| [erights/ode-protocol Pluribus](../sections/erights--elib-capability-ode-ode-protocol--distributed-pluribus-cryptographic-protocol.md) | Pluribus: identity as VatID + swiss number carried over a transport that can change — the identity-vs-reachability split relative routing rests on. |
| [ocapn/locators/peer-locator](../sections/ocapn--draft-specifications-locators--peer-locator.md) | The peer locator: a peer named for connection establishment; identity (designator + transport) distinct from the hints that route to it. |
| [ocapn/captp/third-party-handoffs](../sections/ocapn--draft-specifications-captp--third-party-handoffs.md) | The modern enactment of the three-vat introduction; the Receiver opens its own session to the Exporter, which is where a route must be chosen. |
| [endo/daemon-locator/connection-hints-are-ephemeral](../sections/endo-but-for-bots--llm-designs-daemon-locator-reference--endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel--the-connection-hints-are-ephemeral-discipline.md) | Endo's discipline: identity stored durably, `at=` hints looked up fresh when sharing — addressing is not identity. |
| [endo/dlt/locator-format-evolution](../sections/endo-but-for-bots--llm-designs-dlt--locator-format-evolution.md) | The `endo://{peerKey}/{formulaAddress}@{hint1}@{hint2}` URL: multiple inline hints as candidate routes on one locator. |
| [endo/ocapn-noise/transport-plugins-and-hints](../sections/endo-but-for-bots--llm-designs-ocapn-noise-network--transport-plugins-and-hints.md) | Per-transport plugins keyed by scheme; a locator's hints select which transport/route establishes the Noise session. |
| [endo/dani/per-agent-connection-hints](../sections/endo-but-for-bots--llm-designs-dani--per-agent-connection-hints-and-null-local-node--per-agent-connection-hints.md) | Per-agent connection hints: each agent advertises its own reachable routes; the null-local-node sentinel for the co-located case. |

## See also

- [[three-party-handoff]] — the introduction protocol whose withdraw step is where a route is chosen; relative routing is *how* the Receiver reaches the Exporter it was told about.
- [[sturdyref]] — the offline counterpart: a sturdyref persists identity + a locator, and re-routing to a live reference on re-acquisition is a relative-routing choice made fresh at connect time.
- [[granovetter-operator]] — only connectivity begets connectivity; relative routing is the transport-layer question of *which* connectivity to use once the introduction grants it.
- [[noise-ik-session-establishment]] — once a route is chosen, this is the handshake that establishes the encrypted session over it.
- [[subject-routing]] — a sibling "route the effect to where the subject lives" problem in dialog-db; different domain, same identity-says-who-not-where split.

## Common confusions

- **"A route is the peer's identity."** No — identity is the durable designator (public key / VatID); the route (donorPath / hint) is ephemeral and replaceable. Two locators with the same designator but different hints name the *same* peer reachable by different paths.
- **"Relative routing means source routing / picking every hop."** No — it means the *destination* is named by candidate routes rather than one absolute address; the connecting party selects the nearest reliable one. It does not mandate hop-by-hop source routing (though the erights `donorPath` is literally a `String[]` sequence).
- **"Hints disambiguate which peer you mean."** No — in OCapN the designator and transport alone must differentiate two locations; hints are *only* for reaching a peer already unambiguously identified, never for identity.
