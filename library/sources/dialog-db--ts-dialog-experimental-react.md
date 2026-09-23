---
source_kind: comment-fragment
source_repo: dialog-db/dialog-db
source_path: typescript/dialog-experimental/src/react.ts
source_line_range: "1-78"
source_commit: e9084657077beaf0cde8263e8122cb70206e6a1f
comment_subject: The React bindings for dialog-db — a DID Provider/context, a memoized useSession, a reactive useQuery hook, and a pre-bound useTransaction
source_date: 2025-05-19
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 1
status: current
---

`react.ts` is the React binding for dialog-experimental — a 78-line module with no README (the doc-commented module is the documentation). It maps dialog-db's subscribe-and-repoll session model onto React hooks: a `DialogContext`/`Provider` that carries a `DID`, a memoized `useSession`, a `useQuery(predicate, source?)` hook that subscribes to a query and re-renders the component with fresh results on every transaction, and `useTransaction`/`transact` write helpers pre-bound to the provided session. It is the reactive-UI expression of the session's cross-tab subscription machinery. Ingested as a `comment-fragment` source, 2026-07-06.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/dialog-db--ts-dialog-experimental-react--overview.md) | reactive-bindings, datalog-query, local-first-sync | current |
