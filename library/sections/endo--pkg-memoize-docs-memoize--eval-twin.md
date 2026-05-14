---
title: What Happens When a Module Meets its Eval Twin?
source: packages/memoize/docs/memoize.md
source_repo: endojs/endo
source_commit: 2df33f43ef398fd98201a08e4b939302c13939fe
source_date: 2026-01-27
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [compartments, hardened-javascript]
status: current
---

> Abstract: Edge case: same module loaded twice (once original, once via eval into different compartment) both memoizing the same function. The eval-twin scenario reveals subtle cross-realm cache coordination issues.

## What Happens When a Module Meets its Eval Twin?

Only those modules whose exports preserve isolation
should be widely shared across a system.
But because of JavaScript's
[Eval Twin](https://github.com/endojs/endo/issues/1583) problem, such a module
should also be prepared to be haphazardly duplicated. Ideally, such a module
should act in such a way that its haphazard duplication is unobservable, so
when the haphazardness of its duplication changes, those changes are not
disruptive.

Some widely shared modules export expensive validation checks. When these
validation checks are expensive, we would often like to memoize their results.

For example, the function `passStyleOf` from the package `@endo/pass-style`
internally uses a memo for a huge efficiency gain, but is nevertheless
   * defensive
   * unobservable
   * not a communications channel

The `passStyleOf` function does accept primitives as well as valid WeakMap keys,
so `passStyleOf` itself is not the `memoFn` memoizing function.
Rather, `passStyleOf` case splits
and only memoizes its internal algorithm for the WeakMap-key cases.


Source: [packages/memoize/docs/memoize.md](https://github.com/endojs/endo/blob/2df33f43ef398fd98201a08e4b939302c13939fe/packages/memoize/docs/memoize.md) at commit `2df33f43`.
