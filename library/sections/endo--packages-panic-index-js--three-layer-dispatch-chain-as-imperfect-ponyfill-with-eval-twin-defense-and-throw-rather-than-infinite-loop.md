---
title: Three-layer dispatch chain as imperfect ponyfill with Eval-Twin defense via registered symbol, infinite-regress check, and throw-rather-than-infinite-loop with reasoned justification — @endo/panic index.js + README.md
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
kind: index
section_count: 16
---

Sections:

- [Source](endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop--source.md)
- [Single most structurally interesting move](endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop--single-most-structurally-interesting-move.md)
- [§Ponyfill-vs-shim distinction named explicitly in the README](endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop--ponyfill-vs-shim-distinction-named-explicitly-in-the-readme.md)
- [§Eval-Twin-defense-via-registered-symbol (modeled on PassStyleOfEndowmentSymbol)](endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop--eval-twin-defense-via-registered-symbol-modeled-on-passstyleofendowmentsymbol.md)
- [§The Moddable-XS infinite-regress check](endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop--the-moddable-xs-infinite-regress-check.md)
- [§Throw-rather-than-infinite-loop with reasoned justification](endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop--throw-rather-than-infinite-loop-with-reasoned-justification.md)
- [§Prepare-commit-transactional-pattern as canonical use-case](endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop--prepare-commit-transactional-pattern-as-canonical-use-case.md)
- [§Default-erroneous-exit + no-ambient-normal-exit asymmetry](endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop--default-erroneous-exit-no-ambient-normal-exit-asymmetry.md)
- [§Five-line-control-flow-table](endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop--five-line-control-flow-table.md)
- [§`Object.freeze` discipline](endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop--object-freeze-discipline.md)
- [§Comment-density per line](endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop--comment-density-per-line.md)
- [§Future-work-named-in-source](endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop--future-work-named-in-source.md)
- [§Borrowable patterns (tier-1)](endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop--borrowable-patterns-tier-1.md)
- [§Synthesis-target](endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop--synthesis-target.md)
- [§Eighteenth-cycle-of-§small-files-with-large-knowledge-density family discipline](endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop--eighteenth-cycle-of-small-files-with-large-knowledge-density-family-discipline.md)
- [§Cycle 197 meta-observations](endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop--cycle-197-meta-observations.md)
