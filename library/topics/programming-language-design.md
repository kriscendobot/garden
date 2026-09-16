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
| [cap-talk-2009-2012--system-enforced-sensory-objects](../sections/cap-talk-2009-2012--system-enforced-sensory-objects.md) | cap-talk 2010-December | Transitive read-only across the OS/language boundary: Wagner's readonly-T type qualifier vs method-level auditing; the reference-vs-reference+rights asymmetry between language and OS capabilities. |
| [cap-talk-2009-2012--type-passing-and-rights-amplification](../sections/cap-talk-2009-2012--type-passing-and-rights-amplification.md) | cap-talk 2011-April | Magi versus Barbour on whether passing a function with its argument is rights amplification (it is not; amplification needs combined references) and whether method dispatch equals function invocation (a homomorphism, not an isomorphism). |
| [cap-talk-2009-2012--gc-versus-raii-resource-lifetime](../sections/cap-talk-2009-2012--gc-versus-raii-resource-lifetime.md) | cap-talk 2011-April/05 | Meijer versus Barbour on GC versus RAII for resource lifetime: whether 'being a resource' is transitive through composition, and Filardo's higher-order acquire-use-release (bracket) as the alternative Endo prefers over scope-bound RAII. |
| [language-support-for-object-capabilities](../sections/cap-talk-2009-2012--language-support-for-object-capabilities.md) | programming-language-design, hardened-javascript, capability-security | Kevin Reid's list of what a capability language should make cheap (encapsulation, immutable-by-default, cheap multi-facet objects, interposition), and why to design security in rather than add it on. |
| [limits-of-program-verification-and-policy-verification](../sections/cap-talk-2009-2012--limits-of-program-verification-and-policy-verification.md) | programming-language-design, capability-theory, capability-security | Verification proves correctness within a model, not security outside it; the value lies in writing the specification, and policy verification (confinement) is where proof pays. |

## See also

- `e-language`: a later object-capability language in the Smalltalk lineage.
- `capability-theory`: security consequences of reference-based object models.
- `learning-environments`: programming as a medium for constructing and revising models.
