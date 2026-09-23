---
title: Descriptors
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

Several operations (e.g. `desc:import-object` and `desc:export`) are describing
importing and exporting objects. There had to be a choice if these actions
should be described from the sender's or receiver's side, in this case we
choose the receiver's side. This means if an object is exported from
Alice to Bob, Alice sends a `desc:import-object` as Alice is describing
it from Bob's perspective.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
