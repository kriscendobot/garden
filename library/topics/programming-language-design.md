Programming-language design concerns the semantic models and surface mechanisms through which people name, compose, execute, inspect, and redefine computation. This topic collects general language arguments such as object/message uniformity, processes with state and control, executable operational models, and the boundary between a small semantic core and user-defined abstractions. It is broader than `e-language`, which catalogs one capability-secure distributed language.

## Sections

| Section | Source | Summary |
|---|---|---|
| [Operational models and development](../sections/web--kay-personal-computer-for-children-1972--operational-models-and-development.md) | Kay, *A Personal Computer for Children of All Ages* (1972) | Programming as executable operational knowledge that can be observed, debugged, and refined. |
| [Objects as processes](../sections/web--kay-personal-computer-for-children-1972--objects-as-processes.md) | Kay, *A Personal Computer for Children of All Ages* (1972) | Objects as stateful processes with control paths, messages, and user-definable abstractions. |
| [managed-language-object-references-as-capabilities](../sections/cap-talk-2009-2012--managed-language-object-references-as-capabilities.md) | cap-talk 2009-August | Memory safety, reference unforgeability, and explicit endowments can replace hardware address-space separation. |
| [full-abstraction-at-the-bytecode-boundary](../sections/cap-talk-2009-2012--full-abstraction-at-the-bytecode-boundary.md) | cap-talk 2009-September | Verified target bytecode can violate source-language invariants without escaping memory safety. |
| [mutable-singletons-are-ambient-authority](../sections/cap-talk-2009-2012--mutable-singletons-are-ambient-authority.md) | cap-talk 2010-March | Mutable global singletons are an ambient-authority anti-pattern; the unum pattern and location-transparent embedded capabilities are the alternative. |
| [safe-language-defined-and-ocap](../sections/cap-talk-2009-2012--safe-language-defined-and-ocap.md) | cap-talk 2010-April | Pierce's definition of a safe language (protects its own abstractions) and the ocap-language-as-hyponym dispute. |

## See also

- `e-language`: a later object-capability language in the Smalltalk lineage.
- `capability-theory`: security consequences of reference-based object models.
- `learning-environments`: programming as a medium for constructing and revising models.
