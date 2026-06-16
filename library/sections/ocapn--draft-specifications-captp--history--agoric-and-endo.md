---
title: Agoric and Endo
source: "draft-specifications/CapTP Specification.md"
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn]
status: current
parent: ocapn--draft-specifications-captp--history
---

Agoric carried forward the designs of E into the land of Javascript, including
bringing forward CapTP and promise pipelining. Agoric did much of the research
and development of what later became Endo, a secure JavaScript platform for
secure communication. An analysis of Agoric/Endo's implementation of
[CapTP](https://github.com/endojs/endo/tree/master/packages/captp) was
instrumental to the design of the version of CapTP seen in OCapN.

While at Agoric, Mark S. Miller also provided the re-conceptualization of
promise pipelining in CapTP as using "handoff tables", which later formed the
conceptual basis of the "gifting" mechanism implemented in OCapN's CapTP.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
