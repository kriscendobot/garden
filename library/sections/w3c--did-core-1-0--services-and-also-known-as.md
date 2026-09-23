---
title: Services and alsoKnownAs
source_kind: web
source_url: https://www.w3.org/TR/did-1.0/
source_content_sha256: 5e44345740d9bfaa852d3b66c57e98c9beb6c5bf6083b0126dd5daac377b9993
source_authors: [W3C Decentralized Identifier Working Group]
source_date: 2022-07-19
ingested: 2026-07-29
ingested_by: scholar
topics: [decentralized-identifiers, identity, networking]
status: current
---

> Abstract: The optional `service` property is a set of typed Service Endpoint maps for communicating with a DID subject or associated entity, while `alsoKnownAs` is a set of URI assertions whose presence does not prove their truth.

Each service entry has an `id`, a `type`, and a `serviceEndpoint`; the endpoint can be a URI, a map, or a set containing either. DID Core calls this a communication/interactions mechanism, not evidence that an endpoint is honest, live, or controlled by the claimed entity. Likewise, an `alsoKnownAs` value is only an assertion. Applications needing a binding must verify it with a protocol such as ATProto's reciprocal handle validation.

Source: [DID Core](https://www.w3.org/TR/did-1.0/) (W3C Recommendation, 19 July 2022), content SHA-256 `5e443457`.
