---
title: Data model security considerations and possible future changes
source_kind: web
source_url: https://atproto.com/specs/data-model
source_content_sha256: 519f0d9076e77840bd5e296ca2631997266c28a01e7d259249d44a47bbe5ec74
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
topics: [endpoint-security, data-structures]
status: current
---

> Abstract: One security note and three admitted open ends. Parsing untrusted CBOR is a resource-consumption attack surface: "It is recommended to use a library that automatically protects against huge allocations, deep nesting, invalid references, etc.", with the warning sharpened for languages without strong memory safety, "Note that high-level languages frequently wrap parsers written in lower-level languages." The future-changes list keeps three doors open: floats may return in some form, the legacy blob format may be removed if every known record can be rewritten, and additional hash types are likely to join the blessed CID set.

## Security and privacy considerations

> "There are a number of resource-consumption attacks possible when parsing untrusted CBOR content. It is recommended to use a library that automatically protects against huge allocations, deep nesting, invalid references, etc. This is particularly important for libraries implemented in languages without strong memory safety, such as C and C++. Note that high-level languages frequently wrap parsers written in lower-level languages."

"Best practices for validating and limiting the size and structure of generic atproto data are described in a Data Validation guide, which is not formally part of this specification."

## Possible future changes

- "Floats may be supported in one form or another."
- "The legacy 'blob' format may be entirely removed, if all known records and repositories can be rewritten."
- "Additional hash types are likely to be included in the set of 'blessed' CID configurations."

The second item is the one worth watching. It states the condition under which a content-addressed corpus can retire a format mistake at all: only if every extant record is rewritable, which in a federated network of independently-hosted repositories is a strong claim.

Source: [https://atproto.com/specs/data-model](https://atproto.com/specs/data-model), content SHA-256 `519f0d90`.
