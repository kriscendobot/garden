---
id: dialog-session-js
aliases: [DialogSession, dialog Session, dialog-experimental, useQuery, useSession, useTransaction, DialogContext, dialog react hooks, dialog js api, dialog javascript api, BroadcastChannel session, did:key session, Retraction, Changes, transact changes, GENESIS revision]
topics: [datalog-query, local-first-sync, reactive-bindings]
---

# dialog-session-js

The **JavaScript/browser Session API** of dialog-db, in the `dialog-experimental` package (`typescript/dialog-experimental/src/session.ts` + `react.ts`; neither has a README — the doc-commented modules are the API). A `Session` is a `did:key`-identified handle to one local-first database, both a `Querier` over `@dialog-db/query`'s `{the, of, is, cause}` fact model and a transactor, backed by the WASM `dialog_artifacts` store and an IndexedDB replica. `open(did)` returns one deduplicated session per DID per thread (a `WeakRef` map). Writes go through `transact(changes)` where a `Change` is an `Assertion` or a `Retraction` (a `Retraction` is the set of `{the,of,is}` facts of one relation model), applied atomically into a new IPLD-link-string `Revision`; the empty revision string is `GENESIS`. Reads go through `select(FactsSelector)` (partial `the/of/is` match) and, reactively, through `subscribe(query, subscriber)` which re-runs the query on every commit. A per-DID `BroadcastChannel` propagates each commit (and each `clear`, which erases the IndexedDB replica and broadcasts `GENESIS`) across every tab/session of the same database, so all live queries converge. The React bindings (`Provider`, `useSession`, `useQuery`, `useTransaction`) wrap exactly this. This is the JS-side counterpart to the Rust `dialog-query` API ([[dialog-query-rust-api]]) and rides the same associative model ([[fact-triple]]).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--ts-dialog-experimental-session--overview](../sections/dialog-db--ts-dialog-experimental-session--overview.md) | What a JS Session is: a did:key handle, Querier+transactor over the WASM artifacts store, one deduplicated session per DID with lazy wasm init. |
| [dialog-db--ts-dialog-experimental-session--changes-assert-retract](../sections/dialog-db--ts-dialog-experimental-session--changes-assert-retract.md) | The change model — Assertion vs Retraction (the facts of one relation), flattened to Assert/Retract instructions and committed atomically into a Revision. |
| [dialog-db--ts-dialog-experimental-session--query-and-selection](../sections/dialog-db--ts-dialog-experimental-session--query-and-selection.md) | select over a the/of/is FactsSelector, and the fact↔artifact + entity-encoding + typed-value tagging that bridge to the wasm store. |
| [dialog-db--ts-dialog-experimental-session--subscriptions-and-reactivity](../sections/dialog-db--ts-dialog-experimental-session--subscriptions-and-reactivity.md) | Query subscriptions re-run on each transaction, propagated across tabs by a per-DID BroadcastChannel. |
| [dialog-db--ts-dialog-experimental-session--revisions-and-lifecycle](../sections/dialog-db--ts-dialog-experimental-session--revisions-and-lifecycle.md) | Revisions as IPLD-link strings, GENESIS as the empty-DB marker, and close (detach) vs clear (erase IndexedDB, broadcast GENESIS). |
| [dialog-db--ts-dialog-experimental-react--overview](../sections/dialog-db--ts-dialog-experimental-react--overview.md) | React bindings: DID Provider, memoized useSession, reactive useQuery, pre-bound useTransaction. |

## See also

- [[dialog-db]] — the database this is the JS face of.
- [[dialog-query-rust-api]] — the Rust-side query/claim API; `session.ts` bridges JS to the same `{the,of,is,cause}` model through the WASM bindings.
- [[fact-triple]] — the `{the, of, is, cause}` claim the change model asserts and retracts.
- [[ucan-delegation]] — dialog-db's authorization side (Rust remotes), a peer surface to this local session API.
