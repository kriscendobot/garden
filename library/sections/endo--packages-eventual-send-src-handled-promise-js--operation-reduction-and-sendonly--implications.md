---
title: Implications
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

- A **CapTP author** implementing a remote presence's handler
  typically writes `get` and `applyMethod` against the wire
  protocol's question/answer ops, and lets the shim derive the
  rest. The optimisation lever is the SendOnly variants: a
  CapTP handler implements them explicitly when the wire protocol
  has a fire-and-forget primitive that skips the answer slot
  allocation.
- **Promise pipelining emerges from the reductions, not from a
  separate primitive.** When `applyMethod` decomposes into `get`
  followed by `applyFunction`, the intermediate `getResultP` is
  a `HandledPromise` that the shim will route through its own
  pending handler. If the handler has not yet resolved the
  target, the subsequent `applyFunction` queues against the same
  pending state, pipelining through the comm layer transparently.
  This is the implementation-side anchor of the user-facing
  `promise-pipelining` story in the @endo/eventual-send README.
- **The pass-through pattern in `dispatchToHandler` is shared with
  the `forwardingHandler` at the bottom of the file**, which
  routes operations from a *presence* (a resolved remote object)
  back into the same `handle` machinery. A reviewer changing the
  reduction logic should expect to touch both call sites; they
  are intentionally parallel.

Source: [packages/eventual-send/src/handled-promise.js](https://github.com/endojs/endo/blob/ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2/packages/eventual-send/src/handled-promise.js#L122-L194) at commit `ec42cb7b`.
