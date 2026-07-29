---
title: "Nodes, blocks, and links: the atproto data model, DRISL, and DASL"
source_kind: web
source_url: https://atproto.com/specs/data-model
source_content_sha256: 519f0d9076e77840bd5e296ca2631997266c28a01e7d259249d44a47bbe5ec74
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
topics: [content-addressed-storage, data-structures]
status: current
---

> Abstract: The primary statement of atproto's dual representation: CBOR when data must be signed, hash-linked, or stored efficiently, and JSON everywhere else, with the normalized CBOR subset named **DRISL** ("which is successor to DAG-CBOR"). This is the page the repository spec's second-hand DRISL mentions come from. It also states the two properties an addressing taxonomy cares about most: a hash reference "does not encode a specific network location where the content can be found", so "the location and access mechanism must be inferred by protocol-level context"; and it is self-certifying, which "makes it possible to redistribute content and trust copies even if coming from an untrusted party".

> "Records and messages in atproto are stored, transmitted, encoded, and authenticated in a consistent way. The core 'data model' supports both binary (CBOR) and textual (JSON) representations."

> "When data needs to be authenticated (signed), referenced (linked by content hash), or stored efficiently, it is encoded in Concise Binary Object Representation (CBOR). CBOR is an IETF standard roughly based on JSON. The specific normalized subset of CBOR used in the atproto data model is called DRISL (which is successor to DAG-CBOR). All DRISL-CBOR data is valid CBOR, and can be read with any CBOR library. Writing or strictly verifying CBOR with the correct normalization rules sometimes requires additional configuration or a special CBOR implementation."

The schema definition language for atproto is Lexicon. "Other lower-level data structures, like repository internals, are not specified with Lexicons, but use the same data model and encodings."

## Nodes, blocks, and links

> "Distinct pieces of data are called nodes, and when encoded in binary (DRISL-CBOR) result in a block. A node may have internal nested structure (maps or lists). Nodes may reference each other by string URLs or URIs, just like with regular JSON on the web. They can also reference each other strongly by hash, referred a link. A set of linked nodes can form higher-level data structures like Merkle Trees or Directed Acyclical Graphs (DAG). Links can also refer to arbitrary binary data (blobs)."

## Why a link is not a URL

> "Unlike URLs, hash references (links) do not encode a specific network location where the content can be found. The location and access mechanism must be inferred by protocol-level context. Hash references do have the property of being 'self-certifying', meaning that returned data can be verified against the link hash. This makes it possible to redistribute content and trust copies even if coming from an untrusted party."

Links are encoded as Content Identifiers (CIDs), which have both binary and string representations. "CIDs include a metadata code which indicates whether it links to a node (DRISL-CBOR) or arbitrary binary data."

In atproto, object nodes often include a string field `$type` that specifies their Lexicon schema. "Data is mostly self-describing and can be processed in schema-agnostic ways (including decoding and re-encoding), but can not be fully validated without the schema on-hand or known ahead of time."

## Relationship with DASL and IPLD

> "The atproto data model aligns with DASL, a specification for hash-linked data structures. DASL libraries and tooling can be used when implementing atproto. DASL itself is a subset of Interplanetary Linked Data (IPLD)."

> "IPLD specified a normalized JSON encoding called DAG-JSON, but atproto uses a different set of conventions when encoding JSON data. The atproto JSON encoding is not designed to be byte-determinisitic, and the CBOR representation is used when data needs to be cryptographically signed or hashed."

The split is the interesting design move: one representation is canonical for hashing and signing, the other is optimized for humans and HTTP APIs, and the spec refuses to make the second one byte-deterministic rather than compromising either.

Source: [https://atproto.com/specs/data-model](https://atproto.com/specs/data-model), content SHA-256 `519f0d90`.
