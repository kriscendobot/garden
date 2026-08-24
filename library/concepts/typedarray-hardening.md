---
id: typedarray-hardening
aliases: ["TypedArray hardening", "freezeTypedArray", "integer-indexed exotic hardening", "indexed cardinality"]
topics: [hardened-javascript, patterns]
status: draft
---

# typedarray-hardening

Endo's hardener treats genuine TypedArrays as a narrow exception to ordinary
`Object.freeze`: integer-indexed elements remain writable and
non-configurable, analogously to Map or Set internal data, while non-indexed
own properties are made non-configurable and their outbound references are
traversed. The exception is grounded in the ECMA-262 TypedArray exotic-object
rules and uses captured intrinsic brand checks rather than surface shape.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [`make-hardener.js` / `freezeTypedArray`](../sections/endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--the-named-freezetypedarray-with-tc39-spec-citation.md) | The canonical implementation, its per-key descriptor walk, TC39 rationale, and GraalJS fail-safe. |

## See also

- [[throwaway-instance-prototype-walk]] — another intrinsic-sensitive SES hardening pattern.
- [[security-as-extreme-modularity]] — the broader capability-security discipline that hardening supports.
