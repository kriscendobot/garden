---
title: Introduction (Properties and Required Information)
source: draft-specifications/Netlayers.md
source_repo: kriscendobot/ocapn
source_commit: d05a6d3efd749540358e72aaa5c1201e118c8d95
source_date: 2024-10-01
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn]
status: current
notes: Maps to the @endo/netstring (framing), @endo/stream / @endo/stream-node (transport), and noise-protocol-based netlayer (integrity + confidentiality) in the endo packages.
---

> Abstract: What a netlayer is required to provide: reliable in-order message streams; integrity and (optionally) confidentiality of messages; explicit information passed to the protocol layer (per-connection metadata, identity). Plus a list of properties netlayers must satisfy to be acceptable.

# Introduction

OCapN Netlayers are the transport layer which ensures messages are sent and
delivered to a peer. The requirements put upon netlayers is very low and thus it
should be flexible enough for new netlayers on a lot of different transport
protocols. CapTP is designed in such a way that it is agnostic over which
netlayer it is using and designed in such a way that multiple different
netlayers could be used at the same time between different peers.

## Properties of a netlayer

A netlayer should ensure the following properties are provided:

- Bidirectional transmission and receipt of messages
- Messages sent should be delivered while the session remains active
- Messages should be received in the order in which they were sent
- The session must be secure in that messages can only be inserted by the
  participants in the session

Properties that are considered important to the operating principles of OCapN,
but are not technical requirements for a compliant netlayer, are:

- The reachability of peers without further configuration by any peer within the
  scope of the network they operate on.

Other properties may be desirable, however not strictly nessesary to comply with
this specification, these may include:

- That messages are encrypted or otherwise unaccessable other peers who are not
  the recipient

## Information a netlayer must provide

Netlayers could come in any shape and size from attaching messages to carrier
pidgeons (with system to check they're not lost on route, of course), to over
Libp2p, Tor Onion services, or even TCP. A netlayer should specify all the
information required for new implementations to exist and communicate with other
implementations of that same netlayer provided they operate on the same network.

Other information that must be provided is the information which should be
encoded within an OCapN peer locator, this is:

- Designator
- Transport
- Hints

Since hints is just a mapping of information, this should be flexible to include
any additional information that's required to route to and initialize a session.

Note: the `designator` field conventionally is a self-authenticating designator,
such as a cryptographic public key, however this is not required. It is
important and worth noting that the designator and transport alone MUST be
enough to differenciate between two locations, hints are not used for that.


Source: `draft-specifications/Netlayers.md` at commit `d05a6d3e` (held at kriscendobot/ocapn).
