---
title: Ending a session
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
notes: Maps to @endo/captp package: makeCapTP returns dispatch/getBootstrap/abort; this section is the wire-level account of what those three do.
parent: ocapn--draft-specifications-captp--captp-overview
---

Finally, a session may end due to an unrecoverable error or because
either side wishes to end it. Both situations are covered by the
[`op:abort`](#opabort) message. When this is received the session
should be severed and unresolved promises broken.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
