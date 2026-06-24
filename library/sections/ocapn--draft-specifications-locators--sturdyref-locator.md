---
title: Sturdyref Locator (Syrup + URI serialization)
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
kind: index
section_count: 3
---

> Abstract: The sturdyref locator: how a specific capability is named for re-acquisition across sessions. Both Syrup and URI serializations. Sturdyrefs are stronger than live-session capabilities: they survive connection drops, can be persisted, and can be transferred to other peers. The discipline around sturdyrefs is central to durable ocap design.

Sections:

- [Sturdyref Locator](ocapn--draft-specifications-locators--sturdyref-locator--sturdyref-locator.md)
- [Syrup Serialization](ocapn--draft-specifications-locators--sturdyref-locator--syrup-serialization.md)
- [URI Serialization](ocapn--draft-specifications-locators--sturdyref-locator--uri-serialization.md)

Source: `draft-specifications/Locators.md` at commit `f7005c12` (held at kriscendobot/ocapn).
