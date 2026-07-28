---
title: Canonicalization, the signed envelope, and CID-addressed tokens
source: README.md
source_repo: ucan-wg/spec
source_commit: 9955aa1fb7b32897f80b57651f4ee8b22ebf35a7
source_date: 2026-07-08
source_authors: [Brooklyn Zelenka, Irakli Gozalishvili, Daniel Holmgren, Philipp Kruger]
ingested: 2026-07-28
ingested_by: scholar
topics: [ucan-authorization, content-addressed-storage, marshal]
status: current
---

> Abstract: The wire format of UCAN 1.0: a required cryptosuite (SHA-256; Ed25519, P-256, or secp256k1; `did:key` as the only required DID method), DAG-CBOR canonical encoding for signing, and a two-element envelope `[Signature, {VarsigHeader, TokenPayload}]` tagged `ucan/<subspec>@<version>`. The load-bearing fact for any addressing taxonomy: a UCAN token is itself content-addressed, as CIDv1 / base58btc / SHA-256 / DAG-CBOR, so "all CIDs encoded as above start with the characters `zdpu`". This is also where 1.0 breaks with the JWT-shaped 0.10 line.

## Cryptosuite

> "Across all UCAN specifications, the following cryptosuite MUST be supported:"

| Role | REQUIRED algorithms | Notes |
|---|---|---|
| Hash | SHA-256 | |
| Signature | Ed25519, P-256, `secp256k1` | "Preference of Ed25519 is RECOMMENDED" |
| DID | `did:key` | |

`did:key` being the only required DID method is a substantive narrowing: a UCAN principal is a raw public key wearing DID syntax, with no resolution step and no rotation. UCAN 1.0 deliberately did not take on the mutable-authority half of the DID world, and that is exactly why chain verification has no resolver in it.

## Encoding

> "All UCANs MUST be canonically encoded with DAG-CBOR for signing. A UCAN MAY be presented or stored in other IPLD formats (such as DAG-JSON), but converted to DAG-CBOR for signature validation."

This is the break with UCAN 0.10, whose abstract described providing capabilities "by extending the familiar JWT structure". The 1.0 envelope is an IPLD structure, not a JWT, and the two are not wire-compatible.

## Content identifiers

> "A UCAN token MUST be configured as follows:"

| Parameter | REQUIRED configuration |
|---|---|
| Version | CIDv1 |
| Multibase | `base58btc` |
| Multihash | SHA-256 |
| Multicodec | DAG-CBOR |

> "All CIDs encoded as above start with the characters `zdpu`."

> "The resolution of these addresses is left to the implementation and end-user, and MAY (non-exclusively) include the following: local store, a distributed hash table (DHT), gossip network, or RESTful service."

So a UCAN sits at an unusual place in an addressing taxonomy: it is neither a content address for data nor a connection hint, but transferable authority whose own identifier is the hash of the certificate. Invocations reference their proofs by CID, and revocations name the delegation they kill by CID.

Token resolution is transport-specific and left to a UCAN transport specification, which must define at minimum a request protocol, a response protocol, and a collections format. "Note that if an instance cannot dereference a CID at runtime, the UCAN MUST fail validation."

## Envelope

> "All UCAN formats MUST use the following envelope format:"

| Field | Type | Description |
|---|---|---|
| `.0` | `Bytes` | "A signature by the Payload's `iss` over the `SigPayload` field" |
| `.1` | `SigPayload` | "The content that was signed" |
| `.1.h` | `VarsigHeader` | "The Varsig v1 header" |
| `.1.ucan/<subspec-tag>@<version>` | `TokenPayload` | "The UCAN token payload" |

```js
[
  { "/": {"bytes": "bdNVZn+uTrQ8bgq5LocO2y3gqIyuEtvYWRUH9YT+SRK6v/SX8bjt+VZ9JIPVTdxkWb6nhVKBt6JGpgnjABpOCA"}},
  {
    "h": {"/": {"bytes": "NAHtAe0BE3E"}}, // i.e. signed with Ed25519, encoded with DAG-CBOR
    "ucan/example@1.0.0": {
      "hello": "world"
    }
  }
]
```

## Minimum payload fields

| Field | Type | Required | Description |
|---|---|---|---|
| `iss` | `DID` | yes | "Issuer DID (sender)" |
| `aud` | `DID` | yes | "Audience DID (receiver)" |
| `sub` | `DID` | yes | "Principal that the chain is about (the Subject)" |
| `cmd` | `String` | yes | "The Command to eventually invoke" |
| `args` | `{String : Any}` | yes | "Any Arguments that MUST be present in the Invocation" |
| `nonce` | `Bytes` | yes | Nonce |
| `meta` | `{String : Any}` | no | "Meta (asserted, signed data) is not delegated authority" |
| `nbf` | `Integer` | no | "'Not before' UTC Unix Timestamp in seconds (valid from)" |
| `exp` | `Integer \| Null` | yes | "Expiration UTC Unix Timestamp in seconds (valid until)" |

Source: [`README.md`](https://github.com/ucan-wg/spec/blob/9955aa1fb7b32897f80b57651f4ee8b22ebf35a7/README.md) at commit `9955aa1f`.
