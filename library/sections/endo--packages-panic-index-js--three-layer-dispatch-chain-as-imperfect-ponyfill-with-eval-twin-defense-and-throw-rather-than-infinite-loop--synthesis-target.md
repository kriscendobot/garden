---
title: §Synthesis-target
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

Slot machine library §panic-equivalent: §if-the-deck-state-becomes-impossible (e.g. integrity hash mismatch between two replicas, or a transaction's commit detects pre-condition failure), §do-not-resume-as-if-nothing-is-wrong. The §three-layer-dispatch-chain pattern adapts directly: registered-symbol delegation first (let the embedder install a panic handler), platform-immediate-exit second, throw-with-identity-check as the documented imperfect fallback. §Eval-Twin-defense applies if the slot machine library is loaded into multiple compartments. §Prepare-commit-with-panic-on-mid-commit-throw is the canonical shape for any §multi-step-side-effecting-transaction in slot machines (e.g. payout computation + ledger write + UI update).
