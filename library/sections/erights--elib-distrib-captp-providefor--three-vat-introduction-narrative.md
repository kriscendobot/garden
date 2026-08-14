---
title: "provideFor(): the three-vat introduction narrative"
source_kind: web
source_url: http://erights.org/elib/distrib/captp/provideFor.html
source_effective_url: https://erights.github.io/erights-org-website/elib/distrib/captp/provideFor.html
source_fetched_via: mirror
source_content_sha256: 3aa67ebe83527efd6b4c8bd3c22040222581a6b901cb8db2bad1c531b7334972
source_authors: [Mark S. Miller]
source_date: 2004-01-01
ingested: 2026-08-14
ingested_by: scholar
topics: [captp, ocapn, capability-theory, capability-security]
status: current
notes: |
  Derived from — but not — Mark S. Miller's public-domain erights.org CapTP page
  (`elib/distrib/captp/provideFor.html`; the page states its unattributed / Miller
  text is placed in the public domain). Fetched 2026-08-14 via the
  erights.github.io GitHub Pages mirror (erights.org refuses sandbox connections);
  idempotency anchor is source_content_sha256, not a commit. The primary erights
  account of how the three-vat Granovetter introduction is layered on the two-vat
  CapTP protocol, and the source of the `donorPath`/`vatASearchPath` route-list
  that grounds the concept [[relative-routing]].
---

## Abstract

The primary erights.org account of the **three-vat Granovetter introduction** in
CapTP: how, when Alice, Bob, and Carol live on three separate vats, one peer
introduces a second peer to a third by *depositing* a reference and letting the
recipient *withdraw* it — layered entirely on the pairwise two-vat CapTP
protocol. It grounds [[three-party-handoff]] (the modern OCapN enactment) and,
crucially for [[relative-routing]], it is where the introduction message carries
a **search path** (`vatASearchPath` / `donorPath`) — a *list of routes to the
donor* rather than a single absolute address — because at the moment the
introduction is redeemed the host vat may not yet be connected to the donor and
must be told *how to reach it*.

## The layering

> Of course, to implement the Granovetter diagram for all cases, we must deal
> with the case where Alice, Bob, and Carol are on three separate machines.
> However, we can do this mostly by layering the three-vat protocol on top of
> the [two-vat] protocol. CapTP directly provides mechanisms for support of
> remote object messages between a pair of machines. The protocol needed to do
> a three-vat Granovetter introduction is then implemented out of such pairwise
> object messages.

Between every pair of vats there is at most one inter-vat CapTP connection, and
all live references between that pair are multiplexed over it. Each side of each
connection exports a **NonceLocator** at incoming position 0, so the remote vat
can drive the three-vat protocol using ordinary two-vat messages.

## The worked introduction

Alice says `carol <- w(); bob <- x(carol); carol <- y()`, and Bob's `x` method
does `carol <- z()`. E-Order requires Carol receive `w()` before `y()` or
`z()`; when the three are on three vats, the protocol must enforce this **even
if VatB does not obey the protocol** — the encoding of `x` must only enable VatB
to cause messages to reach Carol *after* `w()` has already been delivered.

To serialize `x`, **VatA generates a nonce** — a randomly chosen use-once number
— and sends it to *both* VatB and VatC:

- to **VatB**, inside a `Promise3Desc`/`Far3Desc` as the argument's
  representation, saying in effect *"get the argument from VatC by asking it for
  the object associated with this nonce"*;
- to **VatC**, as a `provideFor` message to VatC's NonceLocator for the
  VatA/VatC connection, saying *"provide VatB access to Carol when he asks for
  the object associated with this nonce"*:

```e
def vine := locator <- provideFor(carol, vatBVatID, nonce)
```

VatB unserializes the descriptor by **initiating a connection to VatC** and
sending VatC's NonceLocator an `acceptFrom` message asking for the object VatA
made available at that nonce:

```e
def c2 := locator <- acceptFrom(vatASearchPath, vatAVatID, carolNonce, vine)
```

The unserialization of the argument is *the promise for the result of this
`acceptFrom`*, so VatB can send Bob `x(c2)` immediately without blocking on the
search for VatC. If `acceptFrom` arrives before the matching `provideFor`, VatC
creates a table entry associating the nonce with a local promise (remembering
its resolver) and returns that promise, so `z()` queues in VatC while it waits —
minimizing the latency cost of enforcing E-Order. When the matching `provideFor`
arrives it resolves the promise to Carol, and the queued `z()` is re-sent to
Carol. E-Order safety rests on the two-vat protocol's FIFO delivery, which makes
the reference carried by `provideFor` itself a reference to *post-`x` Carol*.

## Source

Derived from — but not — `http://erights.org/elib/distrib/captp/provideFor.html`
(Mark S. Miller, public domain), content SHA-256 `3aa67ebe`, fetched via the
erights.github.io mirror on 2026-08-14.
