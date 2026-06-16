---
title: The single most structurally interesting move
source: endo--packages-pass-style-src-passStyleOf-js
url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/passStyleOf.js
authors: [Mark S. Miller, Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/pass-style/src/passStyleOf.js
total-lines: 405
ingest-cycle: 350
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-package-self-detects-endowment-via-global-symbol
  - the-named-PassStyleOfEndowmentSymbol-as-canonical-name
  - the-named-NOTE-HAZARD-comment-discipline
  - the-named-liveslots-as-canonical-endower
  - the-named-isFrozen-check-at-the-evolution-points
  - the-named-TypedArrays-get-special-treatment-error-distinction
  - the-named-confirmCanBeValid-then-assertRestValid-two-phase-validation
  - the-named-helper-table-with-assertions-on-table-construction
  - the-named-defensive-init-pattern-for-registries
  - the-named-PASS_STYLE-as-well-known-tag-symbol
  - the-named-complementary-lens-re-ingest
  - nine-cycles-with-named-complementary-lens-re-ingest
  - the-named-citation-arc-from-cycle-71-takes-279-cycles-to-close
  - forty-one-cycles-with-named-pivot-domain-stay
  - one-hundred-forty-two-citation-arc-closures-in-pivot-now
parent: endo--packages-pass-style-src-passStyleOf-js--ninth-complementary-lens-package-self-detects-endowment-via-global-symbol-and-NOTE-HAZARD-discipline
---

**§the-named-package-self-detects-endowment-via-global-symbol** — lines 219 + 236-238:

```js
export const PassStyleOfEndowmentSymbol = Symbol.for('@endo passStyleOf');

export const passStyleOf =
  (globalThis && globalThis[PassStyleOfEndowmentSymbol]) ||
  makePassStyleOf([...]);
```

The package EXPORTS an endowment symbol and CHECKS if a host has installed a custom implementation at that symbol on globalThis. If yes, use the host's; if no, build the default.

**§the-named-package-self-detects-endowment-via-global-symbol** — first-explicit-observation as a tier-3 meta-pattern. The discipline:
1. Define a `Symbol.for('@org name')` as the endowment point
2. Export the symbol so hosts can write to globalThis at that key
3. At module load, check globalThis[symbol] first; fall through to default if absent

**§the-named-PassStyleOfEndowmentSymbol-as-canonical-name** — first-explicit-observation. The symbol's name encodes the package identity (`@endo passStyleOf`).
