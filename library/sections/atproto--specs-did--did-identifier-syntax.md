---
title: DID identifier syntax constraints in atproto
source_kind: web
source_url: https://atproto.com/specs/did
source_content_sha256: 624594bb04584d272731005ef390469357db8c9937211516ad94c5984fc3fedf
source_authors: [Bluesky Social PBC]
source_date: 2026-07-28
retrieved: 2026-07-28
ingested: 2026-07-28
ingested_by: scholar
topics: [decentralized-identifiers, identity]
status: current
---

> Abstract: The generic DID syntax atproto validates against (Lexicon string format type `did`), independent of which method is blessed: an ASCII subset, case sensitivity, a lowercase method segment, no query or fragment parts in the atproto context, and a hard 2048-character limit that DID Core itself does not impose. Useful when writing a parser or deciding whether a foreign identifier is even syntactically admissible.

Lexicon string format type: `did`.

> "The DID Core specification places syntax restrictions on all DID identifiers, and individual DID methods might have their own more specific syntax. While atproto supports only a small set of DID methods today, it still makes sense to consider the general DID syntax in many parsing and validation contexts."

The general syntax constraints used to validate generic DID identifiers in atproto:

- The entire URI is made up of a subset of ASCII, containing letters (`A-Z`, `a-z`), digits (`0-9`), period, underscore, colon, percent sign, or hyphen (`._:%-`).
- The URI is case-sensitive.
- The URI starts with lowercase `did:`.
- The method segment is one or more lowercase letters (`a-z`), followed by `:`.
- The remainder of the URI (the identifier) may contain any of the above-allowed ASCII characters, except for percent-sign (`%`).
- The URI (and thus the remaining identifier) may not end in `:`.
- Percent-sign (`%`) is used for percent encoding in the identifier section, and must always be followed by two hex characters.
- "Query (`?`) and fragment (`#`) sections are allowed in DID URIs, but not in DID identifiers. In the context of atproto, the query and fragment parts are not allowed."

> "DID identifiers do not generally have a maximum length restriction, but in the context of atproto, there is a current hard limit of 2048 characters."

> "In the context of atproto, implementations do not need to validate percent encoding. The percent symbol is allowed in DID identifier segments, but the identifier should not end in a percent symbol. A DID containing invalid percent encoding should fail any attempt at registration, resolution, etc."

A reasonable starting-point regex, which deliberately does not constrain overall length:

```
/^did:[a-z]+:[a-zA-Z0-9._:%-]*[a-zA-Z0-9._-]$/
```

Valid for use in atproto (correct syntax and supported method):

```
did:plc:ewvi7nxzyoun6zhxrhs64oiz
did:web:user.example.com
```

Valid DID syntax that would pass Lexicon validation but names an unsupported method, including `did:key`:

```
did:method:val:two
did:m:v
did:key:zQ3shZc2QzApp2oymGvQbzP8eKheVshBHbU4ZYjeXqwSKEn6N
```

Note the last line: `did:key` is syntactically fine and semantically unsupported in atproto, even though it is the only DID method UCAN 1.0 requires. The two systems intersect on DID syntax and not on the method set.

Source: [https://atproto.com/specs/did](https://atproto.com/specs/did), content SHA-256 `624594bb`.
