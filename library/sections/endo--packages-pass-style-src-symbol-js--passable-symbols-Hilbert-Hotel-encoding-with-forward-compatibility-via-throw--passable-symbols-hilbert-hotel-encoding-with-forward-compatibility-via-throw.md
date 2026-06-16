---
section: passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
source: endo--packages-pass-style-src-symbol-js
topics: [pass-style, marshal, hardened-javascript]
status: current
title: "Passable symbols: Hilbert-Hotel encoding with forward-compatibility via throw"
parent: endo--packages-pass-style-src-symbol-js--passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
---

> *Since the registration string of a registered symbol can
> be any string, if we simply used that to identify those
> symbols, there would not be any remaining strings left
> over to identify the well-known symbols. Instead, we
> reserve strings beginning with `"@@"` for purposes of this
> encoding... For registered symbols whose name happens to
> begin with `"@@"`, such as `Symbol.for('@@iterator')` or
> `Symbol.for('@@foo')`, we identify them by prefixing them
> with an extra `"@@"`, such as `"@@@@iterator"` or
> `"@@@@foo"`. **(This is the Hilbert Hotel encoding
> technique.)***
>
> — `packages/pass-style/src/symbol.js` lines 51-60

`symbol.js` (123 lines) is the **passable-symbol surface**
for @endo/pass-style. Defines what counts as a *passable
symbol* (predicate + assertion), the bidirectional encoding
between symbols and their wire-form string names, and an
escape hatch for non-passable symbols. Last touched 2025-10-09
by Kris Kowal in cycle 108's coordinated-update commit
`e56bf00f` (the @endo/harden migration that touched many
@endo files simultaneously).
