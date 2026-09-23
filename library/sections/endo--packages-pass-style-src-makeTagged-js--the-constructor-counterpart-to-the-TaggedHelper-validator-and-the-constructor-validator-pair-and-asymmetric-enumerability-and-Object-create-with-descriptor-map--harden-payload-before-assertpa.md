---
title: §`harden(payload)` BEFORE `assertPassable` — the harden-before-assert discipline
source-slug: endo--packages-pass-style-src-makeTagged-js
section-slug: the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/makeTagged.js
source-repo: endojs/endo
source-path: packages/pass-style/src/makeTagged.js
source-author: Endo project (collective)
total-lines: 31
ingest-cycle: 270
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map
---

Line 22: `assertPassable(harden(payload))`.

§The-order-IS-load-bearing — §`harden(payload)`-IS-called-first + §`assertPassable(harden(payload))`-checks-the-hardened-result; §this-IS-NOT `assertPassable(payload)` followed by `harden(payload)`.

§First-explicit-observation in library: **§the-harden-before-assert-discipline — §when-validating-a-value-as-passable, §harden-it-first-because-passability-checks-may-depend-on-the-value-being-immutable + §the-hardening-IS-part-of-the-passability-protocol-not-an-afterthought**.

§Sibling-pattern to cycle 134's make-far.js §mutate-harden-check-twice discipline; §two-cycles-with-the-harden-before-assert-discipline (134 + 270).
