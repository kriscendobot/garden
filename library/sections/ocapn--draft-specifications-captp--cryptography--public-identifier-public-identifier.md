---
title: "[Public Identifier](#public-identifier)"
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
parent: ocapn--draft-specifications-captp--cryptography
---

The Public Identifier for a peer is a [ByteArray][Model-ByteArray] of length 32.

1. Serialize the per session public key [as described here](#public-key).
2. SHA256 hash of the result produced in step 1.
3. SHA256 hash of the result produced in step 2.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
