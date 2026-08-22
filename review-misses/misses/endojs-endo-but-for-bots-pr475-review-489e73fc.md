---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-review-489e73fc
verdict: miss
category: style-convention
pr: 475
cluster: error-message-names-in-scope-operation
cluster_pattern: A thrown error carries a generic message while the failing operation or context (a method name, an operation label) is already bound in scope and could name the failure; review reads the throw for correctness but not for whether the available identifying context is threaded into the message.
review_at: 2026-08-22T00:44:38Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#discussion_r3834604459
identity: endojs/endo-but-for-bots#475:review:4998400774
producing_role: builder/fixer campaign
producing_job: endojs-endo-but-for-bots-pr475 campaign
missed_by: saboteur located-error discipline (parser-scoped; did not generalize to a non-parser throw)
severity: minor
grounds: |
  The reviewed head defined the DataView write emulation as
  `makeDataViewWriter = (method, name) => { write(...args) { ... throw
  TypeError('Cannot write through a DataView on an immutable ArrayBuffer'); } }`.
  The setter method name was already bound as the `name` parameter and passed at
  every call site, yet the rejection message was generic and did not name which
  write was rejected. The maintainer asked that the in-scope `name` be used to
  build a more informative message and that sibling write methods on the other
  emulation abstractions be fixed the same way. This was reviewable from the diff
  alone with no maintainer-only knowledge: the unused identifying binding sits on
  the same line as the throw.
  It is a miss rather than new direction because the garden already encodes this
  exact instinct. The saboteur seat's "located-error discipline" requires that
  when a failure has a discernible origin, that origin be threaded into the error
  message so the failure surface names where the problem came from (provenance:
  endojs/endo-but-for-bots#131, kriskowal 2026-06-09). The lens existed; its brief
  scopes it to JSON parsing and analogous parsers, so it did not bind on a
  DataView setter throw even though the underlying principle is identical. A
  gauntlet ran on the incremental #475 head (journal job
  endojs-endo-but-for-bots-pr475-gauntlet-20260819) and did not flag the generic
  message.
  Severity is minor: the error is thrown correctly and immutability is enforced;
  only diagnostic quality is degraded. It is not eligible for the single-major
  standing-rule severity bypass because the standing rule that would have caught
  it is explicitly parser-scoped and so did not cover this case, and the defect is
  ergonomic rather than correctness- or security-class.
---

The maintainer observed that the DataView write-rejection error used a generic
message while the rejected setter's method name was already available in the
`name` binding, and asked that the name be used to make the message informative
(and that sibling write emulations be given the same treatment where they could
as easily). The primary job made the message name the rejected operation and
confirmed the sibling TypedArray mutators already identified their operations.

The review miss is that the garden's located-error discipline — thread a
discernible failure origin into the error message — lives in the saboteur seat
but is scoped to parsers, so a non-parser throw with the identifying name sitting
unused in scope passed the gauntlet unflagged. See `comment_url` to re-fetch the
untrusted review text.
