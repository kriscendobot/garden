---
title: Full and restricted AT URI syntax, with examples
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

> Abstract: Two syntaxes coexist. The full syntax is forward-looking (query part, JSON-Path fragment, multi-segment paths, hex-encoding permitted, 8 kilobyte maximum length) and the restricted syntax is what Lexicon's `at-uri` type actually accepts today: authority plus at most a collection NSID and a record key, no query, no fragment, no trailing slash, normalized throughout. The worked examples make the gap concrete, including URIs that are valid general AT URI syntax but invalid in current Lexicon.

## Full AT URI syntax

> "The full syntax for AT URIs is flexible to a variety of future use cases, including future extensions to the path structure, query parameters, and a fragment part."

- The overall URI is restricted to a subset of ASCII characters.
- The set of unreserved characters, as defined in RFC-3986, includes alphanumeric (`A-Za-z0-9`), period, hyphen, underscore, and tilde (`.-_~`).
- Maximum overall length is 8 kilobytes (which may be shortened in the future).
- Hex-encoding of characters is permitted, "but in practice not necessary and should be avoided to keep the URI normalized and human-readable".
- The URI scheme is `at`, and an authority part preceded with double slashes is always required. AT URIs always start with `at://`.
- An authority section is required and must be non-empty. It can be either an atproto handle or a DID meeting the restrictions for use with atproto. "The authority part can not be interpreted as a host:port pair, because of the use of colon characters (`:`) in DIDs." Colons and unreserved characters should not be escaped in DIDs, but other reserved characters (including `#`, `/`, `$`, `&`, `@`) must be escaped. None of the current blessed DID methods allow those characters in identifiers.
- An optional path section may follow the authority, with multiple segments separated by a single slash. Generic URI path normalization rules may be used. Trailing slashes are not allowed.
- An optional query part is allowed, following generic URI syntax restrictions.
- An optional fragment part is allowed, using JSON Path syntax.

## Restricted AT URI syntax

A restricted subset of valid AT URIs is currently used in Lexicons for the `at-uri` type. Query parameters and fragments are not currently used; trailing slashes are not allowed, including a trailing slash after the authority with no other path; the URI should be in normalized form with all individual sub-identifiers also normalized.

```
AT-URI        = "at://" AUTHORITY [ "/" COLLECTION [ "/" RKEY ] ]

AUTHORITY     = HANDLE | DID
COLLECTION    = NSID
RKEY          = RECORD-KEY
```

## Examples

Valid AT URIs (both general and Lexicon syntax):

```
at://foo.com/com.example.foo/123
```

Valid general AT URI syntax, invalid in current Lexicon:

```
at://foo.com/example/123     // invalid NSID
at://computer                // not a valid DID or handle
at://example.com:3000        // not a valid DID or handle
```

Invalid AT URI (in both contexts):

```
at://foo.com/                // trailing slash
at://user:pass@foo.com       // userinfo not currently supported
```

Source: [https://atproto.com/specs/at-uri-scheme](https://atproto.com/specs/at-uri-scheme), content SHA-256 `f52bbd10`.
