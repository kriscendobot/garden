---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design relative routing for CapTP/OCapN locator hints

Repository: endojs/endo-but-for-bots. Target the roadmap branch `llm` per this
project's usual designer convention (draft PR against `llm`).

## Background

The library already carries the conceptual grounding for this:
`journal/library/concepts/relative-routing.md` (Mark Miller's framing — a
session is established by *choosing a route* from a plural, ephemeral set of
candidate hints, not by dialing one fixed absolute address; identity is
durable, reachability is not), the erights `acceptFrom`/`donorPath` /
`vatASearchPath` grounding it derives from, and the `topics/captp.md` /
`topics/ocapn.md` topic pages. Read these first (library-lookup) — this design
is the next step past that survey: an actual mechanism, not just the framing.

## Problem

Today a locator carries connection hints, but nothing filters them by whether
they are *reachable from here*. A vat/daemon needs some notion of **where it
is** — its own local context/scope — so it can filter a peer's hints down to
the ones that are locally applicable, and prefer the cheapest/closest route
that actually works over a hop through a public relay.

## Cases the design must cover

Design a mechanism general enough to solve at least these relative-routing
cases, and expressive enough that more can be added later without a redesign:

1. **Same-LAN peers** — two vats/daemons on the same local network should be
   able to find each other directly, without a hop out through NAT to a relay.
2. **Workers under a shared supervisor** — sibling worker processes with a
   common supervisor should be able to route among themselves over a domain
   socket, or be introduced to each other over a named pipe, rather than
   through the network stack at all.
3. **Daemons on a host behind a shared gateway** — similarly, daemons sharing
   a host/gateway should be introducible to each other locally.
4. **Loopback / same-host recognition** — recognize when a peer is reachable
   via `ws://127.0.0.1` (or equivalent loopback form), i.e. same host, even
   same process.
5. **A home hub on the local network** — a peer reachable through a hub on the
   same LAN (a step between "same process" and "public relay").
6. **Routing to a remote gateway's children, through the gateway** — reaching
   a peer that is itself only reachable via introduction through a gateway it
   sits behind, rather than directly.

## What the design needs to specify

- **How a vat/daemon expresses "where it is"** — a scope/context model it can
  compare against a hint's claimed scope. This is the missing half: locators
  already carry hints; nothing today carries the *receiver's* location to
  filter or rank against them.
- **How routes are expressed and encoded** in a locator's connection hints,
  for each case above (LAN, domain-socket/named-pipe, loopback, LAN hub,
  gateway-relayed) — extending or refining Endo's existing `@hint`/`at=`
  locator-hint encoding (see the CapTP/OCapN library material) rather than
  inventing a parallel scheme where the existing one already fits.
- **How hints are filtered/ranked** — given a set of candidate hints and the
  local vat's own scope, how it picks (or orders, for fallback) the routes
  worth trying, cheapest/most-local first.
- **Security implications** — a hint that only works from inside a supervisor
  or LAN must not leak capability to reach something outside that scope by
  virtue of being included in a locator that travels further than intended;
  say explicitly what a scope boundary does and does not authorize.

## Deliverable

A design document per the designer role's usual shape (problem statement,
scope, design, alternatives considered, open questions), self-contained enough
for a later `build` job to implement from. Where a case above turns out to need
its own follow-on design once this one settles the shared scope/filtering
model, say so explicitly in Open Questions rather than trying to force every
case's full protocol detail into one document.
