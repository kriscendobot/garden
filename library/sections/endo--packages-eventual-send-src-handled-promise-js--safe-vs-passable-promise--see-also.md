---
title: See also
source: packages/eventual-send/src/handled-promise.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/eventual-send/src/handled-promise.js
source_line_range: "369-401"
source_commit: ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2
comment_subject: "isSafePromise: the safety predicate, its relationship to marshal's passable-promise classification, and the residual reentrancy gap the check cannot close"
ingested: 2026-05-15
ingested_by: scholar
topics: [eventual-send, capability-security, marshal]
status: current
parent: endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise
---

- [[object-capability]] — the safety check is one of Endo's
  trust-boundary discipline points; the residual gap is a
  reminder that pure JS without language-level integrity
  primitives cannot fully close every reentrancy hazard.
- [`endo--pkg-marshal-readme--overview`](endo--pkg-marshal-readme--overview.md) — marshal's
  pass-style framework; this section explains the safety-vs-passability gap from the eventual-send side.
- [`endo--pkg-pass-style-readme--overview`](endo--pkg-pass-style-readme--overview.md) — pass-style's
  side of the same invariant: a passable promise is also safe by
  construction.
- [`endo--docs-lockdown--unhandled-rejection-trapping`](endo--docs-lockdown--unhandled-rejection-trapping.md) — adjacent
  lockdown concern: untrusted promises that are never awaited.

Source: [packages/eventual-send/src/handled-promise.js](https://github.com/endojs/endo/blob/ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2/packages/eventual-send/src/handled-promise.js#L369-L401) at commit `ec42cb7b`.
