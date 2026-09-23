---
title: See also
source: packages/pass-style/src/passStyleOf.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/pass-style/src/passStyleOf.js
source_line_range: "101-144"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Why passStyleOf carries a WeakMap memo (asymptotic correctness for nested copyRecord walks), why the comment flags it as mutable static state, and how the inProgress Set complements the memo to catch cyclic structures during the recursive walk"
ingested: 2026-05-28
ingested_by: scholar
topics: [pass-style, marshal, capability-security, hardened-javascript]
status: current
parent: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state
---

- [[security-as-extreme-modularity]] — Structure of Authority's
  Table 1 names "forbid mutable static state" as the strict
  reading of "avoid global variables." `passStyleMemo` is a
  worked example of a *recorded* breach: the discipline names
  it, the comment surfaces the hazard, and a TODO marker
  ensures future review cannot forget the cost.
- [[principle-of-least-authority]] — the static-channel hazard
  is a POLA-at-the-temporal-dimension question. The memo's
  observability grants *any* party that holds a proxy reference
  the authority to detect prior classification, which is more
  authority than the classifier was asked to grant.
- [`endo--pkg-pass-style-readme--passstyleof`](endo--pkg-pass-style-readme--passstyleof.md)
  — the user-facing description of `passStyleOf`; this section
  is the internal data-structure rationale that the README
  intentionally hides.
- [`endo--pkg-pass-style-doc-copyrecord-guarantees--overview`](endo--pkg-pass-style-doc-copyrecord-guarantees--overview.md)
  — the frozen-and-string-keyed guarantees that make the
  memo's determinism assumption sound for legitimate passables.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L101-L144) at commit `e56bf00f`.
