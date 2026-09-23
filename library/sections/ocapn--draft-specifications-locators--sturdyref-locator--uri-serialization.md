---
title: URI Serialization
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

The URI format follows a similar format to the peer URI format, except with a
"/s/" suffix to denote that it's a sturdyref, followed by the swiss number
value. Any hints are placed at the end of the URI.

The URI format is as follows:
```
;; Without hints (i.e. hints are set to false)
ocapn://<designator>.<transport>/s/<swiss-num>

;; With hints
ocapn://<designator>.<transport>/s/<swiss-num>?hint1=value1&hint2=value2
```

Any value within any string should be escaped, if needed, according to RFC3986.

Source: `draft-specifications/Locators.md` at commit `f7005c12` (held at kriscendobot/ocapn).
