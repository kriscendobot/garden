---
title: Generic URI compliance (and where at:// diverges from RFC-3986)
source_kind: web
source_url: https://atproto.com/specs/at-uri-scheme
source_content_sha256: f52bbd10b4b55c22456ab7b912093efc1c5dec58b33af8e388d3512a35083e1e
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
topics: [decentralized-identifiers, networking]
status: current
---

> Abstract: `at://` aligns with the generic URI syntax of IETF RFC-3986 but is deliberately not fully compliant, and the divergence is one specific thing: un-encoded colons in a DID authority are disallowed by both RFC-3986 and the WHATWG URL Standard. The spec's compensating claim is that a DID in the authority section can still be disambiguated from a `host:port` pair without ambiguity, "DIDs always have at least two colons, and always begin with `did:`". The practical fallout is that generic URL parsers split into two camps, and the page names them.

AT URIs align with the generic Universal Resource Identifier (URI) syntax described in IETF RFC-3986, but are not fully compliant. Summary of generic URI parts and features:

| Feature | Support in `at://` |
|---|---|
| Authority part, preceded by double slash | supported |
| Empty authority part | not supported |
| Userinfo | not currently supported, but reserved for future use; a lone `@` preceding a handle is not valid (`at://@handle.example.com` is invalid) |
| Host and port separation | not supported; syntax conflicts with a DID in the authority part |
| Path part | supported, optional |
| Query | supported in general syntax, not currently used |
| Fragment | supported in general syntax, not currently used |
| Relative references | not yet supported |
| Normalization rules | supported in general syntax, not currently used |

> "AT URIs are not fully compliant with either RFC-3986 or the WHATWG URL Standard. Un-encoded colon characters in DIDs in the authority part of the URI are disallowed by those standard. Note that it is possible to un-ambigiously differentiate a DID in the authority section from a `host:port` pair. DIDs always have at least two colons, and always begin with `did:`."

Source: [https://atproto.com/specs/at-uri-scheme](https://atproto.com/specs/at-uri-scheme), content SHA-256 `f52bbd10`.
