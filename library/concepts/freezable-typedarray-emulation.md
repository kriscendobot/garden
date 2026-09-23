---
id: freezable-typedarray-emulation
aliases: [freezable TypedArray emulation, emulated TypedArray, emulated DataView]
topics: [hardened-javascript, pass-style]
---

# freezable-typedarray-emulation

An implementation strategy for presenting ordinary, freezable TypedArray and DataView wrappers over immutable ArrayBuffer storage while delegating reads to hidden genuine views. The archived design is unreviewed reference material, not an approved specification.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [semantics](../sections/endo-but-for-bots--packages-immutable-arraybuffer-designs-freezable-typedarray--semantics.md) | Defines wrapper behavior for mutation, freezing, buffer identity, and tags. |
| [implementation-outline](../sections/endo-but-for-bots--packages-immutable-arraybuffer-designs-freezable-typedarray--implementation-outline.md) | Sketches the hidden-view delegation and shim integration. |

## See also

- [[typedarray-hardening]] - hardening behavior for genuine integer-indexed TypedArrays.
