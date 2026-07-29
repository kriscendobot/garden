---
title: Resolution, dereferencing, and metadata
source_kind: web
source_url: https://www.w3.org/TR/did-1.0/
source_content_sha256: 5e44345740d9bfaa852d3b66c57e98c9beb6c5bf6083b0126dd5daac377b9993
source_authors: [W3C Decentralized Identifier Working Group]
source_date: 2022-07-19
ingested: 2026-07-29
ingested_by: scholar
topics: [decentralized-identifiers, networking]
status: current
---

> Abstract: Resolution returns a DID document plus DID-document, DID-resolution, and DID-method metadata; DID URL dereferencing returns a resource plus resource metadata, with errors represented in the corresponding metadata structures.

Resolution and dereferencing are related but distinct algorithms. A resolver first obtains the current DID document according to the method, while dereferencing a DID URL may select a verification method, service, or other resource and may invoke a service endpoint. The Recommendation specifies the result shapes but leaves method implementation details to DID methods.

Source: [DID Core](https://www.w3.org/TR/did-1.0/) (W3C Recommendation, 19 July 2022), content SHA-256 `5e443457`.
