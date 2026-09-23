---
title: Hazards
source: packages/pass-style/doc/copyRecord-guarantees.md
source_repo: endojs/endo
source_commit: be51fb10b6f4
source_date: 2023-11-30
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [pass-style, marshal]
status: current
parent: endo--pkg-pass-style-doc-copyrecord-guarantees--overview
---

We have not yet implemented the proxy test explained above, so our "normal" coding style is currently vulnerable against proxy-based reentrancy attacks from malicious local callers. But this attack is not possible for malicious messages received across a vat boundary. Our plan is to enforce this proxy prohibition well before we allow arbitrary malicious code on-chain.

Because `passStyleOf` deeply enforces that everything is Passable only to the leaves of the pass-by-copy container tree, it does *not* guarantee that these other Passable objects lead only to further Passables. For example, a promise may eventually be fulfilled by a non-Passable. A method of a far object may return a non-Passable. When this occurs at a vat boundary (or other marshal-based serialization boundary), the attempt to pass that non-Passable will cause an error. But locally it *will not*. Input validation using `passStyleOf` must be aware of this limit.

Source: [packages/pass-style/doc/copyRecord-guarantees.md](https://github.com/endojs/endo/blob/be51fb10b6f4/packages/pass-style/doc/copyRecord-guarantees.md) at commit `be51fb10`.
