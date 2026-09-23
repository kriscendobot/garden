---
title: Introduction
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

OCapN Netlayers are the transport layer which ensures messages are sent and
delivered to a peer. The requirements put upon netlayers is very low and thus it
should be flexible enough for new netlayers on a lot of different transport
protocols. CapTP is designed in such a way that it is agnostic over which
netlayer it is using and designed in such a way that multiple different
netlayers could be used at the same time between different peers.

Source: `draft-specifications/Netlayers.md` at commit `d05a6d3e` (held at kriscendobot/ocapn).
