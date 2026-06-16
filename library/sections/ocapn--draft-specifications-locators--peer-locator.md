---
title: peer Locator (Syrup + URI serialization)
source: draft-specifications/Locators.md
source_repo: kriscendobot/ocapn
source_commit: f7005c122a7b8050d927c6358d4856d9b5475136
source_date: 2025-12-03
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, captp]
status: current
notes: Maps to Endo's connection-establishment layer in CapTP; the Syrup serialization is referenced in the @endo/syrups and @endo/syrup-frame packages.
kind: index
section_count: 3
---

> Abstract: The peer locator: how a peer is named for incoming connection establishment. Two serializations: Syrup (for use within OCapN protocol traffic) and URI (for use in human-typed addresses, configuration, etc.). The peer locator identifies the peer; CapTP messages flow over a connection that the locator establishes.

Sections:

- [[peer Locator](#ocapn-peer)](ocapn--draft-specifications-locators--peer-locator--peer-locator-ocapn-peer.md)
- [[Syrup Serialization](#peer-syrup-serialization)](ocapn--draft-specifications-locators--peer-locator--syrup-serialization-peer-syrup-serialization.md)
- [URI Serialization](ocapn--draft-specifications-locators--peer-locator--uri-serialization.md)

Source: `draft-specifications/Locators.md` at commit `f7005c12` (held at kriscendobot/ocapn).
