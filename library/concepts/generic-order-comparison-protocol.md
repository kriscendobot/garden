---
id: generic-order-comparison-protocol
aliases: ["compare operator", "equals operator", "polymorphic operator", "deep compare", "deep equals", "@collections/compare", "@collections/equals", "every value equal to itself", "NaN equals NaN", "contentCompare", "structural comparison"]
topics: [data-structures]
status: draft
---

# generic-order-comparison-protocol

The comparison and equality protocol that lets arbitrary values be ordered and deduplicated in `kriskowal/collections` structures. Two standalone *polymorphic operators*, `compare` and `equals`, accept any values, recurse structurally into arrays and plain objects, and delegate to a `compare` / `equals` method on either argument when present (favoring the left, inverting when the right supplies it). A polymorphic operator covers for types from higher architectural layers while deferring to a method name a later type may define, instead of monkey-patching backward. The defining core principle: **every value is equal to itself, including NaN** (`compare(NaN, NaN) === 0`, `equals(NaN, NaN)` true), deviating from IEEE-754 so any value set can be totally ordered for storage. Boxed primitives are unboxed first. `compare` returns a number signed like `left - right` (Infinity when magnitude is meaningless) but does not handle reference cycles; `equals` *does* tolerate cycles via an overridable memo (a `MiniMap` by default). The `generic-order` mixin plugs ordered collections into this protocol by deriving their `equals`/`compare` from iteration order; structures may also override per-collection `hash`/`equals`/`contentCompare` operators.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [collections--pkg-compare-readme--overview](../sections/collections--pkg-compare-readme--overview.md) | Deep polymorphic `compare`; signed like `left - right`; NaN equals itself; no cycle handling. |
| [collections--pkg-equals-readme--overview](../sections/collections--pkg-equals-readme--overview.md) | Deep polymorphic `equals`; cycle-safe via overridable `MiniMap` memo; order-insensitive object equality. |
| [collections--pkg-generic-order-readme--overview](../sections/collections--pkg-generic-order-readme--overview.md) | `generic-order` mixin derives `equals`/`compare` from deterministic iteration order. |

## See also

- [[generic-collection-mixin-protocol]] — `generic-order` is one of the four mixins; the comparison operators are how ordered structures become comparable.
- [[generic-collections]] — the library these operators serve.

## Common confusions

- This is `kriskowal/collections`' value-comparison protocol, distinct from `@endo/patterns`' key-comparison surface (`compareKeys.js`, `rankOrder`), which is a *partial* order over Passable keys with incommensurate pairs signaled by `NaN`. The collections `compare` is a *total* order intended for ordering arbitrary JavaScript values in non-capability collections.
