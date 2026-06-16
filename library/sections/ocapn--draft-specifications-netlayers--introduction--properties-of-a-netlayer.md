---
title: Properties of a netlayer
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

Source: `draft-specifications/Netlayers.md` at commit `d05a6d3e` (held at kriscendobot/ocapn).
