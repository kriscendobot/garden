---
title: §Ponyfill-vs-shim distinction named explicitly in the README
source: endo packages/panic/{index.js,README.md,SECURITY.md,CHANGELOG.md}
source-slug: endo--packages-panic
ingest-cycle: 197
ingest-date: 2026-06-06
lane: chat
authors: [Mark Miller, Kris Kowal]
keywords:
  - ponyfill-vs-shim distinction
  - Eval Twin Problem
  - registered-symbol vs novel-subclass
  - three-layer dispatch chain
  - infinite-regress check
  - throw-rather-than-infinite-loop
  - lastResortError as identity check (forgeable + non-forgeable both honestly named)
  - prepare-commit-transactional-pattern as canonical use-case
  - Don't Remember Panicking TC39 proposal
  - PanicEndowmentSymbol following passStyleOfEndowmentSymbol precedent
  - default-erroneous-exit + no-ambient-normal-exit
  - historical-note-explaining-why-ambient-panic-no-longer-loses-security
related:
  - endo--packages-pass-style (sibling: PassStyleOfEndowmentSymbol precedent + Eval Twin Problem)
  - endo--packages-errors (panic README: makeError/X/q template tag)
  - endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js (cycle 189: also cites Eval Twin defenses + qp-vs-q template tag pair)
  - endo--packages-init-and-lockdown (cycle 183: two-phase init also depends on SES primordials)
parent: endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop
---

> By "ponyfill" vs "shim", we mean that a ponyfill does not modify the primordial intrinsics/built-ins, but rather just exports its new functionality as conventional package/module exports. By contrast, a "shim" does modify the primordial intrinsics/built-ins as needed to most closely emulate the proposal it shims.

The README continues:

> Our normal style for a package that emulates a proposal is to default-export the ponyfill, and then when ready, separately export the shim built on that ponyfill.

§Two-stage-rollout-discipline: §ponyfill-first-then-shim. The README acknowledges that v1.0.1 is too early for the shim because the TC39 proposal hasn't advanced enough. §Honest-deferral-of-the-shim. Sibling pattern to cycle 187's shim+prepare-endo cluster which used two shim strategies (declare-and-then-shim vs shim-on-import).

§Important-consequence: "a ponyfill by itself is subject to the [Eval Twin Problem](https://github.com/endojs/endo/issues/1583), whereas a shim is not." The §Eval-Twin-Problem-as-the-cost-of-being-a-ponyfill is explicit. The choice to mitigate via §registered-symbol (rather than a novel `class PanicError extends Error`) is the design's load-bearing move.
