---
title: Revisions, GENESIS, and session lifecycle (close/clear)
source: typescript/dialog-experimental/src/session.ts
source_kind: comment-fragment
source_repo: dialog-db/dialog-db
source_path: typescript/dialog-experimental/src/session.ts
source_line_range: "27-64, 342-383"
source_commit: 03c82744532976d72f74e7d8b2d0c35458d01310
comment_subject: A revision is an IPLD-link string, GENESIS the empty-database revision, and close/clear are the two lifecycle exits — one detaching, one erasing the IndexedDB replica
source_authors: [Christopher Joel, Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [local-first-sync, datalog-query]
status: current
---

Abstract: A database `Revision` is an IPLD content-address rendered as a string — `transact` returns one, and `revision()` reads the current one. The empty byte array's link is treated as the empty database revision, and its string form is `GENESIS` — the marker a `clear` broadcasts to say "this database no longer exists." A session has two lifecycle exits: `close()` detaches it (unregisters from the per-DID map, stops listening on the broadcast channel, drops subscriptions) without touching data, while `clear()` closes it *and* erases the underlying IndexedDB store, then broadcasts `GENESIS` so peer sessions reopen from empty.

## Revisions and GENESIS

```ts
const ENTITY   = Link.of(null)['/'].fill(0, 4)
const REVISION = Link.of(null)            // link of the empty byte array
const GENESIS  = REVISION.toString()       // its string form == "the empty database"

export interface Revision { toString(): string }
```

The comment states the convention directly: "We treate IPLD Link for empty byte array as an empty db revision." Every non-empty revision is `Link.of(commitBytes).toString()`; a reader compares against `GENESIS` to detect the erased/empty state.

## close(): detach without erasing

```ts
close() {
  if (sessions.get(this.did())?.deref() === this) sessions.delete(this.did())
  this.#channel.removeEventListener('message', this)
  this.#subscriptions.clear()
}
```

`close` removes this session from the per-DID `WeakRef` map (only if it is still the registered one), stops listening for cross-tab broadcasts, and clears subscriptions. The stored data is untouched — a later `open(did)` reconnects to the same database.

## clear(): erase the local replica

```ts
static *clear(self) {
  self.close()
  yield* this.connected(self)               // wait until fully connected before disposing
  const erase = new Promise((resolve, reject) => {
    const request = indexedDB.deleteDatabase(self.did())
    request.onerror = reject
    request.onsuccess = resolve
  })
  yield* Task.wait(erase)
  self.#channel.postMessage({ revision: GENESIS })  // tell peers the DB is gone
}
```

`clear` closes the session, waits for any in-flight connect to finish (so it does not race disposal), deletes the IndexedDB database named by the DID, and posts `GENESIS` on the broadcast channel. Peer sessions receiving `GENESIS` reopen their connection from an empty store (see [subscriptions-and-reactivity](dialog-db--ts-dialog-experimental-session--subscriptions-and-reactivity.md)). The comment names the intent: "Clears local replica for this database" — it erases *this replica*, not the shared history other replicas may still hold.

Source: [typescript/dialog-experimental/src/session.ts](https://github.com/dialog-db/dialog-db/blob/03c82744532976d72f74e7d8b2d0c35458d01310/typescript/dialog-experimental/src/session.ts) at commit `03c82744`.
