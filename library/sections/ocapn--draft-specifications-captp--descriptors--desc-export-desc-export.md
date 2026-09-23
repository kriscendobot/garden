---
title: "[`desc:export`](#desc-export)"
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

When a message is sent across a CapTP boundary that refers to an imported object
within the session the message is being sent to (either a `desc:import-object`
or a `desc:import-promise`), then this should be referred to with a
`desc:export`. The position MUST be the positive integer provided in the import
descriptor.

If an object reference is being sent from a different session, see the [Third
Party Handoffs](#third-party-handoffs) section.

```text
<desc:export position>  ; position: positive integer
```

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
