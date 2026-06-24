---
id: throwaway-instance-prototype-walk
aliases: ["throwaway-instance-prototype-walk", "hidden-intrinsic sampling", "IteratorPrototype sampling", "%URLSearchParamsIteratorPrototype%", "SES permit graph seed", "return-value prototype walk"]
topics: [hardened-javascript, patterns]
---

# throwaway-instance-prototype-walk

A SES taming pattern. When taming a host-provided built-in whose
methods return objects with their own prototype chain (iterators,
callables, etc.), the return-value prototype is reachable only by
**constructing a throwaway instance and walking
`Object.getPrototypeOf` from a method return**. SES's permits graph
won't visit those prototypes unless explicitly seeded. The discipline:
sample during the intrinsics-collection pass, add to the permits graph
under a synthetic name (e.g. `%URLSearchParamsIteratorPrototype%`),
list permitted properties, harden along with the rest of the
intrinsics. SES already does this for `%IteratorPrototype%` and
`%ArrayIteratorPrototype%`; new tamed built-ins join the list.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [hurl/iterator-prototype-sampling](../sections/endo-but-for-bots--llm-designs-hurl--iterator-prototype-sampling.md) | The worked example: `URLSearchParams` returns an iterator whose prototype is reachable only via throwaway-instance walk. |

The principle is codified in [`conventions.md`](../conventions.md) §
*Structural principles from cycles 41-43*.

## See also

- [[shape-not-content]] and [[producer-typed-shape-consumer-rendering]] — sibling structural principles from cycles 41-43.
