# Topic: marshal

> Abstract: Marshal is endo's pass-style serialization layer. Each value passing through the boundary is classified by pass-style (passable copy types like `copyArray` and `copyRecord`, or `remotable` for capability-bearing references). Smallcaps is the JSON-like wire format; pass-style classifies what can cross the wire. Distinct from `patterns` (which describes shapes for matching, not for transport).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--docs-errors--hiding-revealing-distributed-diagnostic](../sections/endo--docs-errors--hiding-revealing-distributed-diagnostic.md) | endo docs/errors.md | Errors serialize by copy; comm system can attach identifiers. |

## See also

- [`captp`](captp.md): consumer of marshal for capability transport.
- [`ocapn`](ocapn.md): protocol family that combines marshal with transports.
- [`patterns`](patterns.md): related (shape-matching), distinct (not for transport).
