---
title: §Eval-Twin-defense-via-registered-symbol (modeled on PassStyleOfEndowmentSymbol)
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

From the source comment:

> Modeled on `PassStyleOfEndowmentSymbol` of `@endo/pass-style`.

The Eval Twin Problem (issue #1583) is the failure mode where two copies of the *same* package (loaded by two compartments / two import paths / two iframes) end up with different identities. A `class FooError extends Error` defined by one copy will not be `instanceof FooError` to the other copy's check — `===` on the class is different. A registered symbol (`Symbol.for(...)`) is **the** canonical fix: registered symbols are globally interned per-agent, so all twins share the same key. The forgeability is the price of that compatibility (anyone can create an object with the same symbol property; the symbol is not a capability).

The design names this trade-off honestly:

> However, as a necessary price for avoiding Eval Twin Problems, this marking is forgeable -- anyone can create and throw a similar error.

And it offers a §second-identity-check that is §non-forgeable but with §false-negatives:

> We also export this error so that importers can use it as an identity check. This is not forgeable, i.e., not give false positives, but due to the Eval Twin Problem, may produce false negatives. Use this identity check with caution.

§Two-identity-checks-with-explicitly-named-trade-offs: §PanicEndowmentSymbol-property-presence is §forgeable-but-twin-safe; §`===` lastResortError-import-comparison is §non-forgeable-but-twin-vulnerable. Both are exported so the consumer chooses. §Library-pattern: §when-mitigating-Eval-Twin-document-both-trade-offs-so-consumer-can-choose.
