---
title: Implications
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

- The `shorten` walk is **the only place** in the shim that mutates
  `forwardedPromiseToPromise` along non-trivial paths. The other
  mutation sites (initial resolution, validation guards) write
  exactly one edge. Reviewers of changes touching forwarding
  semantics should treat `shorten` as the invariant guardian.
- A handler implementer (e.g., a CapTP author writing a
  remote-presence handler) never observes the forwarding forest
  directly. The forest is internal to the local shim; from the
  handler's perspective, the local shim presents already-shortened
  targets via `dispatchToHandler`.
- The "non-Promise root" leg of the comment's invariant is what
  lets the shim treat a plain JS value as a degenerate one-node
  forest. When a `HandledPromise` resolves to a non-promise `value`,
  the only entry recorded is the (presence → promise) mapping in
  `presenceToPromise`; there is no separate forwarding edge because
  there is nothing to forward to.

Source: [packages/eventual-send/src/handled-promise.js](https://github.com/endojs/endo/blob/ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2/packages/eventual-send/src/handled-promise.js#L67-L111) at commit `ec42cb7b`.
