---
title: Sync usage guidelines, security concerns, and future work
source_kind: web
source_url: https://atproto.com/specs/sync
source_content_sha256: 89ca28398c1c5f6353ed17ca7c5c521f0970f9a1f94118647c7f6c1984044105
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
topics: [local-first-sync, endpoint-security, networking]
status: current
---

> Abstract: Ordering, cursors, and the network-facing hazards of consuming a firehose. Events "can be processed concurrently across accounts, but they should be processed sequentially in-order for any given account", and consumers must persist their sequence cursor, tracking "last received" separately from a high-water mark. Connection-level sequences are distinct from repository-level revisions, and different relays have distinct sequencing offsets — so a cursor is not portable between upstreams. The security notes are about the second-order traffic a firehose consumer generates: identity resolution on untrusted input is an SSRF and traffic-amplification surface, and outbound requests should be rate-limited by host.

## Usage and implementation guidelines

"The Account Lifecycle Best Practices document provides guidance on the sequence of messages to emit during different scenarios, including account creation and account migration between PDS hosts."

> "Stream events can be processed concurrently across accounts, but they should be processed sequentially in-order for any given account."

> "Event stream consumers need to track and persist the sequence number of events they have successfully processed, to be used as a cursor value when reconnecting. They may want to separately track the 'last received' sequence (for re-connections when messages are still being processed) from 'high water mark' (taking in to account messages which are received but still being processed). Note that relay instances generally have distinct sequencing offsets and message ordering, and that connection-level sequences are distinct from repository-level revision numbers."

## Security concerns

> "General mitigations for resource exhaustion attacks are recommended: event rate-limits, data quotas per account, limits on data object sizes and deserialized data complexity, etc."

> "Care should always be taken when making network requests to unknown or untrusted hosts, especially when the network locators for those host from from untrusted input. This includes validating URLs to not connect to local or internal hosts (including via HTTP redirects), avoiding SSRF in browser contexts, etc."

> "To prevent traffic amplification attacks, outbound network requests should be rate-limited by host. For example, identity resolution requests when consuming from the firehose, including DNS TXT traffic volume and DID resolution requests."

This is the cost of location hints carried in mutable documents: resolving a DID means fetching an attacker-influenced URL, so every consumer of the identity layer inherits an outbound-request security problem that a purely content-addressed system would not have.

## Future work

- "The `subscribeRepos` lexicon is likely to be tweaked, with deprecated fields removed, even if this breaks lexicon evolution rules."
- "The repository export mechanism is likely to support partial synchronization of repository subsets. For example, sub-tree CAR files covering specific collections or repo path ranges."
- "The firehose event stream sequence/cursor scheme may be iterated on to support sharding, timestamp-based resumption, and easier failover between servers with different sequences."
- "Alternatives to the full authenticated firehose may be added to the protocol. For example, simple JSON serialization, filtering by record collection type, omitting MST nodes, and other changes which would simplify development and reduce resource consumption for use-cases where full authentication is not necessary or desired."

Source: [https://atproto.com/specs/sync](https://atproto.com/specs/sync), content SHA-256 `89ca2839`.
