---
title: The JS Session API (dialog-experimental/session.ts)
source: typescript/dialog-experimental/src/session.ts
source_kind: comment-fragment
source_repo: dialog-db/dialog-db
source_path: typescript/dialog-experimental/src/session.ts
source_line_range: "27-157"
source_commit: 03c82744532976d72f74e7d8b2d0c35458d01310
comment_subject: What a Dialog Session is in JavaScript — a DID:key-identified handle over the WASM artifacts store bridging to @dialog-db/query
source_authors: [Christopher Joel, Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query, local-first-sync]
status: current
---

Abstract: `session.ts` is the JavaScript/browser face of dialog-db — a `Session` handle to one local-first database identified by a `did:key:...` DID. A session is both a `Querier` (over the `@dialog-db/query` fact model) and a transactor; internally it drives the WASM `dialog_artifacts` bindings (`Artifacts.open(did)`) and an IndexedDB-backed replica, lazily initializing the wasm module once per thread. Sessions are deduplicated per DID through a `WeakRef` map, so `open(did)` returns the single live session for a database rather than a second connection that could race the first. This is the top-level object every other part of the JS API (`select`, `transact`, `subscribe`, the React hooks) hangs off of.

## What a session is

A `Session` extends `@dialog-db/query`'s `Querier` and adds transaction, subscription, and lifecycle methods:

- `did(): DID` — the `did:key:...` identifier of the underlying database.
- `transact(changes): Task.Invocation<Revision, Error>` — atomically apply a set of changes, returning the new revision (see [changes-assert-retract](dialog-db--ts-dialog-experimental-session--changes-assert-retract.md)).
- `subscribe(query, subscriber): Subscription` — re-run `query` on every transaction and call `subscriber` with the fresh results (see [subscriptions-and-reactivity](dialog-db--ts-dialog-experimental-session--subscriptions-and-reactivity.md)).
- `close(): void` — cancel all subscribers and drop the session.
- `clear(): Task.Invocation<void, Error>` — close the session and erase the underlying store.

A `DID` is the template-literal type `` `did:${string}:${string}` ``, and only `did:key:` identifiers are supported — `open` throws a `RangeError` for any other method.

## Opening: one session per database per thread

```ts
export const open = (did: DID) => DialogSession.open(did)
```

`DialogSession.open` first validates the `did:key:` prefix, then consults a module-level `Map<DID, WeakRef<DialogSession>>`. If a live session for that DID already exists it is returned; otherwise a new `DialogSession` is constructed, registered as a `WeakRef`, and returned. Holding **weak** references means an unused session can still be garbage-collected, while any code still using a database shares one session — the invariant the comment states: "avoid having more than one session for the same database in the same thread."

## Lazy WASM initialization

The `dialog_artifacts` wasm module is initialized once, guarded by a module-level `ready: true | false | Promise<unknown>` latch. The first `connect` call sets `ready = init()` (a promise), awaits it, then flips `ready = true`; concurrent connects await the in-flight promise; later connects see `true` and skip straight to `Artifacts.open(self.did())`. The session's `#connection` field is a `Variant<{ pending: Task.Invocation<Artifacts, Error>; open: Artifacts }>` — it starts `pending` (the connect task) and becomes `open` once the artifacts store is live; `connected(self)` awaits the pending task or returns the open handle, so every operation transparently waits for the store to finish opening.

Source: [typescript/dialog-experimental/src/session.ts](https://github.com/dialog-db/dialog-db/blob/03c82744532976d72f74e7d8b2d0c35458d01310/typescript/dialog-experimental/src/session.ts) at commit `03c82744`.
