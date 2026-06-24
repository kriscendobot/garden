---
title: §Future-work-named-in-source
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

The package's own design documents §three-future-extensions explicitly:
1. **§Shim-export**: "once the proposal gets farther along in the tc39 stage process, we will likely add a `panic-shim` export to this package."
2. **§Platform-specific-immediate-exit-on-other-platforms**: "As we become aware of similar functionality on other platforms, we expect to add them here."
3. **§Moddable-XS-print-function-detection**: TODO comment in source.

§Roadmap-in-the-readme is honest about §what-is-deferred-and-why. Sibling pattern to cycle 161 daemon-capability-filesystem's §Seven-Open-Questions and cycle 196 endoclaw's §gap-priority-classification.
