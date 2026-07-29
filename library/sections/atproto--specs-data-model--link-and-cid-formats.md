---
title: Blessed CID formats and the three ways to embed a hash reference
source_kind: web
source_url: https://atproto.com/specs/data-model
source_content_sha256: 519f0d9076e77840bd5e296ca2631997266c28a01e7d259249d44a47bbe5ec74
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
topics: [content-addressed-storage, decentralized-identifiers]
status: current
---

> Abstract: The primary statement of atproto's blessed CID set, which the repository and blob specs both refer to second-hand: CIDv1, codec DRISL (`0x71`, "also known as `dag-cbor`") for links to data objects or `raw` (`0x55`) for links to blobs, SHA-256 at 256 bits, and base32 with a `b` prefix for string encoding. The rationale is explicitly a rejection of flexibility: the original IPFS CID specification "is very flexible ... but to maximize interoperability among implementations, only a specific 'blessed' set of CID types are allowed". The page also names the ongoing tension: SHA-256 is a stable requirement for MST nodes, while blob hash types "will likely be a set of 'blessed' hash types which evolve over time".

> "The original IPFS CID specification is very flexible. It supports a wide variety of hash types, a field indicating the 'type' of content being linked to, and various string encoding options. These features are valuable to allow evolution over time, but to maximize interoperability among implementations, only a specific 'blessed' set of CID types are allowed. These align with the DASL CID specification."

The blessed formats for CIDs in atproto:

- CID version: 1 (`0x01`)
- Codec: DRISL (`0x71`; also known as `dag-cbor`) for links to DRISL-CBOR data objects, and `raw` (`0x55`) for links to blobs
- Hash type: `sha-256` (`0x12`) with size of 256 bits (`0x20` bytes)
- Encoding: binary serialization within DRISL-CBOR `cid-link` fields, and `base32` (with `b` prefix) for string encoding elsewhere

> "The use of SHA-256 is a stable requirement in some contexts, such as the repository MST nodes. In other contexts, like referencing media blobs, there will likely be a set of 'blessed' hash types which evolve over time. A balance needs to be struck between protocol flexibility on the one hand (to adopt improved hashes and remove weak ones), and ensuring broad and consistent interoperability throughout an ecosystem of protocol implementations."

## Three ways to include a CID reference

- `link` field type (Lexicon type `cid-link`). "In DRISL-CBOR, CIDs are encoded by prefixing their binary representation with `0x00`. The CBOR tag used to represent CIDs is 42. In JSON, encodes as `$link` objects."
- `string` field type, with Lexicon string format `cid`. In DRISL-CBOR and JSON, encodes as a simple string.
- `string` field type, with Lexicon string format `uri`, with URI scheme `ipld://`.

The distinction matters for verification: only the `cid-link` form is a structural link the protocol will traverse and check. The two string forms carry a hash the application must decide what to do with, which is the same difference the repository spec draws between strict structural links and permissive leaf links.

Source: [https://atproto.com/specs/data-model](https://atproto.com/specs/data-model), content SHA-256 `519f0d90`.
