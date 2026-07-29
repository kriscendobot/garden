---
source_kind: web
source_url: https://atproto.com/specs/at-uri-scheme
source_content_sha256: f52bbd10b4b55c22456ab7b912093efc1c5dec58b33af8e388d3512a35083e1e
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
section_count: 5
status: current
notes: |
  Fetched live and directly from atproto.com (fetch-source.sh reported
  source_fetched_via=direct). The page carries no publication or
  last-modified date, so source_date records the retrieval date; the
  idempotency anchor is source_content_sha256 over the rendered page bytes,
  not a git SHA. Because the hash covers site chrome as well as spec prose,
  a site-wide navigation change will trip the check without the spec having
  changed; re-read before assuming a mismatch means new content.
---

> Abstract: The AT URI scheme specification: `"at://" AUTHORITY [ "/" COLLECTION [ "/" RKEY ] ]`, where the authority is a DID or a handle. Small but load-bearing for any addressing taxonomy, because it states two limits in the spec's own words. An AT URI "is not a strong reference, in that it is not content-addressed", and handle-based AT URIs "are not durable" (a re-registered handle can silently redirect an old URI to someone else's record). It also separates `at://` from `https://`: the authority "does not indicate a network location for the indicated resource". The page's own remedy is the one that matters: "When a strong reference to another record is required, best practice is to use a CID hash in addition to the AT URI" — a mutable name and a content address carried side by side, not conflated.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [structure-and-strong-reference-caveat](../sections/atproto--specs-at-uri-scheme--structure-and-strong-reference-caveat.md) | decentralized-identifiers, content-addressed-storage, networking | current |
| [generic-uri-compliance](../sections/atproto--specs-at-uri-scheme--generic-uri-compliance.md) | decentralized-identifiers, networking | current |
| [full-and-restricted-syntax](../sections/atproto--specs-at-uri-scheme--full-and-restricted-syntax.md) | decentralized-identifiers | current |
| [normalization](../sections/atproto--specs-at-uri-scheme--normalization.md) | decentralized-identifiers | current |
| [usage-and-implementation-guidelines](../sections/atproto--specs-at-uri-scheme--usage-and-implementation-guidelines.md) | decentralized-identifiers, content-addressed-storage | current |

Source: [https://atproto.com/specs/at-uri-scheme](https://atproto.com/specs/at-uri-scheme), content SHA-256 `f52bbd10`, retrieved 2026-07-29.
