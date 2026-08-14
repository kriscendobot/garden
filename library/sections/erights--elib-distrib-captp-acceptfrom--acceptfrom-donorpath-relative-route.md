---
title: "acceptFrom(): the donorPath / search-path route list"
source_kind: web
source_url: http://erights.org/elib/distrib/captp/acceptFrom.html
source_effective_url: https://erights.github.io/erights-org-website/elib/distrib/captp/acceptFrom.html
source_fetched_via: mirror
source_content_sha256: 0f1876e8cc61c7d87ef9990d682fa014e3253dff81c5e65c3eb55d511aa3c369
source_authors: [Mark S. Miller]
source_date: 2004-01-01
ingested: 2026-08-14
ingested_by: scholar
topics: [captp, ocapn, capability-theory, capability-security]
status: current
notes: |
  Derived from — but not — Mark S. Miller's public-domain erights.org CapTP page
  (`elib/distrib/captp/acceptFrom.html`; the page places its unattributed / Miller
  text in the public domain). Fetched 2026-08-14 via the erights.github.io GitHub
  Pages mirror; idempotency anchor is source_content_sha256. The op whose first
  argument is `donorPath :String[]` — the route list a redeeming vat is handed so
  it can reach the donor even before a connection exists. Primary grounding for
  [[relative-routing]].
---

## Abstract

The CapTP operation by which the recipient vat **withdraws** the reference the
donor deposited (the mirror of [[three-party-handoff]]'s withdraw step), and the
narrowest, most concrete erights grounding for [[relative-routing]]: its first
parameter is **`donorPath :String[]`** — an ordered *list of routing strings*
for reaching the donor's vat, *"in case the acceptFrom message arrives in
Carol's vat before Alice's vat has even connected."* The reference to the donor
is not an absolute address the host already knows how to reach; it is a **path
of candidate routes** carried alongside the introduction, from which the
connecting party establishes a session.

## The operation

```e
NonceLocator <- acceptFrom(donorPath :String[],
                           donorID   :VatID,
                           nonce     :Nonce,
                           vine      :Vine) :any
```

> VatB picks up the reference to Carol deposited by VatA at `nonce` in VatC's
> from-VatA-for-VatB table.

with a `swissHash`-carrying variant reserved for after the (unimplemented)
`WormholeOp`; until then the plain form above is used.

## Why a path, not an address

> `donorPath`, `donorID` identifies Alice. We include the `donorPath` in case
> the `acceptFrom` message arrives in Carol's vat before Alice's vat has even
> connected (which it is presumably in the process of doing, since it is
> presumably sending the corresponding `provideFor`).

In the companion narrative the same argument appears as `vatASearchPath`: *"At
the time that the `acceptFrom` message arrives at VatC, VatC and VatA may not yet
be connected, so VatB sends to VatC the information needed to connect to VatA."*
The host vat is handed *how to find* the donor — a search path — rather than
assuming the donor sits at one already-reachable address. This is the E/Pluribus
ancestor of the modern OCapN locator's **connection hints**: a locator carries
several candidate routes, and the connecting party selects the best available
(see [[relative-routing]], and the peer-locator / connection-hints sections
below).

## Source

Derived from — but not — `http://erights.org/elib/distrib/captp/acceptFrom.html`
(Mark S. Miller, public domain), content SHA-256 `0f1876e8`, fetched via the
erights.github.io mirror on 2026-08-14.
