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
topics: [ocapn, captp]
status: current
notes: Maps to Endo's connection-establishment layer in CapTP; the Syrup serialization is referenced in the @endo/syrups and @endo/syrup-frame packages.
parent: ocapn--draft-specifications-locators--peer-locator
---

The URI serialization is a URI form designed to be provided to users to be given
out of band to bootstrap a CapTP session.

The URI format is as follows:
```
;; Without hints (i.e. hints are set to false)
ocapn://<designator>.<transport>

;; With hints
ocapn://<designator>.<transport>?hint1=value1&hint2=value2
```

This is a URI with the scheme `ocapn` followed by the designator, a `.` and then
the transport name. If any  hints exist they're added as part of the query
parameters, otherwise emitted. 

Note that the designator permits `.` to be used within it, however the final `.`
should designate the separator  between the designator segment and the transport
identifier.

Source: `draft-specifications/Locators.md` at commit `f7005c12` (held at kriscendobot/ocapn).
