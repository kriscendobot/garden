---
title: "[Public Key](#public-key)"
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

Public keys are formatted based on gcrypt's s-expression format, using EdDSA
public keys and the SHA512 hash algorithm. The EdDSA public keys are based on
the Ed25519 elliptic curve. The public key is formatted as follows:

```text
['public-key ['ecc ['curve 'Ed25519] ['flags 'eddsa] ['q q_value]]]
```

In the above format, the `q_value` is a [ByteArray][Model-ByteArray] value of
32 bytes, representing the public key.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
