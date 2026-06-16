---
title: Single most structurally interesting move
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

§three-layer-dispatch-chain-as-imperfect-ponyfill — `panic(err)` is the ponyfill for the TC39 proposal "[Don't Remember Panicking](https://github.com/tc39/proposal-oom-fails-fast)" whose semantics are *terminate the agent immediately so its internal data state (stack and heap) become unobservable*. JavaScript has no portable primitive that achieves that. So this ponyfill tries three increasingly-imperfect approximations in order, and explicitly throws-instead-of-infinite-loop as the last resort with §a-reasoned-justification.

The three layers, in order:

1. **§Registered-symbol delegation**: look up `globalThis[PanicEndowmentSymbol]`; if function, call it. (`PanicEndowmentSymbol = Symbol.for('@endo panic')` — registered, so all instances of this package in a single agent share the same symbol — see [Agoric/agoric-sdk Draft PR #11173 Don't remember panicking](https://github.com/Agoric/agoric-sdk/pull/11173) for swingset-liveslots integration.)
2. **§Platform-specific immediate-exit**: currently only `globalThis.process.abort()` (Node). README names this as growable as the team becomes aware of similar primitives on other platforms.
3. **§Last-resort `throw lastResortError`** — explicitly violates the spec but is the only remaining option once you reject the "infinite loop" alternative (see §throw-rather-than-infinite-loop-with-reasoned-justification).

Between layers 2 and 3 there's an additional §Moddable-XS-branch: if `typeof globalThis.panic === 'function' && panic !== globalThis.panic` then defer to that. This is the §infinite-regress-defense (a future shim built on the same ponyfill might install its own `globalThis.panic = panic` from this module, and a naïve check would create an infinite call cycle).
