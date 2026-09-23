---
title: Architectural considerations
source_kind: web
source_url: https://www.w3.org/TR/did-1.0/
source_content_sha256: 5e44345740d9bfaa852d3b66c57e98c9beb6c5bf6083b0126dd5daac377b9993
source_authors: [W3C Decentralized Identifier Working Group]
source_date: 2022-07-19
ingested: 2026-07-29
ingested_by: scholar
topics: [decentralized-identifiers, identity]
status: current
---

> Abstract: The informative architecture explains how a DID subject, controller, DID document, verifiable data registry, resolver, and service endpoints relate without making any one registry architecture mandatory.

The DID document is a controller-published description, not the subject itself. Controllers and subjects may coincide or differ, and a subject may have several controllers. The architecture also makes explicit the boundary between resolving the document and discovering or serving other information about the subject through a service.

Source: [DID Core](https://www.w3.org/TR/did-1.0/) (W3C Recommendation, 19 July 2022), content SHA-256 `5e443457`.
