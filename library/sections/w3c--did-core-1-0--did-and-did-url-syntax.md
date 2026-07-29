---
title: DID and DID URL syntax
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

> Abstract: A DID is `did:` plus a lowercase method name and method-specific identifier; a DID URL adds path, query, and fragment components for locating a resource or service within the DID namespace.

The core grammar gives generic parsers a stable boundary while leaving the method-specific identifier opaque to them. A DID URL is not merely a DID with decoration: its extra components identify a resource associated with the DID, and dereferencing it may require method-defined processing in addition to resolution.

Source: [DID Core](https://www.w3.org/TR/did-1.0/) (W3C Recommendation, 19 July 2022), content SHA-256 `5e443457`.
