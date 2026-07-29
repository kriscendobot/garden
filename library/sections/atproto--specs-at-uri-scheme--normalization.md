---
title: AT URI normalization
source_kind: web
source_url: https://atproto.com/specs/at-uri-scheme
source_content_sha256: f52bbd10b4b55c22456ab7b912093efc1c5dec58b33af8e388d3512a35083e1e
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
topics: [decentralized-identifiers]
status: current
---

> Abstract: Because AT URIs are embedded in signed, content-addressed records, the spec requires strict normalization so that "the representation is reproducible and can be used with simple string equality checks". The rules are mostly the generic RFC-3986 ones plus three atproto-specific ones: handles lowercase, NSID domain authority lowercase, and record keys case-sensitive and left alone. Query and fragment parts should not appear at all when a Lexicon record references a repository or record.

> "Particularly when included in atproto records, strict normalization should be followed to ensure that the representation is reproducible and can be used with simple string equality checks."

- No unnecessary hex-encoding in any part of the URI.
- Any hex-encoding hex characters must be upper-case.
- URI schema is lowercase.
- Authority as handle: lowercased.
- Authority as DID: in normalized form, and no duplicate hex-encoding. "For example, if the DID is already hex-encoded, don't re-encode the percent signs."
- No trailing slashes in path part.
- No duplicate slashes or "dot" sections in path part (`/./` or `/abc/../` for example).
- NSID in path: domain authority part lowercased.
- Record key is case-sensitive and not normalized.
- Query and fragment parts should not be included when referencing repositories or records in Lexicon records.

Refer to RFC-3986 for generic rules to normalize paths and remove `..` / `.` relative references.

The normalization contract is what makes string equality a usable comparison for an AT URI. It is the mutable-name counterpart to the CID's canonical encoding: neither identifier is comparable without a canonical form, but for a CID the canonicalization protects the hash, while here it protects a plain string compare.

Source: [https://atproto.com/specs/at-uri-scheme](https://atproto.com/specs/at-uri-scheme), content SHA-256 `f52bbd10`.
