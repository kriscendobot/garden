---
title: "[peer Locator](#ocapn-peer)"
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
parent: ocapn--draft-specifications-locators--peer-locator
---

This identifies an OCapN peer, not a specific object. This includes enough
information to specify which netlayer and provide that netlayer with all of the
information needed to create a  bidirectional channel to that peer.

The peer locator include the following pieces of information (more details
below):

- **Designator**: Usually representing the key, however can be any value
  determined by the netlayer
- **Transport**: A unique identifier to specify a netlayer
- **Hints**: A hashmap of additional connection information.

When comparing two peer locators, the designator and transport are the only
pieces of information which need to match. Two peer locators can have the same
designator and transport but  different hints and be considered to be the same
peer.

Source: `draft-specifications/Locators.md` at commit `f7005c12` (held at kriscendobot/ocapn).
