---
source_kind: comment-fragment
source_repo: dialog-db/dialog-db
source_path: typescript/dialog-experimental/src/session.ts
source_line_range: "1-527"
source_commit: 03c82744532976d72f74e7d8b2d0c35458d01310
comment_subject: The JavaScript/browser Session API of dialog-db — DID:key identity, the assert/retract change model, transaction, query/selection, cross-tab reactive subscriptions, and session lifecycle, over the WASM dialog_artifacts bindings
source_date: 2025-07-09
source_authors: [Christopher Joel, Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 5
status: current
---

`session.ts` is the JavaScript face of dialog-db: the `dialog-experimental` package's `Session` object and its supporting conversions. There is no README for this package at this HEAD — the doc-commented module *is* the API documentation. A `Session` is a `did:key`-identified handle to one local-first database, both a `Querier` (over `@dialog-db/query`'s fact model) and a transactor, backed by the WASM `dialog_artifacts` store and an IndexedDB replica. The module covers: opening (one deduplicated session per DID per thread, lazy wasm init); the change model (a `Change` is an `Assertion` or a `Retraction`, where a `Retraction` is the set of `{the,of,is}` facts of one relation) and atomic `transact`; the read path (`select` over a `the/of/is` `FactsSelector`, plus the fact↔artifact↔typed-value glue); reactive subscriptions that re-run a query on every commit, propagated across tabs by a per-DID `BroadcastChannel`; and lifecycle (`close` detaches, `clear` erases the IndexedDB replica and broadcasts `GENESIS`). Ingested as a `comment-fragment` source (the doc-commented module), 2026-07-06.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/dialog-db--ts-dialog-experimental-session--overview.md) | datalog-query, local-first-sync | current |
| [changes-assert-retract](../sections/dialog-db--ts-dialog-experimental-session--changes-assert-retract.md) | datalog-query, local-first-sync | current |
| [query-and-selection](../sections/dialog-db--ts-dialog-experimental-session--query-and-selection.md) | datalog-query | current |
| [subscriptions-and-reactivity](../sections/dialog-db--ts-dialog-experimental-session--subscriptions-and-reactivity.md) | datalog-query, local-first-sync, change-propagation | current |
| [revisions-and-lifecycle](../sections/dialog-db--ts-dialog-experimental-session--revisions-and-lifecycle.md) | local-first-sync, datalog-query | current |
