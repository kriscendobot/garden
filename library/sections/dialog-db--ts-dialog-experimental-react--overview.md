---
title: React bindings — Provider, useSession, useQuery, useTransaction
source: typescript/dialog-experimental/src/react.ts
source_kind: comment-fragment
source_repo: dialog-db/dialog-db
source_path: typescript/dialog-experimental/src/react.ts
source_line_range: "1-78"
source_commit: e9084657077beaf0cde8263e8122cb70206e6a1f
comment_subject: The React bindings for dialog-db — a DID Provider, a memoized useSession, a useQuery hook that re-renders on every transaction, and a pre-bound useTransaction
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [reactive-bindings, datalog-query, local-first-sync]
status: current
---

Abstract: `react.ts` is the whole React binding for dialog-experimental — 78 lines mapping the `Session` subscription model onto React hooks. A `DialogContext` carries a `DID`; `Provider` binds a database for a subtree; `useSession` resolves the provided DID to a (memoized, deduplicated) session; `useQuery(predicate, source?)` subscribes to a query and re-renders the component with fresh results on every transaction; and `useTransaction`/`transact` give a component a write function pre-bound to the provided session. It is the reactive-UI expression of dialog-db's subscribe-and-repoll design (see [subscriptions-and-reactivity](dialog-db--ts-dialog-experimental-session--subscriptions-and-reactivity.md)).

## Provider and useSession

```ts
const DialogContext = createContext<DID | null>(null)
export const { Provider } = DialogContext

export const useSession = () => {
  const did = useContext(DialogContext)
  return useMemo(() => (did ? open(did) : null), [did])
}
```

The context holds a **DID**, not a session — `useSession` turns it into a session via `open(did)`, memoized on the DID so a re-render reuses the same session (and `open`'s per-DID dedup guarantees one session per database anyway).

## useQuery — a reactive query hook

```ts
export const useQuery = function useQuery<Fact>(predicate, source?: Session) {
  const [selection, resetSelection] = useState([] as Fact[])
  const session = source ?? useSession()
  useEffect(() => {
    if (session) {
      const subscription = session.subscribe(predicate, resetSelection)
      Task.perform(subscription.poll(session))   // prime with initial results
      return subscription.cancel                 // cancel on unmount / dep change
    }
  }, [session])
  return selection
}
```

`useQuery` wires a query predicate to component state: it subscribes (`resetSelection` is the subscriber, so each transaction pushes fresh facts into state), primes the initial result with a manual `poll`, and returns the subscription's `cancel` as the effect cleanup so the subscription is torn down on unmount. The session may be passed explicitly or taken from the provider. Its documented usage:

```ts
const Todo = fact({ title: String, done: Boolean })

function TodoList() {
  const [todos] = useQuery(Todo(), db)
  return (<div>
    <h2>Your todos are:</h2>
    {todos.map(todo => (<p key={todo.this}>{todo.title}</p>))}
  </div>)
}
```

## useTransaction and transact

```ts
export const useTransaction = () => {
  const session = useSession()
  return (changes: Changes) => transact(changes, session!)
}
export const transact = (changes: Changes, session: Session) => session.transact(changes)
```

`useTransaction` returns a write function pre-bound to the provided session; `transact` is the bare helper it delegates to. Together with `useQuery` this closes the loop: a component reads via `useQuery` and writes via `useTransaction`, and every write re-runs the reads through the subscription/broadcast machinery.

Source: [typescript/dialog-experimental/src/react.ts](https://github.com/dialog-db/dialog-db/blob/e9084657077beaf0cde8263e8122cb70206e6a1f/typescript/dialog-experimental/src/react.ts) at commit `e9084657`.
