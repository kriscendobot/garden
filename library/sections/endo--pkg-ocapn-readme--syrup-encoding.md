---
title: Syrup Encoding
source: packages/ocapn/README.md
source_repo: endojs/endo
source_commit: 36db20f1
source_date: 2026-01-08
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, marshal]
status: current
---

> Abstract: How the package handles Syrup serialization (the wire format OCapN uses for some serializations). Maps to the @endo/syrups + @endo/syrup-frame packages.

## Syrup Encoding

[Syrup][] is a binary serialization format tentatively used by OCapN for encoding
messages.
This package includes a partial implementation that is strictly canonical and
limited to forms needed to express the passable value model.

Supported types:

| Syrup Type | JavaScript Type | Encoding |
|------------|-----------------|----------|
| Boolean | `true`, `false` | `t`, `f` |
| Integer | `bigint` | `0+`, `1-`, etc. |
| Double | `number` | `D` + 8 bytes IEEE 754 |
| Bytestring | `Uint8Array` | `3:cat` |
| String | `string` | `3"cat` |
| List | `Array` (frozen) | `[` ... `]` |
| Dictionary | `Object` (frozen) | `{` ... `}` |

Look to the [Syrup codec
README](https://github.com/endojs/endo/blob/master/packages/ocapn/src/syrup/README.md)
for implementation details and limitations.


Source: [packages/ocapn/README.md](https://github.com/endojs/endo/blob/36db20f1/packages/ocapn/README.md) at commit `36db20f1`.
