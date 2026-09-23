---
title: §The Moddable-XS infinite-regress check
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

```js
} else if (
  typeof globalThis.panic === 'function' &&
  panic !== globalThis.panic
) {
  // Primarily for Moddable XS.
  ...
  globalThis.panic(err);
}
```

The comment is unusually long for a single branch. It anticipates a §future-shim that takes this ponyfill's `panic` and installs it at `globalThis.panic`. Without the §`panic !== globalThis.panic` guard, the shim's installation would create an infinite call cycle: this ponyfill's `panic` would defer to `globalThis.panic` which would be this ponyfill's `panic` which would defer to `globalThis.panic`...

> In an Eval Twins scenario, the first to import the shim will cause that shim to install its own `globalThis.panic` from its ponyfill, and then its ponyfill would skip this case. All other instances of this package would then defer to the whose shim ran first.

§Eval-Twins-as-the-shim-coordination-mechanism — the first-to-load-wins-and-installs pattern, and all other twins defer to it. Subtle but the comment names it: §"defer to the whose shim ran first" (typo in source).

§Defense-against-self-referential-shim-installation is a pattern worth borrowing wherever a ponyfill might later become its own shim.
