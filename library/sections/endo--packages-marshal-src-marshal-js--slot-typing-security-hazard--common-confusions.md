---
title: Common confusions
source: packages/marshal/src/marshal.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/marshal.js
source_line_range: "238-256, 322-336"
source_commit: da16a78e177904e08bd4603527fef98d68af2bbd
comment_subject: "TODO SECURITY HAZARD on decodeSlotCommon (remotable-vs-promise) and the matched implementation restriction on the capdata branch (#4334)"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, capability-security, captp]
status: current
parent: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard
---

- The `Nat(index)` coercion is *not* the security check. `Nat`
  validates that the slot index is a non-negative integer (so the
  index can be used as an array index without coercion surprises);
  it does not validate the slot's kind. A reader who sees the
  `Nat` call and stops there has misread the hazard.
- "Implementation restriction" in this file does *not* mean "the
  spec forbids it". It means "until the wire encoding is upgraded
  to disambiguate, the implementation routes around the ambiguity
  by requiring identical handlers". A future capdata-successor
  encoding could lift the restriction; the comment treats this as
  the intended direction.
- The smallcaps prefix discrimination (`$` vs `&`) does *not* fully
  solve the hazard. It catches a wrong-prefix-on-wire case but not
  a kind-vs-application-slot-table mismatch. The TODO on
  `decodeSlotCommon` remains open in the smallcaps path as well.

Source: [packages/marshal/src/marshal.js](https://github.com/endojs/endo/blob/da16a78e177904e08bd4603527fef98d68af2bbd/packages/marshal/src/marshal.js#L238-L336) at commit `da16a78e`.
