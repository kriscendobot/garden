---
title: "[`op:abort`](#opabort)"
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
notes: 9 H2 ops consolidated into one section. op:start-session, op:deliver, op:abort, op:listen, op:get, op:index, op:untag, op:gc-exports, op:gc-answers. Each is independently looked-up-able by the H2 anchor within the consolidated body.
parent: ocapn--draft-specifications-captp--operations
---

This is used to abort a CapTP session, when this is sent the connection should
be severed and any per session information (e.g. session key pair, etc.) should
be removed.

The `op:abort` message is:

```text
<op:abort reason>  ; reason: String
```

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
