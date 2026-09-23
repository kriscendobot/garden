---
title: Implementing OCapN
source: implementation-guide/Implementation Guide.md
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, captp]
status: current
notes: Frames the upstream protocol as three sub-specifications (CapTP / Netlayers / Locators). Soft-flag overlap with ocapn--draft-specifications-model--* (the abstract model) and with the per-spec source files.
parent: ocapn--implementation-guide--overview
---

This is an opinionated guide on how a prospective implementer could go about implementing a fully compliant CapTP implementation. It is highly recommended to read through the specifications before using this guide as it is useful to get a sense of what is *required* by the specification, as opposed to what is merely *suggested* by this guide.

To help implementation the guide is broken into distinct stages which can be tested on their own against the conformance test suite.

Source: [implementation-guide/Implementation Guide.md](https://github.com/ocapn/ocapn/blob/8704f69e01f93701de8bc5eb4bb22b9927a2665a/implementation-guide/Implementation%20Guide.md) at commit `8704f69e`.
