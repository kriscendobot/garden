---
title: §Borrowable patterns (tier-1)
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

1. **§Three-layer-dispatch-chain-as-imperfect-ponyfill** — when a primitive isn't portable, try N approximations in order with documented fallback semantics.
2. **§Eval-Twin-defense-via-registered-symbol** following PassStyleOfEndowmentSymbol precedent — `Symbol.for(...)` for cross-twin identity; novel-subclass-for-identity-is-anti-pattern.
3. **§Two-identity-checks-with-named-trade-offs**: forgeable + twin-safe vs non-forgeable + twin-vulnerable. Export both so the consumer chooses.
4. **§Infinite-regress-defense via identity check** (`thisFn !== globalThis.fn`) for when your ponyfill might be installed as the very global it's checking for.
5. **§Throw-rather-than-infinite-loop with reasoned justification** — name the alternative, name why CI/dev-experience and browser-spec-violation rule it out.
6. **§Ponyfill-vs-shim-distinction named explicitly** with §two-stage-rollout-discipline (ponyfill first, shim later when the proposal advances).
7. **§Prepare-commit-transactional-pattern with panic-as-mid-commit-escape** — three-phase shape (prepare / try-commit / catch-panic) for unrecoverable-state-must-not-be-observable.
8. **§Default-erroneous-exit + no-ambient-normal-exit** asymmetry as a security stance; §"no-further-loss-in-security" argument when ambient functionality is debated.
9. **§Honest-design-evolution-in-the-README** — when the team's stance has changed, document the prior position alongside the new one.
10. **§Two-thirds-prose-one-third-code** comment density discipline for small files that carry large design decisions.
11. **§Caveat-emptor-at-the-end** of the README — name the platforms where the imperfect ponyfill is most imperfect.
12. **§Freeze-but-not-harden** for pre-lockdown packages that need integrity but cannot depend on SES whitelist.
13. **§Cross-package-composition** named in README: optional upgrade path that uses `@endo/errors` for better diagnostics when available.
14. **§Roadmap-in-the-README** — three named future-extensions with §what-blocks-them.
