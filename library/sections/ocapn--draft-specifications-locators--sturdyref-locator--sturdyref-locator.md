---
title: Sturdyref Locator
source: draft-specifications/Locators.md
source_repo: kriscendobot/ocapn
source_commit: f7005c122a7b8050d927c6358d4856d9b5475136
source_date: 2025-12-03
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, captp, capability-security]
status: current
notes: Maps to the durable-Exo material in exo-taxonomy and to agoric-sdk's vat-data baggage abstraction; sturdyrefs are the wire-level representation that durable exos serialize and re-acquire.
parent: ocapn--draft-specifications-locators--sturdyref-locator
---

A sturdyref locator includes a [Peer Locator](#peer-locator) and
a `swiss-num` which represents a specific object located at that
peer. This should be considered a capability with this information
alone being used to obtain a CapTP reference the given object.

The pieces of information encoded in the sturdyref are:

- [Peer Locator](#peer-locator)
- Swiss number: string used to obtain an object

Source: `draft-specifications/Locators.md` at commit `f7005c12` (held at kriscendobot/ocapn).
