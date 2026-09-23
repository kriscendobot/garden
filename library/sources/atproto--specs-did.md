---
source_kind: web
source_url: https://atproto.com/specs/did
source_content_sha256: 624594bb04584d272731005ef390469357db8c9937211516ad94c5984fc3fedf
source_authors: [Bluesky Social PBC]
source_date: 2026-07-28
retrieved: 2026-07-28
ingested: 2026-07-28
ingested_by: scholar
section_count: 4
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

> Abstract: The AT Protocol DID specification: which DID methods atproto blesses (`did:plc` and `did:web`, deliberately a minimal set), the generic DID identifier syntax it validates against, and the three atproto-specific fields a resolver extracts from a DID document (the `alsoKnownAs` handle, the `#atproto` `Multikey` signing key, and the `#atproto_pds` service endpoint naming the account's Personal Data Server). This is the primary source for the claim that a DID document's `service` set is a real, deployed, configuration-dependent location hint: the PDS endpoint moves when an account migrates hosts while the DID itself does not.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [blessed-did-methods](../sections/atproto--specs-did--blessed-did-methods.md) | decentralized-identifiers, identity | current |
| [did-document-atproto-fields](../sections/atproto--specs-did--did-document-atproto-fields.md) | decentralized-identifiers, identity, networking | current |
| [did-identifier-syntax](../sections/atproto--specs-did--did-identifier-syntax.md) | decentralized-identifiers, identity | current |
| [public-key-representation](../sections/atproto--specs-did--public-key-representation.md) | decentralized-identifiers, identity | current |

Source: [https://atproto.com/specs/did](https://atproto.com/specs/did), content SHA-256 `624594bb`, retrieved 2026-07-28.
