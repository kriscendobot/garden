---
title: "`fetch` Method"
source: "draft-specifications/CapTP Specification.md"
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, captp, capability-security]
status: current
parent: ocapn--draft-specifications-captp--bootstrap-object
---

This method is used to fetch an object from the bootstrap object. To use it you
need a `swiss-number` which is a Binary Data type. This swiss number should
correspond an object which exists in this session. The result will be the object
which corresponds to this `swiss-number` or an error if the object does not
exist or a swiss number was not provided.

An example of how to use this method is:

```text
<op:deliver <desc:export 0>          ; Remote bootstrap object
            ['fetch                  ; Argument 1: Symbol "fetch"
             swiss-number]           ; Argument 2: Binary Data
            3                        ; Answer position: positive integer
            <desc:import-object 5>>  ; resolver exported by us at position 5 should receive the answer
```

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
