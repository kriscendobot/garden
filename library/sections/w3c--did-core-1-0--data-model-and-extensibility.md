---
title: Data model and extensibility
source_kind: web
source_url: https://www.w3.org/TR/did-1.0/
source_content_sha256: 5e44345740d9bfaa852d3b66c57e98c9beb6c5bf6083b0126dd5daac377b9993
source_authors: [W3C Decentralized Identifier Working Group]
source_date: 2022-07-19
ingested: 2026-07-29
ingested_by: scholar
topics: [decentralized-identifiers]
status: current
---

> Abstract: DID documents are abstract data-model objects whose required `id` and optional core properties may be extended, but extensions cannot weaken the normative meaning of core properties.

The specification separates abstract data-model semantics from JSON and JSON-LD representations. Extensions can define additional properties or values, subject to collision and processing rules; consumers that do not recognize an extension can still process the core document when its required semantics are intact.

Source: [DID Core](https://www.w3.org/TR/did-1.0/) (W3C Recommendation, 19 July 2022), content SHA-256 `5e443457`.
