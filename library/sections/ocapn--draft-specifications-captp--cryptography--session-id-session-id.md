---
title: "[Session ID](#session-id)"
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

The Session ID for a session is a [ByteArray][Model-ByteArray] of length 32.

1. Calculate the Public Identifier of each side using [the process described here](#public-identifier).
2. Sort both IDs based on the resulting octets.
3. Concatinate the Public Identifiers in the order determined in step 2.
4. Prepend the string "prot0" to the beginning.
5. SHA256 hash the result from step 4.
6. SHA256 hash the result from step 5.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
