---
title: Establishing a connection
source: "draft-specifications/CapTP Specification.md"
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, captp]
status: current
notes: Maps to @endo/captp package: makeCapTP returns dispatch/getBootstrap/abort; this section is the wire-level account of what those three do.
parent: ocapn--draft-specifications-captp--captp-overview
---

A new connection is established either by:

- Using an out-of-band mechanism to bootstrap the connection
- Performing a third party handoff

In either situation, a secure channel needs to be created to the endpoint.
This is out of scope for this specification but it's covered by the OCapN
Netlayers specification. Once a secure channel is established, each side
MUST perform the following steps in order:

1.  Create a per-session cryptography key pair (see
    [Cryptography](#cryptography))
2.  Send a [`op:start-session`](#opstart-session) message
3.  Receive and verify the remote endpoints's
    [`op:start-session`](#opstart-session)
4.  Export the bootstrap object at position `0`.

Once these steps are successfully completed, the connection is considered
established and set up, and can be used to send and receive messages with remote
objects.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
