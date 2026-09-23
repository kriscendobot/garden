---
title: Repository paths, record keys, and blessed CID formats
source_kind: web
source_url: https://atproto.com/specs/repository
source_content_sha256: bb8ddfacbc2864bdff6d917764da33c0263f4226363878c13cf5abe0979dd249
source_authors: [Bluesky Social PBC]
source_date: 2026-07-28
retrieved: 2026-07-28
ingested: 2026-07-28
ingested_by: scholar
topics: [content-addressed-storage, persistence, data-structures]
status: current
---

> Abstract: The key space of an atproto repository (`<collection>/<record-key>`, an NSID and a record key, ASCII-restricted, mapped to MST byte-array keys by UTF-8) and the strictness rules on CID links: structural links (commit `prev`/`data`, MST node-to-node) must follow the blessed CID format or the whole structure is invalid, while leaf links to records are handled more permissively and must be retained byte-exactly. Also records why TID record keys were chosen: they sort chronologically within a collection, which makes appends cheaper than random insertions in the MST.

## Repository paths

> "Repo paths are strings, while MST keys are byte arrays. Neither may be empty (zero-length). While repo path strings are currently limited to a subset of ASCII (making encoding a no-op), the encoding is specified as UTF-8."

> "Repo paths currently have a fixed structure of `<collection>/<record-key>`. This means a valid, normalized Namespace ID (NSID), followed by a `/`, followed by a valid Record Key. The path should not start with a leading `/`, and should always have exactly two path segments."

Allowed ASCII characters in the entire path string: letters (`A-Za-z`), digits (`0-9`), slash (`/`), period (`.`), hyphen (`-`), underscore (`_`), and tilde (`~`). The specific path segments `.` and `..` are never valid.

## Why record keys sort the way they do

> "Note that repo paths for all records in the same collection are sorted together in the MST, making enumeration (via key scan) and export efficient. Additionally, the Timestamp ID (TID) record key scheme was intentionally selected to provide chronological sorting of MST keys within the scope of a collection. Appends are more efficient than random insertions/mutations within the tree, and when enumerating records within a collection they will be in chronological order (assuming that TID generation was done correctly, which cannot be relied on in general)."

The parenthetical is worth keeping: chronological order is a property of well-behaved clients, not an enforced invariant.

## CID strictness

> "The blessed CID format described in Data Model is used for references to commit objects, MST node objects, and records."

> "In the context of repositories, it is desirable for the overall data structure to be reproducible given the contents, so the CID types should be strictly constrained and enforced. Commit objects with non-compliant `prev` or `data` links are considered invalid. MST Node objects with non-compliant links to other MST Node objects are considered invalid, and the entire MST data structure invalid."

> "More flexibility is allowed in processing the 'leaf' links from MST to records, and implementations should retain the exact CID links used for these mappings. Implementations should strictly follow the CID blessed format when generating new CID Links to records."

The blessed formats themselves, from the data-model specification: CID version 1 (`0x01`); codec DRISL (`0x71`, also known as `dag-cbor`) for links to structured data objects, and `raw` (`0x55`) for links to blobs; hash type `sha-256` (`0x12`) with a 256-bit digest.

## Declared future changes

The spec names several changes it may make, which is useful for anyone pinning to the format: optional multi-version record storage, relaxed path restrictions (including non-ASCII, always mapped to MST keys by UTF-8), additional blessed cryptographic algorithms and CID formats for blobs and records, blob inclusion in CAR exports, and non-CBOR record content. "MST node CID format changes would require a repo format version bump", as would "changing the MST fanout, or any changes to the current MST fields".

Source: [https://atproto.com/specs/repository](https://atproto.com/specs/repository), content SHA-256 `bb8ddfac`.
