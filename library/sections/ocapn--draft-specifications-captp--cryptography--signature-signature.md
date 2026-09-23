---
title: "[Signature](#signature)"
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

Signatures are formatted using gcrypt's s-expression format and the EdDSA
signature scheme. The formatted signature s-expression follows this structure:

```text
['sig-val ['eddsa ['r r_value] ['s s_value]]]
```

In the above format, the `r_value` and `s_value` are [ByteArray][Model-ByteArray] values each of 32 bytes,
representing the signature parameters.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
