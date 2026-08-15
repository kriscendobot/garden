---
order: serial
children: ironhorse-js-26-cf-ta-exotic-internals ironhorse-js-26-cf-ta-from-of ironhorse-js-26-cf-ta-native-data-descriptors
on-child-failure: halt
state: running
created_by: gardener
created_at: 2026-08-15T01:32:41Z
---

# js-26 cf: TypedArrayConstructors residual orchestration

Owns the remaining non-covered surface of `built-ins/TypedArrayConstructors` after the ctor-arm child
`ironhorse-js-26-cf-ta-ctor` closed the constructor forms (48→245 covered on branch tip `89fddc894`).
Serial, halt-on-failure over three clusters, each a distinct engine surface:

1. `ironhorse-js-26-cf-ta-exotic-internals` — the `internals/` integer-indexed exotic object model
   (defineProperty/getOwnPropertyDescriptor/Reflect.* exotic-object, element-set coercion). ~238 cases.
2. `ironhorse-js-26-cf-ta-from-of` — `%TypedArray%.from`/`.of` + the from-object construction protocol
   (iterator + array-like source). ~120 cases. Depends on the element-set coercion path in (1).
3. `ironhorse-js-26-cf-ta-native-data-descriptors` — the general lazily-bound native data-property
   descriptor + writability gap (per-type BYTES_PER_ELEMENT/name/length/proto verifyProperty cases).

Note: several residuals are cross-cutting general-engine gaps (Array.from iterator-protocol metering,
$262 cross-realm `proto-from-ctor-realm` host-only aborts, resizable ArrayBuffer) that may be owned by
sibling js-26 children; a child that finds its blocker owned elsewhere should coordinate rather than
duplicate. Run per PR endojs/endo-but-for-bots#970 on `feat/ironhorse-262-language-completion`.
