---
title: §`@template T` parameterization on all three typedefs
source-slug: endo--packages-promise-kit-src-types-js
source-url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/types.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/promise-kit/src/types.js
total-lines: 25
ingest-cycle: 256
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-promise-kit-src-types-js--PromiseKit-as-reified-Promise-and-ERef-as-four-named-shapes-and-PromiseRecord-as-deprecated-alias-and-second-typedef-only-file
---

§All-three-typedefs-are-parameterized-by-T. §The-parameterization-IS-the-shared-axis: §the-PromiseKit-resolves-to-T + §the-PromiseRecord-aliases-PromiseKit-of-T + §the-ERef-accepts-any-shape-of-T.

§Sibling-pattern-to-cycle-237's-`@template T`-constraint + cycle-249's-`@template {Record<RemotableMethodName, CallableFunction>} M` — §three-cycles-with-`@template`-parameterization (237 + 249 + 256). §Different-shapes-of-template-use: §cycle-237 unconstrained-T + §cycle-249 T-with-Record-constraint + §cycle-256 unconstrained-T-across-three-related-typedefs.
