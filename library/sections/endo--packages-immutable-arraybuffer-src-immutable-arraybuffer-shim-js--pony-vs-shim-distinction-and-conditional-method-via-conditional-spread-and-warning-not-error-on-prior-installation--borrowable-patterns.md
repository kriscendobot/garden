---
title: §Borrowable patterns
source-slug: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js
source-url: https://github.com/endojs/endo/blob/master/packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
total-lines: 97
ingest-cycle: 245
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation
---

**Tier-1 (highest borrowing value):**

- §Pony-vs-shim-distinction — pony is the mechanism, shim is the installation; first-explicit-observation in library.
- §Conditional-method-via-conditional-spread when platform feature is optional.
- §The-`opt`-prefix on pony functions that may or may not be exported.
- §Better-fidelity-emulation-of-class-prototype via non-enumerable properties.
- §Strip-enumerability-via-defineProperty-loop after object-literal construction.
- §Warning-not-error-on-prior-installation as modern-shim discipline.
- §Install-via-defineProperties-plus-getOwnPropertyDescriptors as canonical batch-install pattern.
- §TS-flow-inference-workaround-via-local-rebinding when the imported binding isn't live.

**Tier-2 (file-shape patterns):**

- §Destructure-globalThis-at-top with eslint-disable-no-restricted-globals.
- §Two-eslint-disables-with-distinct-named-justifications.
- §Getter-as-property-syntax for read-only properties on platform prototypes.
- §The-TODO-names-a-known-confusing-case in an acknowledged edge.

**Tier-3 (named comparisons):**

- §Three-cycles-with-platform-bridge-discipline (188 monkey-patch + 242 elevator-module + 245 pony-shim).
- §Three-different-shapes-of-platform-bridge.
- §Three-cycles-with-explicit-absence-as-attenuation (238 + 242 + 245).
