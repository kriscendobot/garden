---
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/eventual-send/src/handled-promise.js
source_line_range: "44-389"
source_commit: ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2
comment_subject: "Handler protocol for HandledPromise: forwarding-graph as a union-find forest, safe vs passable promises, and the SendOnly / applyMethod compositional reductions"
source_authors: [Kris Kowal, Mark S. Miller, Mathieu Hofman, Michael FIG, Richard Gibson, Saleh Abdel Motaal, Turadg Aleahmad]
ingested: 2026-05-15
ingested_by: scholar
section_count: 3
status: current
notes: |
  First ingest from the new comment-fragment corpus
  (cycle 66; source_kind: comment-fragment was defined by
  `entries/2026/05/15/205458Z-message-liaison-0460cf.md`).
  Three sections distilled from the longform JSDoc and bare-block
  comments that bracket the makeHandledPromise factory function and
  the dispatchToHandler operation reducer. Sections cover the three
  cohesive arguments the comments make: (1) why the forwarding map is
  shaped as a union-find forest with path-splitting; (2) why
  isSafePromise's check is necessary, why passable promises are a
  stricter subset, and what reentrancy attack the check defends
  against; (3) how applyMethod and SendOnly variants reduce to a
  minimal handler API so handler implementers only need to provide
  the base operations.
---

## Abstract

`packages/eventual-send/src/handled-promise.js` is the shim that
installs `HandledPromise` as the JS Promise subclass on which the
`E()` eventual-send API rides. Its longform comments document three
non-obvious mechanisms the implementation relies on: the
forwarding-graph maintained as a union-find forest (so that resolving
a chain of forwarded promises is amortized near-constant rather than
linear in chain length), the safety distinction between *safe*
promises and the stricter *passable* promises (the prerequisite for
`HandledPromise.resolve(p)` to defend against re-entrancy attacks
by an untrusted `p`), and the family of compositional reductions
that let a handler implementation provide only the three base
operations (`get`, `applyFunction`, `applyMethod`) and have the four
`SendOnly` variants plus the cross-operation reductions derived
automatically. The comments are the canonical source for these
three invariants, which the surrounding code references but does
not re-explain.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [forwarding-forest-union-find](../sections/endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find.md) | eventual-send, persistence | current |
| [safe-vs-passable-promise](../sections/endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise.md) | eventual-send, capability-security, marshal | current |
| [operation-reduction-and-sendonly](../sections/endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly.md) | eventual-send, captp | current |

## Provenance

- File last modified 2026-04-08 by Turadg Aleahmad.
- File-specific commit `ec42cb7b` (captured 2026-05-15).
- Comments authored across the file's history by Mark S. Miller, Kris Kowal, Michael FIG, Mathieu Hofman, Richard Gibson, and others. The implementation is described as "based heavily on nanoq" by drses; the upstream desugaring spec is the archived ecmascript wiki "infix-bang (predecessor to wavy-dot)" strawman.

Source: [packages/eventual-send/src/handled-promise.js](https://github.com/endojs/endo/blob/ec42cb7b8fa139b44f96976ca24711cdc6cd8ee2/packages/eventual-send/src/handled-promise.js) at commit `ec42cb7b`.
