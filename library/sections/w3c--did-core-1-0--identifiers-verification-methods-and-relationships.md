---
title: Identifiers, verification methods, and relationships
source_kind: web
source_url: https://www.w3.org/TR/did-1.0/
source_content_sha256: 5e44345740d9bfaa852d3b66c57e98c9beb6c5bf6083b0126dd5daac377b9993
source_authors: [W3C Decentralized Identifier Working Group]
source_date: 2022-07-19
ingested: 2026-07-29
ingested_by: scholar
topics: [decentralized-identifiers, identity, capability-security]
status: current
---

> Abstract: DID documents identify themselves with `id`, may name controllers, and express public verification material through verification methods and purpose-specific relationships such as authentication, assertion, key agreement, capability invocation, and capability delegation.

A verification method has an identifier, a type, a controller, and method-specific verification material. Verification relationships authorize a method for a purpose; they can embed a method or refer to one. The distinction matters: possession of public key material alone is not the same as authorization to authenticate, make assertions, agree keys, invoke a capability, or delegate one.

Source: [DID Core](https://www.w3.org/TR/did-1.0/) (W3C Recommendation, 19 July 2022), content SHA-256 `5e443457`.
