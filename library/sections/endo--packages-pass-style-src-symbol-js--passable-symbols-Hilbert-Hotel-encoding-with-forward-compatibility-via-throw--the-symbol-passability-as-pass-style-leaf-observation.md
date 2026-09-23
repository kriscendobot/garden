---
section: passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
source: endo--packages-pass-style-src-symbol-js
topics: [pass-style, marshal, hardened-javascript]
status: current
title: The §Symbol-passability-as-pass-style-leaf observation
parent: endo--packages-pass-style-src-symbol-js--passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
---

Symbols are *leaves* in the pass-style tree (cycle 71's
passStyleOf classifier). The taxonomy distinguishes:

- **Passable symbols** (well-known + registered): can travel
  through marshal; reconstituted with *symbol identity*
  preserved across realms (well-known) or *registry string*
  preserved (registered).
- **Non-passable symbols** (anonymous `Symbol(description)`):
  marshal rejects them; equivalent to an error at encode time.

The §identity-vs-description-as-substrate distinction: a
well-known symbol's identity is its *role* (`Symbol.iterator`
*is* the iterator-protocol selector); a registered symbol's
identity is its *registry string*; an anonymous symbol's
identity is *only* its allocation moment, which doesn't
survive serialization.
