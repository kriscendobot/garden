---
title: "[`desc:import-object`](#desc-import-object)"
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

Any object which is exported over CapTP is described with a positive integer.
This positive integer MUST be unique to this CapTP session and refer to this
specific object.

```text
<desc:import-object position>  ; position: positive integer
```

Position `0` is reserved for the [bootstrap object](#bootstrap-object).

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
