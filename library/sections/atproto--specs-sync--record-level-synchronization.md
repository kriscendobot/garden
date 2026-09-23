---
title: "Record-level synchronization: the desynchronized / in-progress / synchronized pattern"
source_kind: web
source_url: https://atproto.com/specs/sync
source_content_sha256: 89ca28398c1c5f6353ed17ca7c5c521f0970f9a1f94118647c7f6c1984044105
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
topics: [local-first-sync, persistence]
status: current
---

> Abstract: A design pattern (not a normative requirement) for an indexing service that wants record-granularity synchronization across all accounts. Each repository carries a three-state sync status, `desynchronized` (the default), `in-progress`, and `synchronized`, plus a sorted record-state table of `(DID, record path, CID)`. Events for a desynchronized repo are dropped, events for an in-progress repo are enqueued, and a pool of workers re-synchronizes by fetching the full CAR, walking the tree, and diffing against the record table. The subtle rule: every `#commit` for an in-scope account must be fully validated and applied to the sync metadata even when it contains no in-scope records, "to maintain the chain of validated repos states".

> "Indexing services often care about processing all records of specific collections, across all accounts in the network. This section describes a design pattern for services to bootstrap existing accounts and records, and then maintain record-granularity synchronization, including re-synchronization incidents."

Account-level state to track:

- identity resolution cache: DID document and handle;
- account hosting status: both "upstream" and "local" (to support local takedowns);
- repo sync metadata: last revision and commit `data` field;
- repo sync status.

The repo sync status field tracks overall processing status:

- `desynchronized` (default): "out-of-sync with current revision, and re-synchronization is needed";
- `in-progress`: "the service is actively re-synchronizing the repo";
- `synchronized`: "all records have been processed for the current repository revision".

Record-level state, in a sorted table: repository account DID, record path (collection and record key), record version (CID).

## Processing

> "The service consumes from a full-network relay firehose. When `#identity` events are received, it updates resolution caches as usual. When `#account` events are received, it updates the 'upstream' part of account hosting status. Processing of `#commit` and `#sync` events depends on the repo sync status."

> "When a valid `#commit` is received for a synchronized account, the service processes all of the record operations, and updates the record state table. For example, created records are inserted into the table, deleted records are removed from the table, and updated records have the version field updated."

> "If a `#sync` message is received that matches the current repo status, the message is ignored. If an authenticated `#sync` or `#commit` message is received that indicates the chain of commit synchronization messages has been broken for a repository, the repo sync state is updated to `desynchronized`. Any `#commit` or `#sync` messages received for a repo which is in `desynchronized` state are ignored (dropped). Any events for a repository in `in-progress` state are enqueued for processing (eg, in a database)."

## Re-synchronization workers

> "The service runs a pool of re-synchronization workers. These check for repositories in the `desynchronized` state, and mark them as `in-progress` when they start work. The resync process is to fetch the account's full repository CAR file. The worker then 'walks' all records from the parsed repo tree, and scans the sorted record-level state table for the repository, and compares record states. If a a record exists in the CAR file but not the record table, that is treated as a creation. If the record versions mismatch, that is processed as an update. If a record is in the table, but not the CAR file, that is treated as a deletion. The table is updated as records are processed. Once the CAR processing is complete, the repo sync metadata is updated, and then any enqueued `#commit` and `#sync` messages for that repository are processed. If those are successful, the repo sync status is updated to `synchronized`, and the worker returns to the pool."

## Filtering and backfill

> "The service may want to filter records to only relevant collections. Only those records need to be tracked in the record state table. Every `#commit` message for in-scope accounts does need to be fully validated and have the repo sync table updated, even if that commit does not contain any in-scope records. This is to maintain the chain of validated repos states."

> "Discovering accounts from a full-network firehose will result in data from currently-active accounts getting processed. This is a good place to start for many services, but it is usually desirable to also backfill previously-active accounts as well, which can be done by inserting them in to the repository state stable with status `desynchronized`. The `com.atproto.sync.listReposByCollection` XRPC endpoint can be used to get a list of accounts (by DID) which have records in a specific collection (lexicon schema)."

Source: [https://atproto.com/specs/sync](https://atproto.com/specs/sync), content SHA-256 `89ca2839`.
