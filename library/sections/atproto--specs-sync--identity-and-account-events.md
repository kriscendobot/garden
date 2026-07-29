---
title: #identity and #account events
source_kind: web
source_url: https://atproto.com/specs/sync
source_content_sha256: 89ca28398c1c5f6353ed17ca7c5c521f0970f9a1f94118647c7f6c1984044105
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
topics: [decentralized-identifiers, identity, local-first-sync]
status: current
---

> Abstract: The two non-repository event types, both of which are cache-invalidation hints rather than authoritative statements. An `#identity` event says the DID document or handle "may have" changed and deliberately "does not indicate what changed, or reliably indicate what the current state of the identity is"; it is best-effort in both directions (a real change may go unannounced, and a redundant event may be emitted). An `#account` event describes the current hosting status at the emitting service and is explicitly "hop-by-hop for repository hosts and mirrors". Both are the honest shape for mutable state announced across a federation: notification of possible change, with re-resolution as the consumer's job.

## `#identity` events

> "Indicates that there may have been a change to the indicated identity (meaning the DID document or handle), and optionally what the current handle is. Does not indicate what changed, or reliably indicate what the current state of the identity is."

Event fields: `seq`, `did`, `time` (common to all event types), plus:

- `handle` (string with handle syntax, optional): "the current handle for this identity. May be `handle.invalid` if the handle does not currently resolve correctly."

"Presence or absence of the `handle` field does not indicate that it is the handle which has changed."

> "The semantics and expected behavior are that downstream services should update any cached identity metadata (including DID document and handle) for the indicated DID. They might mark caches as stale, immediately purge cached data, or attempt to re-resolve metadata."

> "Identity events are emitted on a 'best-effort' basis. It is possible for the DID document or handle resolution status to change without any atproto service detecting the change, in which case an event would not be emitted. It is also possible for the event to be emitted redundantly, when nothing has actually changed."

Intermediary services (relays) may modify or pass through identity events: replace the handle with their own resolution result, always remove the handle field, or always pass it through unaltered; filter out identity events when they observe the identity has not actually changed; or emit identity events from changes they became aware of independently (periodic re-validation of handles).

## `#account` events

> "Indicates that there may have been a change in Account Hosting status at the service which emits the event, and what the new status is. For example, it could be the result of creation, deletion, or temporary suspension of an account. The event describes the current hosting status, not what changed."

Event fields: `seq`, `did`, `time`, plus:

- `active` (boolean, required): "whether the repository is currently available and can be redistributed".
- `status` (string, optional): more detailed state. Known values:
  - `takendown`: indefinite removal of the repository by a service provider, due to a terms or policy violation.
  - `suspended`: temporary or time-limited variant of `takedown`.
  - `deleted`: account has been deactivated, possibly permanently.
  - `deactivated`: temporary or indefinite removal of all public data by the account themselves.

> "When coming from any service which redistributes account data, the event describes what the new status is at that service, and is authoritative in that context. In other words, the event is hop-by-hop for repository hosts and mirrors."

Source: [https://atproto.com/specs/sync](https://atproto.com/specs/sync), content SHA-256 `89ca2839`.
