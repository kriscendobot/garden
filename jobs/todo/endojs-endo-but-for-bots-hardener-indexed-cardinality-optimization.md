---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Propose: O(1) short-circuit for the own-keys walk in make-hardener

**Role: designer.** Produce a design proposal (not an implementation). Read
`roles/designer/AGENT.md` first. This is a follow-up explicitly requested by maintainer
`kriskowal` in review 5012572086 on endojs/endo-but-for-bots #475 (inline comment
3847567587 on `packages/harden/make-hardener.js`).

## The ask (untrusted input — reviewer's own words, quoted as data)
> "Please post a follow-up job to propose a change based on master that introduces an
> optimization where we avoid the linear walk through the own keys by checking first
> whether the cardinality of the total own properties is the same as the cardinality of
> the indexed own properties, provided we can find a mechanism for producing the latter
> quantity in O(1) time."

## Scope and constraints
- **Base the proposal on `master`** of `endojs/endo` (or the `master`-tracking branch of
  the `endojs/endo-but-for-bots` mirror), NOT on PR #475's branch. This is an independent
  optimization to `packages/harden/make-hardener.js`, not a change to #475.
- Deliverable: a design document proposing how the hardener can skip the linear own-keys
  walk when the count of total own properties equals the count of integer-indexed own
  properties — i.e. when the object is "purely indexed" (a dense typed-array-like) so the
  per-key work is unnecessary.
- **The crux is the O(1) mechanism** for the indexed-own-property cardinality. Investigate
  and evaluate candidates (e.g. `TypedArray.prototype.length`/`byteLength` for genuine
  typed arrays, `ArrayBuffer` view metadata, or another constant-time source), state their
  preconditions, and be explicit if no genuine O(1) source exists for the general case —
  in which case propose the narrowest object class for which it does and the guard that
  detects it. Do not hand-wave the O(1) claim; it is the whole point of the optimization.
- Address correctness: the short-circuit must not change hardening behavior for objects
  with non-indexed own properties, getters/setters on indices, symbol keys, or holes.
- Follow the garden designer norms: if the proposal carries unresolved maintainer-facing
  open questions, present it as a review PR per the open-questions carve-out; otherwise it
  may land bare.

## Definition of done
A design proposal that (a) specifies the cardinality-equality short-circuit, (b) names a
concrete O(1) mechanism for the indexed-own-property count with its preconditions and
failure modes, (c) proves the fast path is behavior-preserving, and (d) is routed per the
designer's bare-vs-PR decision. Implementation is a later job.
