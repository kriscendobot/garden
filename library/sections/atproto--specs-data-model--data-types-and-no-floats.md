---
title: Data types, the no-floats rule, and reserved dollar-sign fields
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

> Abstract: The Lexicon-to-DASL-to-JSON-to-CBOR type table, and the three rules that fall out of content addressing. Floats are excluded outright because "de-serializing in to machine-native format, then later re-encoding, is not always consistent" even for normal values on less-common architectures, so round-tripping would break the hash. Field names beginning with `$` are reserved to the protocol and unknown ones must be ignored, which is the extension point. And null, missing, and false-y are three distinct states in both representations.

| Lexicon Type | DASL Type | JSON | CBOR | Note |
|---|---|---|---|---|
| - | null | Null | Special Value (major 7) | |
| `boolean` | boolean | Boolean | Special Value (major 7) | |
| `integer` | integer | Number | Integer (majors 0,1) | signed, 64-bit |
| `string` | string | String | UTF-8 String (major 3) | Unicode, UTF-8 |
| - | float | Number | Special (major 7) | not allowed in atproto |
| `bytes` | bytes | `$bytes` Object | Byte String (major 2) | |
| `cid-link` | link | `$link` Object | CID (tag 42) | CID |
| `array` | list | Array | Array (major 4) | |
| `object` | map | Object | Map (major 5) | keys are always strings |
| `blob` | - | `$type: blob` Object | `$type: blob` Map | |

"As a best practice to ensure Javascript compatibility with default types, `integer` should be limited to 53 bits of precision." JSON numbers can have arbitrarily many digits, but `integer` is limited to 64 bits even ignoring JavaScript.

Lexicons can add validation constraints on individual fields (minimum and maximum values, string `format` types). "Data can not be validated against these additional constraints without access to the relevant Lexicon schema, but there is a concept of validating free-form JSON or CBOR against the atproto data model in an abstract sense."

## Reserved `$` fields

> "Data field names starting with `$` are reserved for use by the data model or protocol itself, in both JSON and CBOR representations. For example, the `$bytes` key name (used in CBOR and JSON), the `$link` key (used for JSON CID Links), or `$type` (used to indicate record type). Implementations should ignore unknown `$` fields (to allow protocol evolution). Applications, extensions, and integrations should not use or unilaterally define new `$` fields, to prevent conflicts as the protocol evolves."

## Nullable and false-y

> "In the atproto data model there is a semantic difference between explicitly setting an map field to `null` and not including the field at all. Both JSON and CBOR have the same distinction."

"Null or missing fields are also distinct from 'false-y' value like `false` (for booleans), `0` (for integers), empty lists, or empty objects."

## Why no floats

> "The IPLD specification describes some of the complexities and sharp edges when working with floats in a content-addressable world. In short, de-serializing in to machine-native format, then later re-encoding, is not always consistent. This is definitely true for special values and corner-cases, but can even be true with 'normal' float values on less-common architectures."

> "It may be possible to come up with rules to ensure reliable round-trip encoding of floats in the future, but for now we disallow floats. If you have a use-case where integers can not be substituted for floats, we recommend encoding the floats as strings or even bytes. This provides a safe default round-trip representation."

This is content addressing propagating a constraint upward into the schema language: because the identity of a record is the hash of its canonical encoding, any type whose canonical encoding is not stable across a decode/encode round trip cannot be in the type system at all.

Source: [https://atproto.com/specs/data-model](https://atproto.com/specs/data-model), content SHA-256 `519f0d90`.
