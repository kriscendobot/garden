---
title: Two synchronization mechanisms, and revisions as a logical clock
source_kind: web
source_url: https://atproto.com/specs/sync
source_content_sha256: 89ca28398c1c5f6353ed17ca7c5c521f0970f9a1f94118647c7f6c1984044105
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
topics: [local-first-sync, content-addressed-storage, decentralized-identifiers]
status: current
---

> Abstract: atproto is "named for 'Authenticated Transfer'", and this page is where the transfer half is specified. There are exactly two mechanisms: batch full-repository export as CAR over HTTP, and a real-time repository event stream over WebSocket (the "firehose"); used together "they enable a complete, live-updated, and authenticated copy of network data". The synchronization primitive underneath both is the commit **revision**, a TID that "must always increase between commits for the same repository, even if the account migrates between hosts or has an extended period of inactivity" — a per-repository logical clock that survives the account moving hosts, which is exactly the property a location-independent identifier needs from its data plane.

> "Synchronization of public data between independent network participants is one of the defining features of atproto (which is named for 'Authenticated Transfer'). Data redistibution is trustworthy, low-latency, and resource efficient at large scale."

> "There are two main data synchronization mechanisms in atproto. Batch data transfer is supported using full-repository exports as CAR files over HTTP. Real-time synchronization can be provided by a repository event stream (over WebSocket), commonly referred to as a 'firehose'. Used together, they enable a complete, live-updated, and authenticated copy of network data."

## Repository revisions

Each commit to a repository has a revision value, encoded as a TID string.

> "Revisions function as a logical clock to track synchronization status individual repositories. The revision must always increase between commits for the same repository, even if the account migrates between hosts or has an extended period of inactivity. To simplify revision management, PDS implementations should use the current wall time (converted to TID) as the revision for every commit. When using wall time, it is still important to check that the new revision is higher than the previous revision, to account for clock drift or concurrent updates."

> "Synchronizing services should reject or ignore repository updates with revision values corresponding to future timestamps (beyond a short fuzzy time drift window). Services can track the commit revision for every account they have seen, and use this to verify synchronization status."

## Read-your-writes across services

> "Clients making API requests to a service may want to know if that service has synchronized and indexed recent updates to the authenticated account's repository. For example, if a client updates a profile record for their account (by writing to the PDS), and then immediately requests an updated view of their profile from a separate service, the client would want to know if the record update was applied. Services can indicate synchronization status using the `Atproto-Repo-Rev` HTTP response header, which should contain a single commit revision (TID) of the account making the API request."

That header is the deployed answer to a recurring distributed-systems question: how does a client tell whether an independently-operated read replica has caught up? The answer here is not a global clock but a per-repository revision echoed back on every response.

## Repository exports

> "Full repository exports can be fetched from the account's PDS host using the `com.atproto.sync.getRepo` XRPC endpoint (HTTP GET). This endpoint is not authenticated, and returns all repo records, MST nodes, and the current signed commit object, all in a single CAR file."

> "Other servers may provide cached or mirrored copies of full repository CAR files. It is important for such mirrors to respect repository updates (eg, record deletion) and account status changes (eg, account deactivation or deletion) in a timely manner (within seconds or minutes). This generally means that static repository snapshots should not be redistributed publicly in bulk form (eg, archival datasets or torrent files)."

The last sentence is the honest limit on self-certifying data: the bytes verify forever, so nothing about content addressing can make a deletion propagate. Deletion is a social obligation on mirrors, enforced by norm and not by the format.

Source: [https://atproto.com/specs/sync](https://atproto.com/specs/sync), content SHA-256 `89ca2839`.
