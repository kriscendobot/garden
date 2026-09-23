---
title: The single most structurally interesting move
source: endo--packages-harden-make-hardener-js
url: https://github.com/endojs/endo/blob/master/packages/harden/make-hardener.js
authors: [Kris Kowal, Mark S. Miller, Google Caja contributors, Agoric contributors]
repo: endojs/endo
path: packages/harden/make-hardener.js
total-lines: 471
ingest-cycle: 338
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-canonical-harden-implementation
  - the-named-three-phase-traversal-with-named-commit-after-all-frozen
  - the-named-enqueue-dequeue-commit-algorithm
  - the-named-mark-hardened-only-after-all-frozen-discipline
  - the-named-transactional-harden-discipline
  - the-named-multi-generation-derivation-chain-named-in-the-header
  - the-named-four-stage-attribution-chain
  - the-named-FERAL-prefix-naming-convention
  - the-named-feral-error-with-named-reason
  - the-named-V8-error-own-stack-accessor-repair
  - the-named-platform-specific-repair-with-named-error-code
  - the-named-platform-detection-at-factory-time-not-per-call
  - the-named-platform-conditional-fast-path-vs-slow-path
  - the-named-acknowledged-and-bounded-hazard
  - the-named-triple-duplication-with-named-layering-constraint
  - the-named-bulk-destructure-of-globalThis
  - the-named-Safari-bug-workaround-with-named-tracking-URL
  - the-named-error-code-as-stable-URL-anchor
  - the-named-link-rot-acknowledgment-with-archive-URL
  - the-named-fallback-URL-when-canonical-dies
  - the-named-uncurry-this-canonical-idiom
  - the-named-hasOwn-shim-with-named-issue-link
  - the-named-substrate-of-substrates-zero-endo-imports
  - the-named-freezeTypedArray-with-tc39-spec-citation
  - the-named-freeze-before-traversal-defends-against-reactive-objects
  - the-named-getOwnPropertyDescriptors-defends-against-Object.prototype-poisoning
  - the-named-traversePrototypes-as-named-option
  - the-named-canonical-Endo-idiom-named-function-via-object-destructure
  - the-named-streak-resumes-with-ninth-instance
  - twenty-nine-cycles-with-named-pivot-domain-stay
  - sixty-two-citation-arc-closures-in-pivot-now
parent: endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen
---

**§the-named-three-phase-traversal-with-named-commit-after-all-frozen** — the `harden(root)` function (lines 339-467) has THREE separable phases:

```js
harden(root) {
  const toFreeze = new Set();

  function enqueue(val) { ... }
  const baseFreezeAndTraverse = obj => { ... };
  const freezeAndTraverse = ...;

  const dequeue = () => {
    setForEach(toFreeze, freezeAndTraverse);
  };

  const markHardened = value => {
    weaksetAdd(hardened, value);
  };

  const commit = () => {
    setForEach(toFreeze, markHardened);
  };

  enqueue(root);    // Phase 1: walk and enqueue everything reachable
  dequeue();        // Phase 2: freeze every enqueued value
  commit();         // Phase 3: mark every frozen value as hardened

  return root;
}
```

**§the-named-three-phase-traversal-with-named-commit-after-all-frozen** — first-explicit-observation as a tier-3 meta-pattern. The discipline:

| Phase | Operation | Failure semantics |
|---|---|---|
| **Enqueue** | Walk reachable graph; add unfrozen objects to `toFreeze` Set | Throws on non-object/non-function types |
| **Dequeue** | `setForEach(toFreeze, freezeAndTraverse)` — freeze each | May throw (proxy traps, accessor calls) |
| **Commit** | `setForEach(toFreeze, markHardened)` — mark each as hardened | Pure WeakSet adds; cannot throw |

**§the-named-mark-hardened-only-after-all-frozen-discipline** — first-explicit-observation. The COMMIT phase comes AFTER the DEQUEUE phase completes. If freezing fails mid-flight (e.g., a proxy trap throws, or a stack accessor misbehaves), the partially-frozen objects are NOT marked as hardened. This means:

1. **Re-attempting harden** on the same root re-walks the unfrozen-but-already-frozen objects (they pass `freeze()` as no-ops because frozen objects are idempotent under freeze)
2. **No partial-credit hardening** — `hardened` WeakSet membership is a CONFIRMED-COMPLETE state, not an IN-PROGRESS state
3. **Transactional discipline** — the all-or-nothing commit phase is the atomic transition

**§the-named-transactional-harden-discipline** — first-explicit-observation as a tier-3 meta-pattern. Compare to:
- Cycle 152 memo-race.js's §markSettled atomic-transition (read-then-assign-then-freeze-then-return; atomic state transition for a SINGLE record)
- Cycle 322 exo-makers.js's §seal-not-freeze-for-state (state seal is the boundary)
- Cycle 336 memo-race.js's §the-named-assign-then-freeze-transition (two-step terminal lock)
- **Cycle 338 make-hardener.js's §three-phase-traversal-with-named-commit-after-all-frozen** (three-phase transaction over a GRAPH)

**§four-shapes-of-atomic-transition-discipline** (152 single-record + 322 state-seal + 336 assign-then-freeze + 338 three-phase-over-graph) — first-explicit-observation as a tier-3 meta-pattern.

**§the-named-enqueue-then-dequeue-then-commit-algorithm** — the discipline of separating WALK + ACT + RECORD phases. Tier-3 meta-pattern: when an operation needs to be atomic over a graph, split it into three phases where the third phase is pure book-keeping that cannot fail.
