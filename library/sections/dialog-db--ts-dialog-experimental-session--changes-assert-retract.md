---
title: Changes — assertions, retractions, and atomic transaction
source: typescript/dialog-experimental/src/session.ts
source_kind: comment-fragment
source_repo: dialog-db/dialog-db
source_path: typescript/dialog-experimental/src/session.ts
source_line_range: "43-64, 244-305, 513-526"
source_commit: 03c82744532976d72f74e7d8b2d0c35458d01310
comment_subject: The change model — a Change is an Assertion or a Retraction (a set of facts to retract for one relation), and transact applies a Changes set atomically into a new revision
source_authors: [Christopher Joel, Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query, local-first-sync]
status: current
---

Abstract: A `Change` in the JS API is either an `Assertion` (assert a fact) or a `Retraction` — and a `Retraction` is modeled as an *iterable of `{ retract: Fact }`*, "usually a set corresponding to one relation model," so retracting a logical record is retracting the whole set of `{the, of, is}` facts that make it up. `Changes` is an iterable of changes that `transact` applies **atomically**: it flattens every change into low-level `Assert`/`Retract` artifact instructions, resets the local store, commits the batch through the wasm bindings, and returns the resulting `Revision`. This is dialog-db's write path from JavaScript.

## The change types

```ts
export interface Retraction extends Iterable<{ retract: Fact }> {}
export type Change = Assertion | Retraction
export interface Changes extends Iterable<Change> {}
```

The doc comments frame these precisely: a `Retraction` "retracts [a] set of facts, which is usually a set corresponding to one relation model," and `Changes` are "a set of changes that can be transacted atomically." Because a concept/relation decomposes into several `{the, of, is}` fact-triples (the associative model — see [[fact-triple]]), retracting one logical record means iterating its constituent facts and retracting each.

## Flattening changes into instructions

A private generator flattens the nested iterable into a flat instruction stream:

```ts
function* instructions(changes) {
  for (const change of changes) {
    yield* change   // an Assertion/Retraction is itself iterable of {assert}|{retract}
  }
}
```

`transact` then maps each `{ assert }` / `{ retract }` to a typed instruction:

```ts
for (const { assert, retract } of instructions(changes)) {
  if (assert)  transaction.push({ type: InstructionType.Assert,  artifact: toArtifact(assert) })
  if (retract) transaction.push({ type: InstructionType.Retract, artifact: toArtifact(retract) })
}
```

## Atomic commit and the pre-commit reset

Before committing, `transact` calls `connection.reset()` — the comment: "We reset database before we commit … because IDB could have being updated" — so the commit is applied on top of the latest on-disk state rather than a stale in-memory view (IndexedDB may have been mutated by another tab/session). It then `connection.commit(transaction)` through the wasm bindings and turns the returned bytes into a revision:

```ts
const revision = toRevision(yield* Task.wait(connection.commit(transaction)))
// bytes -> IPLD link string
const toRevision = (bytes) => Link.of(bytes).toString() as Revision
```

After committing it notifies other sessions of the same database over a `BroadcastChannel` (`postMessage({ revision })`) and re-runs this session's own subscriptions (see [subscriptions-and-reactivity](dialog-db--ts-dialog-experimental-session--subscriptions-and-reactivity.md)), then returns the new `Revision`.

Source: [typescript/dialog-experimental/src/session.ts](https://github.com/dialog-db/dialog-db/blob/03c82744532976d72f74e7d8b2d0c35458d01310/typescript/dialog-experimental/src/session.ts) at commit `03c82744`.
