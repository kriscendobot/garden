---
title: The repository event stream (firehose), relays, and what is self-certifying
source_kind: web
source_url: https://atproto.com/specs/sync
source_content_sha256: 89ca28398c1c5f6353ed17ca7c5c521f0970f9a1f94118647c7f6c1984044105
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
topics: [local-first-sync, networking, decentralized-identifiers]
status: current
---

> Abstract: The firehose is a WebSocket stream of CBOR messages under `com.atproto.sync.subscribeRepos`, carrying four event types (`#commit`, `#sync`, `#identity`, `#account`), served both by PDS hosts (their own accounts) and by relays (aggregating many upstreams, up to a "full-network" firehose). The spec draws a sharp line through the stream: repository data "is self-certifying and contains verifiable signatures", so it can be verified without contacting the PDS, while identity and account information "is not self-certifying, and consuming services are responsible for verifying it" by independent DID and handle resolution. It also names the one thing the stream cannot detect: a missing commit shows up as a gap, but an intermediary that filters *all* messages for a repository "would not necessarily be detectable by consuming services".

> "A repository event stream ('firehose') provides real-time updates about changes to repository state (`#commit` and `#sync` events), DID documents and handles (`#identity` events), and account hosting status (`#account` events). The wire format is WebSockets with CBOR-encoded messages and sequence-based resumption cursors, as described in the Event Stream specification."

> "Multiple network services provide firehose endpoints under the same `com.atproto.sync.subscribeRepos` stream endpoint, with compatible message types and semantics. PDS hosts provide a firehose that includes updates for all hosted accounts. Relays are network services which subscribe to multiple upstream firehoses (eg, multiple PDS hosts) and aggregate them in to a single combined event stream. A relay which attempts to aggregate accounts from all PDS instances in the network outputs a 'full-network' firehose."

## What the stream authenticates, and what it does not

> "Repository data synchronized over a firehose is self-certifying and contains verifiable signatures. Consuming services can verify synchronized data without making additional requests to the account's PDS host. Missing updates to a single repository are detectable as gaps in the stream of `#commit` messages. However, if an intermediary service were to filter all messages pertaining to repository, that would not necessarily be detectable by consuming services."

> "Identity and account information is not self-certifying, and consuming services are responsible for verifying it. This usually means independent DID resolution and handle resolution. Account hosting status can be checked against the account's PDS host, though it is legitimate for intermediary services to apply takedowns."

This is the practical boundary of self-certification in a deployed system. Content addressing plus a signature gets you integrity of what you received and detection of a *gap*; it does not get you completeness, and it does not extend to the identity layer that tells you which key was supposed to sign.

## Fields common to all event types

- `seq` (integer, required): used to ensure reliable consumption, as described in Event Streams.
- `did` (string with DID syntax, required): the account associated with the event. "The `#commit` message is inconsistent and uses `repo` as the field name."
- `time` (string with datetime syntax, required): "an informal and non-authoritative estimate of when event was received. Intermediary services may decide to pass this field through as-is, or update to the current time."

> "Firehose event stream messages have a hard maximum size limit of 5 MBytes, measured as WebSocket frames. This is inclusive of all encoding and nesting overhead, and rules out some messages which would not otherwise exceed lexicon schema limits."

Source: [https://atproto.com/specs/sync](https://atproto.com/specs/sync), content SHA-256 `89ca2839`.
