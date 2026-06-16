---
title: "[Syrup Serialization](#peer-syrup-serialization)"
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

It's encoded as a record with the label `ocapn-peer` (symbol) and three
arguments:

```
<ocapn-peer transport   ; symbol (cannot contain ".")
            designator  ; string
            hints>      ; struct | false
```

### Hints

The hints are a [struct](https://github.com/ocapn/ocapn/wiki/Abstract-Syntax#struct-json)
which encode additional connection information that the netlayer might need to
reach the peer. There can be any number of hints, including none at all. If no
hints are used this field can be set to false.

Source: `draft-specifications/Locators.md` at commit `f7005c12` (held at kriscendobot/ocapn).
