# Topic: marshal

> Abstract: Marshal is endo's pass-style serialization layer. Each value passing through the boundary is classified by pass-style (passable copy types like `copyArray` and `copyRecord`, or `remotable` for capability-bearing references). Smallcaps is the JSON-like wire format; pass-style classifies what can cross the wire. Distinct from `patterns` (which describes shapes for matching, not for transport).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--docs-errors--hiding-revealing-distributed-diagnostic](../sections/endo--docs-errors--hiding-revealing-distributed-diagnostic.md) | endo docs/errors.md | Errors serialize by copy; comm system can attach identifiers. |
| [endo--pkg-marshal-readme--overview](../sections/endo--pkg-marshal-readme--overview.md) | endo packages/marshal/README.md | The marshal package: pass-style serialization + smallcaps wire format. |
| [endo--pkg-marshal-readme--usage](../sections/endo--pkg-marshal-readme--usage.md) | endo packages/marshal/README.md | makeMarshal API: toCapData and fromCapData. |
| [endo--pkg-marshal-readme--frozen-objects-only](../sections/endo--pkg-marshal-readme--frozen-objects-only.md) | endo packages/marshal/README.md | Marshal requires harden()ed values. |
| [endo--pkg-marshal-readme--beyond-json](../sections/endo--pkg-marshal-readme--beyond-json.md) | endo packages/marshal/README.md | Smallcaps wire format extensions beyond JSON. |
| [endo--pkg-marshal-readme--pass-by-presence-vs-copy](../sections/endo--pkg-marshal-readme--pass-by-presence-vs-copy.md) | endo packages/marshal/README.md | Pass-by-copy (data) vs pass-by-presence (capability proxy). |
| [endo--pkg-marshal-readme--convert-val-slot](../sections/endo--pkg-marshal-readme--convert-val-slot.md) | endo packages/marshal/README.md | The slot-to-capability bridge callbacks. |
| [endo--pkg-marshal-readme--alternative-to-json](../sections/endo--pkg-marshal-readme--alternative-to-json.md) | endo packages/marshal/README.md | Marshal as a direct JSON replacement for arbitrary frozen values. |
| [endo--docs-message-passing--introduction](../sections/endo--docs-message-passing--introduction.md) | endo docs/message-passing.md | Message-passing framing: marshal as the pass-style layer. |
| [endo--docs-message-passing--foundation-what-can-be-passed](../sections/endo--docs-message-passing--foundation-what-can-be-passed.md) | endo docs/message-passing.md | What types of values cross a message boundary; pass-style classification. |
| [endo--docs-message-passing--validation-describing-what-you-accept](../sections/endo--docs-message-passing--validation-describing-what-you-accept.md) | endo docs/message-passing.md | Patterns layer between marshal's transport and application logic. |
| [endo--docs-message-passing--digital-purse-example](../sections/endo--docs-message-passing--digital-purse-example.md) | endo docs/message-passing.md | Worked example where marshal serializes passable values across vat boundary. |
| [endo--docs-message-passing--common-pitfalls](../sections/endo--docs-message-passing--common-pitfalls.md) | endo docs/message-passing.md | Forgetting to harden(), passing non-passable values, and other recurring bugs. |

## See also

- [`captp`](captp.md): consumer of marshal for capability transport.
- [`ocapn`](ocapn.md): protocol family that combines marshal with transports.
- [`patterns`](patterns.md): related (shape-matching), distinct (not for transport).
