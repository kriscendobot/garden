---
title: Abstract
source: packages/eventual-send/src/handled-promise.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/eventual-send/src/handled-promise.js
source_line_range: "67-111"
source_commit: ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2
comment_subject: "Forwarding-forest invariant + the shorten() walk that amortizes resolution lookups"
ingested: 2026-05-15
ingested_by: scholar
topics: [eventual-send, persistence]
status: current
parent: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find
---

When a `HandledPromise` is resolved to *another* `HandledPromise`,
the shim does not eagerly rewrite every reference holding the older
promise. Instead, it records a single forwarding edge in a
`WeakMap` called `forwardedPromiseToPromise`. Over many such
resolutions, a forest emerges whose roots are unresolved
`HandledPromise`s (or non-promise final values) and whose interior
nodes are forwarded handled promises pointing at their resolution
target. The `shorten(target)` walk finds the most-resolved value
for `target` and, on the way back, **rewrites every interior
node it touched to point directly at the new root**. This is the
"Path splitting" variant of the Find operation from the classic
union-find data structure. The shim's choice of path-splitting (over
path-compression or path-halving) gives amortized near-constant-time
lookup without recursive call stacks, which matters because
`shorten` runs synchronously inside resolution callbacks that the
host's promise machinery already constrains to short, allocation-light
work.

Source: [packages/eventual-send/src/handled-promise.js](https://github.com/endojs/endo/blob/ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2/packages/eventual-send/src/handled-promise.js#L67-L111) at commit `ec42cb7b`.
