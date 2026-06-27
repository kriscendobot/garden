---
section: weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
source: endo--packages-captp-src-finalize-js
topics: [captp, hardened-javascript, capability-security]
status: current
title: "The §issue-#1514 TODO (now resolved)"
parent: endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
---

> **Refresh note (2026-06-27):** this §TODO has since been
> **resolved upstream**. Commit `96b9ea81d` (Kris Kowal,
> *refactor: Embrace default chaining*, 2026-05-21) adopted the
> preferred optional-chaining form and deleted the verbose
> workaround together with its `// UNTIL …` comment block. The
> material below is preserved as the historical record of the
> pattern; the *current* file reads simply `get: key =>
> keyToRef.get(key)?.deref(),`.

**Current form** (since `96b9ea81d`):

```js
// Does deref, and thus does guarantee stability of the value until the
// end of the turn.
get: key => keyToRef.get(key)?.deref(),
```

**Prior form** (recorded at `5efcf7dd0`, the original ingest):

```js
// UNTIL https://github.com/endojs/endo/issues/1514
// Prefer: get: key => keyToRef.get(key)?.deref(),
get: key => {
  const wr = keyToRef.get(key);
  if (!wr) {
    return wr;
  }
  return wr.deref();
},
```

The §TODO-with-issue-link discipline: the cleaner *preferred*
form was named, blocked on a tracked issue. The §commented-out-
preferred-form pattern kept the future-cleanup visible at the
site until the cleanup actually landed.

The §`if (!wr) return wr` shape: returned `undefined` when the
key wasn't in the map. Returning `wr` (which is `undefined`)
instead of `return undefined` was a §TypeScript-narrowing
nudge — the inferred return type was *the type of `wr`*, not
*the type of `wr.deref()`*. The §preserve-the-undefined-not-
the-typeof-deref-result discipline (the workaround the TODO
pointed to).

The §resolution: optional chaining (`?.deref()`) short-circuits
to `undefined` when `keyToRef.get(key)` is itself `undefined`,
preserving the same undefined-return behavior *without* the
explicit guard — so once the TypeScript-narrowing concern was no
longer load-bearing, the verbose form collapsed to the one-liner.
The §let-the-language-do-it move that the commit's own title
names: *Embrace default chaining*.
