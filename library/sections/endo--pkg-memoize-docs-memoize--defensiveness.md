---
title: Defensiveness
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

> Abstract: Why memoize must be defensive: a memoize wrapper exposes its cache state implicitly through timing and through the same-result-for-same-input guarantee. Adversarial callers can probe the cache.

## Defensiveness

For `fn` to be defensive, it should throw at least on any argument
that is not a valid WeakMap key. It should also throw on any argument
that is not a valid candidate for memoization, according to the goals of the
code calling `memoize(fn)`.


Source: [packages/memoize/docs/memoize.md](https://github.com/endojs/endo/blob/2df33f43ef398fd98201a08e4b939302c13939fe/packages/memoize/docs/memoize.md) at commit `2df33f43`.
