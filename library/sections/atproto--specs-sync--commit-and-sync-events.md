---
title: #commit and #sync events
source_kind: web
source_url: https://atproto.com/specs/sync
source_content_sha256: 89ca28398c1c5f6353ed17ca7c5c521f0970f9a1f94118647c7f6c1984044105
source_authors: [Bluesky Social PBC]
source_date: 2026-07-29
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
topics: [local-first-sync, content-addressed-storage]
status: current
---

> Abstract: The two repository-state events and their exact field sets. A `#commit` carries the CAR-slice diff, the record operation list, the previous revision (`since`), and the previous MST root (`prevData`) — the last of which is "marked 'optional'" but "effectively required for MST inversion". A `#sync` asserts the current state without the contents: its `blocks` field holds only the commit object, so a downstream service that receives one "would need to fetch the full repo CAR file to re-synchronize". Two fields (`tooBig`, `blobs`) are deprecated but still required by the schema, and the page tells producers and consumers exactly what to do with them.

## `#commit` events

> "This event indicates that there has been a new repository commit for the indicated account. The event usually contains the 'diff' of repository data, in the form of a CAR slice."

Event fields:

- `seq` (integer, required).
- `repo` (string with DID syntax, required): "the same as `did` for all other event types".
- `time` (string with datetime syntax, required).
- `rev` (string with TID syntax, required): the revision of the commit. "Must match the `rev` in the commit block itself."
- `since` (string with TID syntax, nullable): "indicates the `rev` of a preceding commit, which the the repo diff contains differences from".
- `commit` (cid-link, required): CID of the commit object (in `blocks`).
- `tooBig` (boolean, required): "this field is deprecated, but still technically required. Producers should always set it to `false`, and consumers should ignore it."
- `blocks` (bytes, required): "CAR 'slice' for the corresponding repo diff. The commit object must always be included, and the CAR header must indicate the commit block as the first 'root'."
- `ops` (array of objects, required): list of record-level operations in this commit.
- `blobs` (array of cid-link, required): "this field is deprecated, but still technically required. Producers should set it to an empty array, and consumers should ignore it."
- `prevData` (cid-link, semi-optional): "the root CID of the MST tree for the last commit of this repository. Similar to the 'since' field, which indicates the previous 'rev'. Effectively required for MST inversion, despite being marked 'optional'."

`ops` object fields:

- `action` (string, required): one of `create`, `update`, or `delete`.
- `path` (string, required): record path within the repository (collection and record key).
- `cid` (cid-link, required, nullable): new version of record, or `null` if the record has been deleted.
- `prev` (cid-link, optional): previous version of record (for `update` and `delete`), or not defined (for `create`).

> "Commit events are broadcast when the account repository changes. Commits can be 'empty', meaning no actual record content changed, and only the `rev` was incremented."

Size limits:

- the `blocks` bytes field has a hard size limit of 2 million bytes;
- individual record blocks within `blocks` have a hard limit of one million bytes;
- at most 200 record operations can be included in a commit.

> "As an example, a single commit can not contain 50 record operations each including 60 KBytes: the limits on number of operations and per-record size would be met, but the `blocks` field size would be too large."

## `#sync` events

> "This event asserts the current status of an account's repository. This may be a confirmation or clarification of the state (if nothing changed), or may reset the repository to a new state."

Event fields: `seq`, `did`, `time`, plus:

- `rev` (string with TID syntax, required): the revision of the commit; must match the `rev` in the commit block itself.
- `blocks` (bytes, required): "CAR slice containing the current commit block. The CAR header must indicate the commit block as the first 'root'."

> "Sync events are broadcast when the account repository state has been reset to a new state, or in situations where there might be ambiguity about the current state of the repository. For example, a `#sync` event could be emitted for an account reactivating after data corruption."

> "Note that the repository contents are not included in the sync event: the `blocks` field only contains the repo commit object. Downstream services would need to fetch the full repo CAR file to re-synchronize."

Source: [https://atproto.com/specs/sync](https://atproto.com/specs/sync), content SHA-256 `89ca2839`.
