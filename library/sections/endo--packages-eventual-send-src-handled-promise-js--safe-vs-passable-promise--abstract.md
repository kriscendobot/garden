---
title: Abstract
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

`HandledPromise.resolve(p)` must be safe to call on an *untrusted*
promise `p` without `p` getting a synchronous attack window. The
attack surface is the call to `p.then` (or to `await p`, which
desugars to `p.then`): if `p` overrides `then` or `constructor`, it
can run attacker-controlled code during what looks to the caller
like a passive resolution step. The shim defends with the
`isSafePromise(p)` predicate, which checks that `p` is frozen, has
the genuine `Promise.prototype`, is the canonical
`Promise.resolve(p)` fixpoint, and has no own `then` or
`constructor` descriptors. When the predicate holds, the shim
short-circuits and treats `p` as the answer directly; when it does
not, the shim assimilates `p` as if it were a non-promise thenable
and re-wraps it in a fresh `HandledPromise`. The comment
acknowledges a residual gap: the predicate itself reads `p`'s
properties synchronously, so a sufficiently malicious `p` could
mount a reentrancy attack *during the predicate evaluation*. This
gap is a known limitation of the current JS standard that the shim
cannot close locally. The related but stricter notion of a
*passable* promise (`passStyleOf(p) === 'promise'`) adds the
no-own-properties requirement that marshal needs for wire
serialization; every passable promise is also safe, but not every
safe promise is passable.

Source: [packages/eventual-send/src/handled-promise.js](https://github.com/endojs/endo/blob/ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2/packages/eventual-send/src/handled-promise.js#L369-L401) at commit `ec42cb7b`.
