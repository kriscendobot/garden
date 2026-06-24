---
title: Implications
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

- The two-tier (safe / passable) classification is the canonical
  rationale for marshal's `passStyleOf(p) === 'promise'` being
  *more restrictive* than what the eventual-send shim requires.
  A new-pass-style proposal that loosened passability to match
  safety would re-introduce the same own-property hazard marshal
  is defending against on the wire.
- The `await p` call inside `HandledPromise.resolve` is the
  reason the `constructor` descriptor must be missing. A
  reviewer reading the body without the comment might think the
  `constructor` check is paranoid; it is in fact load-bearing
  for the `await` semantics.
- The reentrancy gap is the kind of limitation that motivates
  *capability hygiene at the boundary*: a daemon receiving a
  promise from an outside source should treat it as untrusted
  until it has been laundered through `HandledPromise.resolve`,
  and even then it should treat the resolved value as untrusted
  until the daemon's own validators have passed it.

Source: [packages/eventual-send/src/handled-promise.js](https://github.com/endojs/endo/blob/ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2/packages/eventual-send/src/handled-promise.js#L369-L401) at commit `ec42cb7b`.
