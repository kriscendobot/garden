---
id: polymorphic-operator
aliases: ["polymorphic operator", "polymorphic operators", "generic operator", "free-function operator", "operator delegates to method", "eponymous method dispatch", "covers higher layers defers to method", "monkey-patch alternative", "dunk-punch", "cover-up the omission"]
topics: [data-structures]
status: draft
---

# polymorphic-operator

The dispatch pattern every standalone `@collections/*` operator follows. A *polymorphic operator* is a free function that accepts an object as its first argument and varies its behavior by the object's type: it handles the built-in types it knows (arrays, plain objects, primitives) with a structural default, and **delegates to the eponymous method** (the method of the same name as the operator) on any object that implements it. This covers for types introduced by higher layers of architecture while *deferring* to a method name that a type defined in a later layer may supply, instead of monkey-patching (also called dunk-punching) a method backward through the layers. The README boilerplate states the motivation directly: "A well-planned system of objects is beautiful ... reaching backward in time, up through the layers of architecture doesn't always compose well, when different levels introduce concepts of the same name but distinct behavior." Examples: `clear(x)` calls `x.clear()` if present (so an observable array can dispatch range-change notifications), else deletes enumerable properties; `has(collection, value, equals?)` calls `collection.has(value, equals)` if present, else scans with `@collections/equals`; `clone`, `iterate`, `swap`, `to-array`, `zip`, `hash`, `compare`, and `equals` all follow the same shape. The collections suite uses this so its concrete structures (`Map`, `Set`, `SortedArray`, ...) interoperate with the free operators without those operators knowing the structure types in advance.

`compare` and `equals` are the comparison-and-equality instances of this pattern; their ordering-and-dedup specifics live under [[generic-order-comparison-protocol]]. Not every `@collections/*` helper is polymorphic: `copy` is a plain micro-utility (copy owned properties from one object to another, used to mix generic prototypes) with no method-delegation step.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [collections--pkg-clear-readme--overview](../sections/collections--pkg-clear-readme--overview.md) | `clear` empties an array/object or delegates to a `clear` method (observable arrays dispatch range changes). |
| [collections--pkg-clone-readme--overview](../sections/collections--pkg-clone-readme--overview.md) | `clone` deep-copies cyclic graphs with a depth and an overridable memo; delegates to a `clone(depth, memo)` method. |
| [collections--pkg-has-readme--overview](../sections/collections--pkg-has-readme--overview.md) | `has` tests membership with a pluggable equality; delegates to a `has` method. |
| [collections--pkg-hash-readme--overview](../sections/collections--pkg-hash-readme--overview.md) | `hash` returns a near-unique key for bucketing; delegates to a `hash` method. |
| [collections--pkg-iterate-readme--overview](../sections/collections--pkg-iterate-readme--overview.md) | `iterate` yields indexed iterations over arrays/objects; delegates to an `iterate(start, stop, step)` method. |
| [collections--pkg-swap-readme--overview](../sections/collections--pkg-swap-readme--overview.md) | `swap` is allocation-frugal splice for operational transforms; delegates to a `swap` method. |
| [collections--pkg-to-array-readme--overview](../sections/collections--pkg-to-array-readme--overview.md) | `to-array` coerces values to arrays; delegates to `toArray` then `forEach`. |
| [collections--pkg-zip-readme--overview](../sections/collections--pkg-zip-readme--overview.md) | `zip`/`unzip` transpose arrays of arrays; polymorphic variants funnel through `toArray`. |
| [collections--pkg-compare-readme--overview](../sections/collections--pkg-compare-readme--overview.md) | `compare`: the deep comparison instance of the pattern. |
| [collections--pkg-equals-readme--overview](../sections/collections--pkg-equals-readme--overview.md) | `equals`: the deep equality instance of the pattern. |

## See also

- [[generic-order-comparison-protocol]] — the `compare`/`equals` comparison-and-equality instances of this dispatch pattern.
- [[generic-collections]] — the library whose concrete structures these operators dispatch into.
- [[generic-collection-mixin-protocol]] — the abstract mixins concrete structures compose to gain the methods these operators delegate to.

## Common confusions

- A polymorphic operator is **not** the same as `@endo/no-polymorphic-call`'s notion. Endo's lint rule forbids polymorphic *method* calls on platform API objects for capability-confinement reasons; the collections polymorphic *operator* is a deliberate free-function dispatch convention in a non-capability library. They share a word, not a goal.
- `copy` lives in the same operator family by packaging but is not polymorphic: it has no method-delegation branch.
