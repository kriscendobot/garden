---
title: Cryptography (public keys, identifiers, session IDs, signatures)
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
---

> Abstract: Cryptographic primitives CapTP requires: Public Key (peer identity at the cryptographic layer), Public Identifier (the form used in locators), Session ID (per-session disambiguator), Signature (used in sig-envelope descriptor). 4 H2 sub-sections consolidated.

# [Cryptography](#cryptography)

Each party within a CapTP session has their own per session key pair which is
used for signing certain structures for example in the [third party handoffs
section](#third-party-handoffs). These key pair values are generated EdDSA with
a SHA512 hash.

**NOTE:** These representations are considered temporary and we are anticipating
replacing them, probably with record-based representations.

## [Public Key](#public-key)

Public keys are formatted based on gcrypt's s-expression format, using EdDSA
public keys and the SHA512 hash algorithm. The EdDSA public keys are based on
the Ed25519 elliptic curve. The public key is formatted as follows:

```text
['public-key ['ecc ['curve 'Ed25519] ['flags 'eddsa] ['q q_value]]]
```

In the above format, the `q_value` is a [ByteArray][Model-ByteArray] value of
32 bytes, representing the public key.

## [Public Identifier](#public-identifier)

The Public Identifier for a peer is a [ByteArray][Model-ByteArray] of length 32.

1. Serialize the per session public key [as described here](#public-key).
2. SHA256 hash of the result produced in step 1.
3. SHA256 hash of the result produced in step 2.

## [Session ID](#session-id)

The Session ID for a session is a [ByteArray][Model-ByteArray] of length 32.

1. Calculate the Public Identifier of each side using [the process described here](#public-identifier).
2. Sort both IDs based on the resulting octets.
3. Concatinate the Public Identifiers in the order determined in step 2.
4. Prepend the string "prot0" to the beginning.
5. SHA256 hash the result from step 4.
6. SHA256 hash the result from step 5.

## [Signature](#signature)

Signatures are formatted using gcrypt's s-expression format and the EdDSA
signature scheme. The formatted signature s-expression follows this structure:

```text
['sig-val ['eddsa ['r r_value] ['s s_value]]]
```

In the above format, the `r_value` and `s_value` are [ByteArray][Model-ByteArray] values each of 32 bytes,
representing the signature parameters.


Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
