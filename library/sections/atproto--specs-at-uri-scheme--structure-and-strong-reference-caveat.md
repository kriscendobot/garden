---
title: AT URI structure, and why an at:// URI is not a strong reference
source_kind: web
source_url: https://atproto.com/specs/at-uri-scheme
source_content_sha256: f52bbd10b4b55c22456ab7b912093efc1c5dec58b33af8e388d3512a35083e1e
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
topics: [decentralized-identifiers, content-addressed-storage, networking]
status: current
---

> Abstract: The `at://` scheme names a record in an account's repository as `"at://" AUTHORITY [ "/" COLLECTION [ "/" RKEY ] ]`, where the authority is either a DID or a handle. Two disclaimers on this page are load-bearing for any addressing taxonomy: an AT URI "is not a strong reference, in that it is not content-addressed", and handle-based AT URIs "are not durable" because the handle-to-DID mapping can change and a released handle can be re-registered by someone else. A third disclaimer separates `at://` from `https://`: the authority part "does not indicate a network location for the indicated resource", so even a hostname-shaped authority is an identity lookup key and usually not the host that serves the content.

The AT URI scheme (`at://`) makes it easy to reference individual records in a specific repository, identified by either DID or handle. Both of these AT URIs reference the same record in the same repository; one uses the account's DID, and one uses the account's handle:

```
at://did:plc:vwzwgnygau7ed7b7wt5ux7y2/app.bsky.feed.post/3k5nobkf2w72g
at://retr0.id/app.bsky.feed.post/3k5nobkf2w72g
```

## Caveats for handle-based AT URIs

> "AT URIs referencing handles are not durable."

> "If a user changes their handle, any AT URIs using that handle will become invalid and could potentially point to a record in another repo if the handle is reused."

> "AT URIs are not content-addressed, so the contents of the record they refer to may also change over time."

## Structure

The full, general structure is:

```
"at://" AUTHORITY [ PATH ] [ "?" QUERY ] [ "#" FRAGMENT ]
```

The authority part can be either a handle or a DID, indicating the identity associated with the repository. "Note that a handle can refer to different DIDs (and thus different repositories) over time."

In current atproto Lexicon use, the query and fragment parts are not yet supported, and only a fixed pattern of paths is allowed:

```
"at://" AUTHORITY [ "/" COLLECTION [ "/" RKEY ] ]
```

The authority section is required and should be normalized. As with DID syntax elsewhere in atproto, it is syntactically valid to have AT URIs with unsupported DID methods, "though the URI will not resolve or function properly." The optional collection part of the path must be a normalized NSID; the optional rkey part must be a valid record key.

## Not a strong reference

> "An AT URI pointing to a specific record in a repository is not a strong reference, in that it is not content-addressed. The record may change or be removed over time, or the DID itself may be deleted or unavailable. For `did:web`, control of the DID (and thus repository) may change over time. For AT URIs with a handle in the authority section, the handle-to-DID mapping can also change."

## The authority is not a network location

> "A major semantic difference between AT URIs and common URL formats like `https://`, `ftp://`, or `wss://` is that the 'authority' part of an AT URI does not indicate a network location for the indicated resource. Even when a handle is in the authority part, the hostname is only used for identity lookup, and is often not the ultimate host for repository content (aka, the handle hostname is often not the PDS host)."

This is the same split the DID document draws with its `#atproto_pds` service entry: the name carries authority, and the location is a separate, resolvable hint.

Source: [https://atproto.com/specs/at-uri-scheme](https://atproto.com/specs/at-uri-scheme), content SHA-256 `f52bbd10`.
