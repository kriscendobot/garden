---
title: Representation of public keys (Multikey and did:key encoding)
source_kind: web
source_url: https://atproto.com/specs/did
source_content_sha256: 624594bb04584d272731005ef390469357db8c9937211516ad94c5984fc3fedf
source_authors: [Bluesky Social PBC]
source_date: 2026-07-28
retrieved: 2026-07-28
ingested: 2026-07-28
ingested_by: scholar
topics: [decentralized-identifiers, identity]
status: current
---

> Abstract: How an atproto DID document encodes a public key: a `verificationMethod` object of type `Multikey` whose `publicKeyMultibase` uses "the same encoding scheme as used with `did:key`, but without the `did:key:` prefix". The practical takeaway is that a `did:key` string and an atproto `Multikey` value are the same bytes with a different wrapper, which is why the two DID worlds can exchange key material even though atproto does not bless `did:key` as an account method.

Public keys in DID documents under `verificationMethod`, including atproto signing keys, are represented as an object with the following fields:

| Field | Required | Value |
|---|---|---|
| `id` | yes | the DID followed by an identifying fragment. Use `#atproto` as the fragment for atproto signing keys |
| `type` | yes | the fixed string `Multikey` |
| `controller` | yes | DID controlling the key, "which in the current version of atproto must match the account DID itself" |
| `publicKeyMultibase` | yes | the public key itself, encoded in "multikey" format |

> "The `publicKeyMultibase` format for `Multikey` is the same encoding scheme as used with `did:key`, but without the `did:key:` prefix."

The encoding procedure, from the companion [cryptography specification](https://atproto.com/specs/cryptography): compress the public key point to bytes, prepend the varint-encoded multicodec value (`[0x80, 0x24]` for `p256`, `[0xE7, 0x01]` for `k256`), encode the combined bytes with `base58btc`, and prefix with a `z` character. Prepending `did:key:` to that string yields the full `did:key` identifier.

A legacy format exists with slightly different requirements (P-256 and K-256 keys with `base58btc` encoding prefixed with `z`), which parsers are expected to accept alongside the current `Multikey` form.

The spec also notes that there is not yet a formal W3C standard for expressing P-256 public keys under some of these conventions, which is worth keeping in mind before treating the encoding as settled cross-ecosystem ground.

Source: [https://atproto.com/specs/did](https://atproto.com/specs/did), content SHA-256 `624594bb`.
