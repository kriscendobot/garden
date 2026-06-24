---
title: "[`desc:import-promise`](#desc-import-promise)"
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
notes: 7 H2 descriptors consolidated. Each independently looked-up-able by H2 anchor.
parent: ocapn--draft-specifications-captp--descriptors
---

When a promise is exported over a CapTP boundary is it described with a
`desc:import-promise` message. This message contains a positive integer which is
unique to the exporting party within the CapTP session and refers to
this specific promise.

```text
<desc:import-promise position>  ; position: positive integer
```

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
