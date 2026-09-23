---
title: Abstract
source: packages/eventual-send/src/handled-promise.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/eventual-send/src/handled-promise.js
source_line_range: "122-194"
source_commit: ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2
comment_subject: "How dispatchToHandler reduces the six-operation API to a three-method minimum, and why SendOnly is a wrapper around the corresponding non-SendOnly operation"
ingested: 2026-05-15
ingested_by: scholar
topics: [eventual-send, captp]
status: current
parent: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly
---

The handler protocol exposes six operations to a `HandledPromise`
handler: `get`, `applyFunction`, `applyMethod`, and a `SendOnly`
variant of each (`getSendOnly`, `applyFunctionSendOnly`,
`applyMethodSendOnly`). A naive handler implementation would need
to write all six, with most of the SendOnly bodies trivially
identical to their non-SendOnly counterparts. The shim collapses
this surface in two ways, documented inline in `dispatchToHandler`:
(1) a SendOnly operation that the handler does not implement
substitutes the non-SendOnly version and discards the returned
promise, so a handler only needs to implement the SendOnly variant
when there is a genuine optimisation to exploit (no remote return
trip, no causality token); (2) `applyMethod` decomposes into
`get` followed by `applyFunction` when the handler omits
`applyMethod`, and `applyFunction` bottoms out into `applyMethod`
with an `undefined` method name when the handler omits
`applyFunction`. The net consequence is that a handler with only
`get` and `applyMethod` can correctly serve all six operations;
the shim composes the rest. This is the contract a CapTP or
OCapN handler implementation relies on, and it is why the
upstream interface table in handled-promise's `Handler` typedef
marks every field optional.

Source: [packages/eventual-send/src/handled-promise.js](https://github.com/endojs/endo/blob/ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2/packages/eventual-send/src/handled-promise.js#L122-L194) at commit `ec42cb7b`.
