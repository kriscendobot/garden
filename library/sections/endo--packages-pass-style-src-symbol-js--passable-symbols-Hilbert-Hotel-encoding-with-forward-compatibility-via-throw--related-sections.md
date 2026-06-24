---
section: passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
source: endo--packages-pass-style-src-symbol-js
topics: [pass-style, marshal, hardened-javascript]
status: current
title: Related sections
parent: endo--packages-pass-style-src-symbol-js--passable-symbols-Hilbert-Hotel-encoding-with-forward-compatibility-via-throw
---

- cycle 71
  [[endo--packages-pass-style-src-passstyleof-js--passStyle-classifier-internals]]
  — the passStyleOf classifier that dispatches symbols to this
  file's `isPassableSymbol`.
- cycle 69
  [[endo--packages-marshal-src-encodetosmallcaps-js--smallcaps-wire-format-rationale]]
  — the smallcaps encoder that uses `nameForPassableSymbol`.
- cycle 81
  [[endo--packages-marshal-src-encodepassable-js--rank-order-preserving-encoder]]
  — the rank-order encoder that also uses
  `nameForPassableSymbol`.
- cycle 134
  [[endo--packages-pass-style-src-remotable-js--two-distinct-shapes-with-tag-record-inheritance-and-canBeMethod-invariant]]
  — `@@toStringTag` is the only allowed symbol property on
  remotables; this file's encoding is what makes that name
  passable.
- cycle 108
  [[endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio]]
  — same coordinated-update commit `e56bf00f` (the
  @endo/harden migration).
