---
section: legacy-guard-tolerance-and-payload-extraction-at-three-granularities-with-method-key-introspection
source: endo--packages-patterns-src-patterns-getGuardPayloads-js
topics: [patterns, exo]
status: current
title: The §getInterfaceMethodKeys + §getNamedMethodGuards
parent: endo--packages-patterns-src-patterns-getGuardPayloads-js--legacy-guard-tolerance-and-payload-extraction-at-three-granularities-with-method-key-introspection
---

introspection surface

The file's last two exports are *introspection helpers* for
interface guards:

- **`getInterfaceMethodKeys(interfaceGuard)`** returns the
  *union of string-named and symbol-named method keys*. Uses
  `Reflect.ownKeys(methodGuards)` for the string side and
  `getCopyMapKeys(symbolMethodGuards)` (imported from cycle
  102's checkKey.js) for the symbol side. The §empty-copyMap
  sentinel: `const emptyCopyMap = makeCopyMap([])` — *one
  empty-copyMap constant shared across calls when an interface
  has no symbol-named methods*.

- **`getNamedMethodGuards(interfaceGuard)`** returns *only the
  string-named method guards* — the use case is *interface-guard
  inheritance*, with the canonical pattern:

  ```js
  const I2 = M.interface('I2', {
    ...getNamedMethodGuards(I1),
    doMore: M.call().returns(M.any()),
  });
  ```

  The §spread-the-parent-into-the-child-record idiom is
  JavaScript-native interface inheritance. The function's JSDoc
  warns:

  > *While we could do more to support symbol-named method guards,
  > this feature is deprecated, and hopefully will disappear soon.*

  The §symbol-named-method-guards-are-deprecated note pairs with
  cycle 118's exo-tools.js section 2's `symbolMethodGuards` via
  `getCopyMapEntries(...)` — the deprecation hasn't landed yet,
  but the surface is being prepared for removal.

The §tested-in-another-package note: *Tested in @endo/exo by
exo-wobbly-point.test.js since that's already about class
inheritance, which naturally goes with interface inheritance*.
Same *tests-co-located-with-consumer* discipline as the
file-level legacy-tolerance tests.
