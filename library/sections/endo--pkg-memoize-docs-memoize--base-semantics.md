---
title: Base semantics
source: packages/memoize/docs/memoize.md
source_repo: endojs/endo
source_commit: 2df33f43ef398fd98201a08e4b939302c13939fe
source_date: 2026-01-27
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: current
---

> Abstract: Baseline memoize() semantics: function input → cached output mapping. What equality is used for the lookup key, what cache-lifetime guarantees are provided.

## Base semantics

***Hardened JS***: Even the supposedly non-contingent base semantics does
depend on a key assumption: That the primordial intrinsics still conform to
the JavaScript spec. In particular, that `WeakMap` is a conforming WeakMap
constructor, and that `memo.has`, `memo.get`, `memo.set`, and `memo.delete`
call WeakMap methods that conform to the JavaScript spec. Hardened JS
`lockdown()` locks these down, so if this assumption was not violated before
`lockdown()` then it ***cannot*** be violated, even maliciously, after
`lockdown()`.

Given a function `fn`, the call `memoize(fn)` returns a `fn`-like function, `memoFn`.
The one-arg function `memoFn` is a memoizing form of `fn`
as a one-argument function. When `memoFn(arg)` is called the first time for any
given `arg`, it calls `fn(arg)`.

If `arg` is a valid `WeakMap` key and `fn(arg)` returns a result
rather than throwing, then the mapping from `arg` to this result is memoized in
`memoFn`'s encapsulated `WeakMap`, and `result` is returned.
All further calls `memoFn(arg)` with the same
`memoFn` and the same `arg` will return the same memoized result
without calling `fn`.

Otherwise:
   * If `arg` is not a valid WeakMap key, then `memoFn(arg)` throws without any
     effect.
   * If `arg` is  a valid WeakMap key, but `fn(arg)` throws, then `memoFn(arg)`
     propagates the error without any further effect beyond that performed by
     the `fn(arg)` call.

Notice that throws from `fn(arg)` are not memoized, but rejected promises
returned by `fn(arg)` ***are*** memoized.


Source: [packages/memoize/docs/memoize.md](https://github.com/endojs/endo/blob/2df33f43ef398fd98201a08e4b939302c13939fe/packages/memoize/docs/memoize.md) at commit `2df33f43`.
