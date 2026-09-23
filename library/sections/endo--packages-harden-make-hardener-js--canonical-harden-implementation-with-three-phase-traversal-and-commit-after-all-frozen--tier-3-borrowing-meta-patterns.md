---
title: Tier-3 borrowing (meta-patterns)
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

- **§the-named-three-phase-traversal-with-named-commit-after-all-frozen** — when an operation needs to be atomic over a graph, split it into walk + act + record phases where the third phase cannot fail
- **§the-named-transactional-harden-discipline** — mark hardened only after all frozen; all-or-nothing
- **§four-shapes-of-atomic-transition-discipline** — single-record (152) + state-seal (322) + assign-then-freeze (336) + three-phase-over-graph (338)
- **§the-named-multi-generation-derivation-chain-named-in-the-header** — name each generation with clickable URL
- **§two-shapes-of-attribution-discipline** — verbatim-dedication (336) + multi-generation-chain (338)
- **§the-named-FERAL-prefix-naming-convention** — marker for values with excess authority
- **§the-named-error-code-as-stable-URL-anchor** — SES_ codes are stable grep-able identifiers
- **§three-shapes-of-stable-pointer-discipline** — deprecation-pointer (326) + issue-link (336) + error-code-Markdown (338)
- **§the-named-platform-detection-at-factory-time-not-per-call** — bake choice into closure, don't branch per-call
- **§the-named-acknowledged-and-bounded-hazard** — name hazard + bounded reason for accepting
- **§three-cycles-with-named-pay-only-when-necessary-discipline** — copy only when redaction needed (332) + harden-cast distinction (334) + platform-conditional fast-path (338)
- **§the-named-forward-vs-backward-pointer-discipline** — deprecation forward; bug-workaround backward
- **§the-named-link-rot-acknowledgment-with-archive-URL**
- **§the-named-named-lint-rule-with-canonical-exception** — rule + disable-comment as discipline-marker
- **§the-named-tc39-spec-citation-as-rationale** — spec URL as justification
- **§the-named-conceptual-analogy-to-justify-exception** — analogous-to-X structure
- **§the-named-dependency-import-count-tracks-package-tier** — zero @endo imports = substrate
- **§the-named-named-option-vs-positional-arg-discipline**
- **§the-named-canonical-Endo-idiom-named-function-via-object-destructure** — three-cycle confirmed idiom
