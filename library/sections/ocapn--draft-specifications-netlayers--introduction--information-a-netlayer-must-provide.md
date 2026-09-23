---
title: Information a netlayer must provide
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
parent: ocapn--draft-specifications-netlayers--introduction
---

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
