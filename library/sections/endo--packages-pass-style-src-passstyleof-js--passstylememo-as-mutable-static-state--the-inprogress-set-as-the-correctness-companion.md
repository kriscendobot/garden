---
title: The inProgress Set as the correctness companion
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

Without the memo, every recursive call of `passStyleOf` would
detect cycles by maintaining a "currently being walked" set on the
call stack. The memo's lifetime is too long for that role: a value
appearing in the memo means it was *successfully* classified, not
that it is *currently being* classified. The `inProgress` Set is
constructed fresh per `passStyleOf` call, populated during the
recursive descent, and reset to empty before the function returns.
Its semantics:

- On entry to `passStyleOfRecur(inner)`: if `inner` is non-primitive
  and already in `passStyleMemo`, return the cached style without
  recursing or marking `inProgress`.
- If `inner` is non-primitive and not in the memo: assert
  `!inProgress.has(inner)` (a cycle would put us back at a value
  we have already started but not finished classifying) and add
  `inner` to `inProgress` before descending.
- On return from `passStyleOfInternal(inner)`: write the style into
  `passStyleMemo` and delete `inner` from `inProgress`.

This separation is what lets the memo store only *successfully
classified* values. A cyclic structure caught mid-walk would
otherwise leave a half-classified entry in the memo, corrupting
future calls. The two-table arrangement (long-lived memo for
successful classifications, short-lived set for in-progress
detection) is the standard pattern for recursive memoization with
cycle detection.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L101-L144) at commit `e56bf00f`.
