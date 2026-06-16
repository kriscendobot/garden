---
title: §Throw-rather-than-infinite-loop with reasoned justification
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

The README explicitly considers and rejects the alternative:

> (As noted in the proposal, a higher fidelity emulation could, as a last resort, go into an infinite loop. But the consequences of this are too painful for both manual and CI testing. Besides, on some engines (browsers), in violation of the current JS spec, resume execution of user-code within the agent after the "infinite" loop exceeds a timeout. So even this strategy would not be safe on such engines.)

§Two-reasons-stacked:
1. **§CI-and-manual-testing-pain** — an infinite loop is *worse* than a thrown error for developers. The developer-experience argument is given equal weight to the security argument.
2. **§Browser-spec-violation-makes-infinite-loop-unsafe-too** — some browsers cap the infinite loop at a timeout and resume user-code. So even the "higher fidelity" alternative isn't actually higher fidelity on those engines.

§The-honest-naming-of-the-imperfection: the package is called `@endo/panic`, the README calls it "imperfect ponyfill" in the very first sentence, and the very last paragraph cautions:

> Because this `panic` ponyfill will, as a last resort, throw an error, users of this ponyfill on a platform where the first two strategies might fail, should cope with this possibility of the resumption of user-mode execution as best they can.

§Caveat-emptor-at-the-end: §the-library-does-not-promise-what-it-cannot-deliver. Sibling pattern to cycle 187 lockdown's NOTE-TO-REVIEWERS — both name the cost honestly.
