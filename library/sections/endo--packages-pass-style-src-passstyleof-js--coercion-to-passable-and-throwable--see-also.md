---
title: See also
source: packages/pass-style/src/passStyleOf.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/pass-style/src/passStyleOf.js
source_line_range: "287-405"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Why pass-style exports two coercion functions (toPassableError, toThrowable) rather than just asserting passability, the diagnostic-preservation rule that motivates the copy-with-cause path, and the exo-boundary security-review framing that motivates throwables-only"
ingested: 2026-05-28
ingested_by: scholar
topics: [pass-style, errors, marshal, capability-security]
status: current
parent: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable
---

- [`endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case`](endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case.md)
  — the smallcaps-layer companion to this rule. The same
  diagnostic-preservation bias shapes the wire format's choice
  to pull errors out of recursion at the root.
- [`endo--docs-errors--hiding-revealing-local-diagnostic`](endo--docs-errors--hiding-revealing-local-diagnostic.md)
  — the canonical Endo errors framework. The
  diagnostic-information / redacted-message split is the
  architectural choice that makes `toPassableError`'s
  copy-with-annotation pattern useful: the original error's
  hidden diagnostic flows into the redaction layer while the
  copy is what crosses the wire.
- [[principle-of-least-authority]] — `toThrowable`'s
  no-PassableCap rule is POLA at the failure-path boundary. A
  throw that contains a remotable is a delegation of authority on
  a path the reviewer most likely overlooks; making throws
  authority-free narrows the surface that demands per-method
  review.
- [[security-as-extreme-modularity]] — the exo-boundary
  throwables-only contract enacts Table 1's "say what you mean /
  mean only what you say" row: the throw type is the contract,
  and constraining it makes the contract enforceable.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L287-L405) at commit `e56bf00f`.
