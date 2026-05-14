---
title: Unobservable Memoization
source: packages/memoize/docs/memoize.md
source_repo: endojs/endo
source_commit: 2df33f43ef398fd98201a08e4b939302c13939fe
source_date: 2026-01-27
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security, hardened-javascript]
status: current
---

> Abstract: The strongest form of memoization safety: callers cannot observe whether a result was cached or computed fresh. Requires care around timing channels, harden() state, prototype-chain visibility.

## Unobservable Memoization

If the following requirements are met, then the memoizing by `memoFn` is
not observable. IOW, under these circumstances, `memoize` is not observably
different from
```js
export const memoize = fn => arg => fn(arg);
harden(memoize);
```

The unobservability requirements are
   * The function `fn` is transitively immutable and powerless, i.e.,
     it contains no mutable state or ability to cause effects.
   * Even if `arg` is mutable, when `fn(arg)` returns a result rather
     than throwing, it has not caused any effects. Thus, on any `arg`
     that `fn` cannot examine without causing effects, `fn(arg)` must throw.
     Note that `arg` may be a proxy, making this requirement hard to meet.
   * For those cases where `fn(arg)` does not throw, it must be
     reproducible in the sense that `fn(arg)` must always return
     exactly the same result for the same `arg`.


Source: [packages/memoize/docs/memoize.md](https://github.com/endojs/endo/blob/2df33f43ef398fd98201a08e4b939302c13939fe/packages/memoize/docs/memoize.md) at commit `2df33f43`.
