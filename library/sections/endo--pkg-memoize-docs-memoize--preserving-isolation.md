---
title: Preserving Isolation
source: packages/memoize/docs/memoize.md
source_repo: endojs/endo
source_commit: 2df33f43ef398fd98201a08e4b939302c13939fe
source_date: 2026-01-27
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security, compartments, hardened-javascript]
status: current
---

> Abstract: How memoize interacts with Compartment isolation: a cache shared across compartments is a covert channel; one cache per compartment is sometimes acceptable. Trade-offs and patterns.

## Preserving Isolation

There is a similar guarantee to unobservability that can be provided by
meeting similar requirements. In Hardened JavaScript, `lockdown` makes all the
implicitly shared JavaScript intrinsics transitively immutable and powerless.
This ensures that they cannot be used to communicate, and so can be shared
without violating isolation.

Likewise, if `fn` is transitively immutable
and powerless, then `fn` is already not a communications channel.
If Alice
and Bob are isolated except that they have been given access to such a
shared `fn`, then Alice and Bob can still not communicate with each other.
What is needed to guarantee is that `memoFn` is also not a
communications channel?

If the following requirements are met, then `memoFn` is also not
a communication channel.
   * As above, `fn` itself must be transitively immutable and powerless.
   * As above, if `fn(arg)` returns a result rather than throwing,
     then it must not have caused any effects.
   * For those cases where `fn(arg)` does not throw, if must be
     deterministic in the sense that, for a given `arg`, for every object
     in the result,
      * the object is transitively immutable and powerless.
      * that object is equivalent aside from object identity.
      * Either the object always has the same identity for all
        `fn(arg)` calls, as with reproducibility, or it has a fresh identity
        per call, as with fresh allocation by the call. This weaker
        guarantee is "determinism", which we define to allow
        such always-fresh but otherwise equivalent.

Allowing fresh identities within the result would be adequate for `fn` not
to be a communications channel, even if those fresh objects were mutable,
since all their mutable state must have been allocated per call. But the
memoized form of such a function will share these result objects. If they
contained mutable state, then this sharing would have introduced a
communications channel. But even meeting all these requirements, the
resulting memoization is observable because it turns observably
distinct identities into observably shared identities.


Source: [packages/memoize/docs/memoize.md](https://github.com/endojs/endo/blob/2df33f43ef398fd98201a08e4b939302c13939fe/packages/memoize/docs/memoize.md) at commit `2df33f43`.
