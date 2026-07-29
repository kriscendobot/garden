---
title: "JSON representation: dollar-link and dollar-bytes instead of DAG-JSON"
source_kind: web
source_url: https://atproto.com/specs/data-model
source_content_sha256: 519f0d9076e77840bd5e296ca2631997266c28a01e7d259249d44a47bbe5ec74
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
topics: [data-structures, content-addressed-storage]
status: current
---

> Abstract: atproto declines DAG-JSON and defines its own JSON conventions for exactly two types. A link is `{"$link": "<base32 CID string>"}` and a byte string is `{"$bytes": "<base64>"}` (RFC-4648 section 4, not URL-safe, padding optional). The stated motivation is readability: the DAG-JSON spec "is primarily oriented toward debugging and development environments, and we found that the use of `/` as a field key was confusing to developers". Key sorting and other normalizations are not required in JSON, "only DRISL-CBOR is used as a byte-reproducible representation".

> "Atproto uses its own conventions for JSON, instead of using DAG-JSON directly. The main motivation was to have more idiomatic and human-readable representations for `link` and `bytes` in HTTP APIs. The DAG-JSON specification itself mentions that it is primarily oriented toward debugging and development environments, and we found that the use of `/` as a field key was confusing to developers."

> "Normalizations like key sorting are also not required or enforced when using JSON in atproto: only DRISL-CBOR is used as a byte-reproducible representation."

## `link`

The JSON encoding for link is an object with the single key `$link` and the string-encoded CID as a value:

```json
{
  "exampleLink": {
    "$link": "bafyreidfayvfuwqa7qlnopdjiqrxzs6blmoeu4rujcjtnci5beludirz2a"
  }
}
```

"For comparison, this is very similar to the DAG-JSON encoding, but substitutes `$link` as the key name instead of `/` (single-character, forward slash)."

## `bytes`

The JSON encoding for bytes is an object with the single key `$bytes` and a string value with the base64-encoded bytes. "The base64 scheme is the one specified in RFC-4648, section 4, frequently referred to as simple 'base64'. This scheme is not URL-safe, and `=` padding is optional."

```json
{
  "exampleBytes": {
    "$bytes": "nFERjvLLiw9qm45JrqH9QTzyC2Lu1Xb4ne6+sBrCzI0"
  }
}
```

"For comparison, the DAG-JSON encoding has two nested objects, with outer key `/` (single-character, forward slash), inner key `bytes`, and the same base64 encoding."

Source: [https://atproto.com/specs/data-model](https://atproto.com/specs/data-model), content SHA-256 `519f0d90`.
