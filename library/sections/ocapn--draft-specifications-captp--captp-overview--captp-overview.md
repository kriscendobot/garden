---
title: CapTP Overview
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

A CapTP session consists of two entities exchanging CapTP messages over a
reliable, in-order OCapN Netlayer channel (details of which are specified in the
OCapN Netlayer specification).

Here's an overview of some things which may occur during a CapTP session:

1. A session is established pairwise between two peers.
2. Communication occurs between objects.
    -   Initial connectivity to objects is established by querying the bootstrap
        object for access to known objects (via sturdyrefs or certificates).
    -   Messages are exchanged between objects which hold references to each
        other.
    -   Promises may be created when messages are sent.
    -   Messages may be pipelined to promises, queueing those messages to
        eventually be delivered to their resolution.
    -   Handoffs are initiated when sending a message with a reference to an
        object outside of the CapTP session.
    -   Both parties cooperate to free object references which are recognized to
        no longer be needed on at least one side
5.  A session ends.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
