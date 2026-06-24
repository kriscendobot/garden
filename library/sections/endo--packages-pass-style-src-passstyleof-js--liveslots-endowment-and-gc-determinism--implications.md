---
title: Implications
source: packages/pass-style/src/passStyleOf.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/pass-style/src/passStyleOf.js
source_line_range: "219-245"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Why pass-style exports the globalThis-installed passStyleOf when present (liveslots delegation), how the install-on-global gate stands in for explicit authorization, and the GC-detection hazard the delegated implementation must preserve determinism to avoid"
ingested: 2026-05-28
ingested_by: scholar
topics: [pass-style, marshal, capability-security, persistence]
status: current
parent: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism
---

- **Liveslots authors must preserve determinism even across GC.**
  A liveslot-supplied `passStyleOf` that re-classifies a reference
  after a sweep must return the same answer it would have returned
  before the sweep. The implementation is non-trivial: durable
  state may not survive GC verbatim, so the classifier must
  reconstitute enough to answer consistently.
- **Code paths that observe `passStyleOf` results are observing a
  contract.** Any code that branches on `passStyleOf(x)` and stores
  the result for later use is relying on the deterministic-classifier
  invariant. A future change to the classifier's contract (e.g.,
  permitting non-determinism in exchange for performance) would
  break the GC-detection-resistance argument; the change would
  need explicit security review.
- **The `Symbol.for('@endo passStyleOf')` name is a registry
  contract.** Two packages installing classifiers under the same
  symbol would collide; the name is therefore part of pass-style's
  ABI in the same way the wire format is. Any alternative
  virtualization layer (e.g., a non-SwingSet host that needs
  pass-style virtualization) must use the same symbol and accept
  the determinism requirement.
- **The delegation mechanism is the canonical example of
  authority-by-substrate in the Endo codebase.** Other authority
  delegations (the bare-module endowment pattern, the global
  Symbol registry usage for shim coordination) follow the same
  shape. Reviewers of new delegation points can cite this comment
  as precedent.

Source: [packages/pass-style/src/passStyleOf.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/pass-style/src/passStyleOf.js#L219-L245) at commit `e56bf00f`.
