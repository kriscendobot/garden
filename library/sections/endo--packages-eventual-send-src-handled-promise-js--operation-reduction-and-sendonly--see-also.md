---
title: See also
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

- [`endo--pkg-eventual-send-readme--e-method-call`](endo--pkg-eventual-send-readme--e-method-call.md) — the
  user-facing description of `E(target).method(args)`; this
  section is the implementation-side rationale for why all six
  surface operations are dispatched through the same reducer.
- [`endo--pkg-eventual-send-readme--promise-pipelining`](endo--pkg-eventual-send-readme--promise-pipelining.md) — the
  user-facing pipelining narrative; this section names the
  reduction step at which pipelining mechanically emerges.
- [`endo--pkg-captp-readme--usage`](endo--pkg-captp-readme--usage.md) — CapTP's
  surface; CapTP handlers implement the minimal `get` /
  `applyMethod` pair plus SendOnly optimisations where the wire
  protocol supports fire-and-forget.
- [`ocapn--draft-specifications-captp--promises`](ocapn--draft-specifications-captp--promises.md) — the
  wire-protocol's promise/answer slot model; the SendOnly
  optimisation maps to the protocol's no-answer-needed encoding.

Source: [packages/eventual-send/src/handled-promise.js](https://github.com/endojs/endo/blob/ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2/packages/eventual-send/src/handled-promise.js#L122-L194) at commit `ec42cb7b`.
