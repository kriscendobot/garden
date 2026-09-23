---
title: Firehose message validation checklist
source_kind: web
source_url: https://atproto.com/specs/sync
source_content_sha256: 89ca28398c1c5f6353ed17ca7c5c521f0970f9a1f94118647c7f6c1984044105
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
topics: [local-first-sync, endpoint-security, decentralized-identifiers]
status: current
---

> Abstract: The spec's summary of what a consuming service should check on every firehose message, and the explicit statement of where responsibility sits: "Intermediary services (like public relays) may do some checks to reduce network abuse, but ultimately consuming services are responsible for validating message structure and verifying authenticity." Notable entries: resolve identity independently per DID rather than trusting the stream; remember which PDS each subscription is connected to and reject events for accounts that PDS is not authoritative for; refresh identity metadata once on a signature failure before rejecting, because the key may have just rotated; and, at the other end, "relays (specifically) should not validate records against lexicons".

> "Services consuming firehose event streams may have different validation and verification needs. Intermediary services (like public relays) may do some checks to reduce network abuse, but ultimately consuming services are responsible for validating message structure and verifying authenticity."

- Services should independently resolve identity data for each DID. "They should ignore `#commit` and `#sync` events for accounts which do not have a functioning atproto identity (eg, lacking a signing key, or lacking a PDS service entry, or for which the DID has been tombstoned)."
- Services which subscribe directly to PDS instances should keep track of which PDS is authoritative for each DID. "They should remember the host each subscription (WebSocket) is connected to, and reject `#commit` and `#sync` events for accounts if they come from a stream which does not correspond to the current account for that DID."
- Services should track account hosting status for each DID, and ignore `#commit` and `#sync` events which are not `active`.
- Services should verify commit signatures for each `#commit` and `#sync` event, using the current identity data. "If the signature initially fails to verify, the service should refresh the identity metadata in case it had recently changed. Events with conclusively invalid signatures should be rejected."
- Services should verify `#commit` and `#sync` message fields against the actual signed commit object (within the `blocks` CAR slice), and reject messages with mismatching values.
- Services should verify the `#commit` message `blocks` field (CAR diff) against the `ops` list and `prevData` field, using record operation MST inversion.
- Services should reject any event messages which exceed reasonable size limits.
- Services should verify that repository data structures are valid against the specification. "Missing fields, incorrect MST structure, or other protocol-layer violations should result in events being rejected."
- Services may apply rate-limits to identity, account, commit, and sync events, and throttle accounts or upstream services which violate them. "Rate limits might also be applied to recovery modes such as invalid signatures resulting in an identity refresh, missing or out-of-order commits, etc."
- Services should ignore `#commit` and `#sync` events with a `rev` lower than or equal to the most recent successfully processed `rev` for that DID, and should reject commit events with a `rev` corresponding to a future timestamp (beyond a clock drift window of a few minutes).
- Services should check the `since` value in `#commit` events, and if it is not consistent with the most recent `rev` for that DID, mark the repo as out-of-sync.
- Similarly, services should check `#commit` message `prevData` values against the most recent commit object `data` field.
- Data limits on records specifically should be verified. "Events containing corrupt or entirely invalid records may be rejected. for example, a record not being CBOR at all, or exceeding normal data size limits (eg, one million byte limit on record size)."
- More subtle data validation of records may be enforced or ignored depending on the service. "For example, unsupported CID hash types embedded in records should probably be ignored by relays (even if they violate the atproto data model), but may result in the record or commit event being rejected by an AppView."
- "relays (specifically) should not validate records against lexicons."

The layering rule in the last two bullets is the reusable part: the transport tier validates the envelope and the structure, and the application tier validates the schema. A relay that enforced lexicons would make schema evolution a network-wide upgrade.

Source: [https://atproto.com/specs/sync](https://atproto.com/specs/sync), content SHA-256 `89ca2839`.
