# Topic: ocapn

> Abstract: The OCapN (Object Capabilities Network) protocol family: a set of layered transports and wire formats for capability-bearing distributed objects. Includes CapTP at the application layer, marshal for serialization, netstring for framing, noise for encryption, and assorted codecs. Distinct from `captp` (which is the application-protocol topic specifically); ocapn groups the family while individual layers may warrant their own topics as the corpus grows.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--docs-get-started--distributed-programming](../sections/endo--docs-get-started--distributed-programming.md) | endo docs/get-started.md | Tutorial introduction to OCapN family, eventual-send, daemon. |
| [endo--pkg-patterns-docs-marshal-vs-patterns-level--ocapn-vs-passstyleof-vs-typeof](../sections/endo--pkg-patterns-docs-marshal-vs-patterns-level--ocapn-vs-passstyleof-vs-typeof.md) | endo packages/patterns/docs/marshal-vs-patterns-level.md | Three abstraction levels comparison: typeof / passStyleOf / OCapN kinds. |
| [ocapn--draft-specifications-model--overview](../sections/ocapn--draft-specifications-model--overview.md) | upstream protocol Model.md | Frame for the value-model spec; every section maps to a pass-style realization. |
| [ocapn--draft-specifications-model--value-and-atom-frame](../sections/ocapn--draft-specifications-model--value-and-atom-frame.md) | upstream protocol Model.md | Value/Atom top-level categories. |
| [ocapn--draft-specifications-model--atom-types](../sections/ocapn--draft-specifications-model--atom-types.md) | upstream protocol Model.md | 8 atom types (Undefined, Null, Boolean, Integer, Float64, String, Symbol, ByteArray). |
| [ocapn--draft-specifications-model--container-list](../sections/ocapn--draft-specifications-model--container-list.md) | upstream protocol Model.md | List container ↔ copyArray. |
| [ocapn--draft-specifications-model--container-struct](../sections/ocapn--draft-specifications-model--container-struct.md) | upstream protocol Model.md | Struct container ↔ copyRecord (with symbol-vs-string key disagreement). |
| [ocapn--draft-specifications-model--container-tagged](../sections/ocapn--draft-specifications-model--container-tagged.md) | upstream protocol Model.md | Tagged container ↔ pass-style tagged. |
| [ocapn--draft-specifications-model--reference-target](../sections/ocapn--draft-specifications-model--reference-target.md) | upstream protocol Model.md | Target reference ↔ pass-style remotable. |
| [ocapn--draft-specifications-model--reference-promise](../sections/ocapn--draft-specifications-model--reference-promise.md) | upstream protocol Model.md | Promise reference ↔ HandledPromise. |
| [ocapn--draft-specifications-model--error](../sections/ocapn--draft-specifications-model--error.md) | upstream protocol Model.md | Error value ↔ pass-style error + distributed-error correlation plans. |
| [ocapn--draft-specifications-model--pass-invariant](../sections/ocapn--draft-specifications-model--pass-invariant.md) | upstream protocol Model.md | Round-trip stability: Pass Type Invariant + Pass Invariant Equality. |
| [ocapn--draft-specifications-model--json-invariants](../sections/ocapn--draft-specifications-model--json-invariants.md) | upstream protocol Model.md | Relation of model to JSON; smallcaps extends this. |

## See also

- [`captp`](captp.md): the application-layer protocol in the OCapN family.
- [`marshal`](marshal.md): the serialization layer.
- [`eventual-send`](eventual-send.md): the application-level abstraction OCapN serves.
- [`capability-security`](capability-security.md): the underlying discipline.
