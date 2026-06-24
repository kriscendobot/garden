---
title: "[`desc:sig-envelope`](#desc-sig-envelope)"
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
notes: 7 H2 descriptors consolidated. Each independently looked-up-able by H2 anchor.
parent: ocapn--draft-specifications-captp--descriptors
---

This encapsulates a CapTP object and provides a signature. The signature is
created on the binary data of the serialized CapTP object in the `signed` field.

The process of generating this is:

1.  Fully serialize to a CapTP object to Syrup octets.
2.  Sign the result of step 1 using the private key.
3.  Create a `desc:sig-envelope` with the (original, unserialized) CapTP object
    and signature.

```text
<desc:sig-envelope signed      ; captp-object
                   signature>  ; Signature (see cryptography section)
```

When this is received, the signature must be valid using the corresponding
public key. If the signature is not valid, the operation should be aborted.

NOTE: The value of `signed` should be the object itself (opposed to the binary
data produced via serialization in step 1).  Syrup itself provides
canonicalization, which allows for serialization to always produce the same
result.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
