---
section: deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
source: endo--packages-pass-style-src-deeplyFulfilled-js
topics: [pass-style, eventual-send]
status: current
title: The §seven-case switch on passStyle
parent: endo--packages-pass-style-src-deeplyFulfilled-js--deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
---

After the top-level isAtom + isPromise checks, the function
switches on `passStyleOf(val)`:

| passStyle | Action |
|-----------|--------|
| `copyRecord` | Recursively `deeplyFulfilled` each value; `fromEntries(vals.map((c, i) => [names[i], c]))`; harden |
| `copyArray` | Recursively `deeplyFulfilled` each element; `Promise.all(...)`; harden |
| `byteArray` | Pass through unchanged (no recursion needed — bytes are atoms) |
| `tagged` | Recursively `deeplyFulfilled` the payload; `makeTagged(tag, payload)` |
| `remotable` | Pass through unchanged (a remotable is a leaf) |
| `error` | Pass through unchanged (an error is a leaf) |
| `promise` | `E.when(prom, nonp => deeplyFulfilled(nonp))` — recurse into fulfillment |

Three §leaf-styles pass through unchanged: `byteArray`,
`remotable`, `error`. Two §composite-styles recurse into their
parts: `copyRecord` and `copyArray`. One §wrapper-style recurses
into its payload: `tagged`. One §special-style awaits and
recurses: `promise`.

The §isAtom-check at the top *also* handles `byteArray`,
because byteArrays are atoms. The §switch's `byteArray` case
is therefore *almost* dead code — it would only fire if an
implementation distinguished byteArray-pass-style without
making byteArrays atoms. The §defensive-duplication discipline.
