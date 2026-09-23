---
title: See also
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

- [[caretaker-pattern]] — the forwarding-forest is a low-level
  caretaker-of-sorts: the original `HandledPromise` is the
  *action-shaped* reference held by callers, and `shorten` is the
  bookkeeping that lets the *control* (resolution) of that
  reference be exercised in any order without breaking the
  caller-side action surface.
- [`endo--pkg-eventual-send-readme--handled-promise`](endo--pkg-eventual-send-readme--handled-promise.md) — the
  user-facing description of HandledPromise; this section is the
  internal data-structure rationale that the README intentionally
  hides.
- [`papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model`](papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model.md) — the paper introduces the
  *eventual reference* abstraction; this section documents the
  data structure Endo uses to make eventual-reference resolution
  cheap when resolution chains accumulate during pipelined work.

Source: [packages/eventual-send/src/handled-promise.js](https://github.com/endojs/endo/blob/ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2/packages/eventual-send/src/handled-promise.js#L67-L111) at commit `ec42cb7b`.
