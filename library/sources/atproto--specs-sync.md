---
source_kind: web
source_url: https://atproto.com/specs/sync
source_content_sha256: 89ca28398c1c5f6353ed17ca7c5c521f0970f9a1f94118647c7f6c1984044105
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
section_count: 8
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

> Abstract: The ATProto data synchronization specification: CAR exports for batch transfer, the `com.atproto.sync.subscribeRepos` WebSocket firehose for real time, relays that aggregate many upstream firehoses into a full-network stream, and the four event types (`#commit`, `#sync`, `#identity`, `#account`). Its central design argument is **inductive verification**: holding a full MST copy per repository is "unrealisticly expensive at scale", so each commit is checked against the previous state by **record operation inversion**, reducing per-repository state to a revision and a tree root. It also draws the honest boundary of self-certification — repository data verifies without contacting the PDS, but identity and account information "is not self-certifying", a gap in a single repository's commit stream is detectable while wholesale filtering of a repository is not, and `since`/`prevData` "are neither authenticated (signed) nor self-certifying".

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [mechanisms-and-repository-revisions](../sections/atproto--specs-sync--mechanisms-and-repository-revisions.md) | local-first-sync, content-addressed-storage, decentralized-identifiers | current |
| [event-stream-relays-and-self-certification](../sections/atproto--specs-sync--event-stream-relays-and-self-certification.md) | local-first-sync, networking, decentralized-identifiers | current |
| [identity-and-account-events](../sections/atproto--specs-sync--identity-and-account-events.md) | decentralized-identifiers, identity, local-first-sync | current |
| [commit-and-sync-events](../sections/atproto--specs-sync--commit-and-sync-events.md) | local-first-sync, content-addressed-storage | current |
| [inductive-verification-and-operation-inversion](../sections/atproto--specs-sync--inductive-verification-and-operation-inversion.md) | content-addressed-storage, local-first-sync | current |
| [message-validation-checklist](../sections/atproto--specs-sync--message-validation-checklist.md) | local-first-sync, endpoint-security, decentralized-identifiers | current |
| [record-level-synchronization](../sections/atproto--specs-sync--record-level-synchronization.md) | local-first-sync, persistence | current |
| [guidelines-security-and-future-work](../sections/atproto--specs-sync--guidelines-security-and-future-work.md) | local-first-sync, endpoint-security, networking | current |

Source: [https://atproto.com/specs/sync](https://atproto.com/specs/sync), content SHA-256 `89ca2839`, retrieved 2026-07-29.
