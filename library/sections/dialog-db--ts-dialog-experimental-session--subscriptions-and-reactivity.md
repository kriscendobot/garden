---
title: Subscriptions and cross-session reactivity (BroadcastChannel)
source: typescript/dialog-experimental/src/session.ts
source_kind: comment-fragment
source_repo: dialog-db/dialog-db
source_path: typescript/dialog-experimental/src/session.ts
source_line_range: "66-115, 158-211, 307-410"
source_commit: 03c82744532976d72f74e7d8b2d0c35458d01310
comment_subject: How a query subscription re-runs on every transaction, and how a BroadcastChannel propagates changes across sessions/tabs of the same database so all subscribers re-poll
source_authors: [Christopher Joel, Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query, local-first-sync, change-propagation]
status: current
---

Abstract: A `Session.subscribe(query, subscriber)` registers a `QuerySubscription` that re-runs the query and calls `subscriber(facts)` every time changes are transacted — the reactive read model the React `useQuery` hook is built on. Reactivity spans not just this session but every session of the same database in the thread: each `DialogSession` owns a `BroadcastChannel` keyed by its DID, so a `transact` (or `clear`) in one tab/session posts a message that makes the others reset their store view and re-poll their subscribers. This is dialog-db's answer to "the local replica just changed underneath me" — a query result stays live without the caller polling.

## Subscriptions

```ts
export type Subscriber<Fact> = (facts: Fact[]) => unknown

class QuerySubscription<Fact> implements Subscription {
  *poll(source: Querier) {
    if (!this.#cancelled) {
      const facts = yield* this.predicate.query({ from: source })
      this.subscriber(facts)
    }
    return {}
  }
  cancel() { this.#cancelled = true }
}
```

`subscribe` adds the subscription to the session's `#subscriptions` set and returns it; the returned `Subscription` exposes `cancelled`, `cancel()`, and `poll(session)` so a caller can also drive it manually. A cancelled subscription is skipped and pruned on the next broadcast.

## Broadcasting within a session

After a successful `transact`, `broadcast(self)` walks the subscription set, deletes any cancelled ones, and `poll`s the rest, logging (not throwing on) any per-subscription error:

```ts
static *broadcast(self) {
  for (const subscription of self.#subscriptions) {
    if (subscription.cancelled) self.#subscriptions.delete(subscription)
    else {
      const result = yield* Task.result(subscription.poll(self))
      if (result.error) console.error(result.error)
    }
  }
}
```

## Cross-session / cross-tab propagation

The constructor opens `new BroadcastChannel(this.did())` and listens on it. On commit, `transact` posts the new revision string; `clear` posts `GENESIS`. The handler resets the receiving session to the announced revision and re-broadcasts to its own subscribers:

```ts
handleEvent(event) {
  Task.perform(DialogSession.reset(this, event.data.revision ?? REVISION))
}

static *reset(self, revision) {
  const connection = yield* this.connected(self)
  if (revision === GENESIS) {
    // DB was removed; reopen rather than reset
    self.#connection = { pending: Task.perform(this.connect(self)) }
    yield* this.connected(self)
  } else {
    yield* Task.wait(connection.reset())
  }
  yield* DialogSession.broadcast(self)
}
```

So a write in any tab converges every other tab's live queries: the writer commits, broadcasts the revision; each listener resets its store to that revision and re-polls its subscribers, who receive the updated fact set. A reset to `GENESIS` is special-cased — the database was erased, so the session reopens the connection instead of resetting an absent store.

Source: [typescript/dialog-experimental/src/session.ts](https://github.com/dialog-db/dialog-db/blob/03c82744532976d72f74e7d8b2d0c35458d01310/typescript/dialog-experimental/src/session.ts) at commit `03c82744`.
