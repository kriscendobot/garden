---
title: Syrup Serialization
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

It's encoded as a record with the label `ocapn-sturdyref` and two arguments:

```
<ocapn-sturdyref peer swiss-num>
```

The arguments are:

- **peer**: Syrup record defined in the [Syrup serialization of the peer locator](#peer-syrup-serialization)
- **swiss-num**: String which identifies the object.

Source: `draft-specifications/Locators.md` at commit `f7005c12` (held at kriscendobot/ocapn).
