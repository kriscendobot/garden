---
title: "[`desc:answer`](#desc-answer)"
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

This is used to refer to a promise which is being pipelined. The position MUST
be the positive integer provided in the [`op:deliver`](#opdeliver) message.
This should not be referenced after the [`op:gc-answer`](#opgc-answer) message
has been sent for this position.

```text
<desc:answer answer-pos> ; position: positive integer
```

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
