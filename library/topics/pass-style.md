# Topic: pass-style

> Abstract: Pass-style is the classification system marshal uses to decide how each JavaScript value crosses a serialization boundary. The pass-styles include the pass-by-copy types (copyArray, copyRecord, primitive, error) and the pass-by-presence type (remotable, used for capability-bearing objects). The classification is independent of the wire format itself (smallcaps) and serves as marshal's type discipline.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--pkg-marshal-readme--overview](../sections/endo--pkg-marshal-readme--overview.md) | endo packages/marshal/README.md | Marshal is the pass-style serialization layer; smallcaps wire format. |
| [endo--pkg-marshal-readme--usage](../sections/endo--pkg-marshal-readme--usage.md) | endo packages/marshal/README.md | The makeMarshal API: toCapData, fromCapData, callbacks. |
| [endo--pkg-marshal-readme--frozen-objects-only](../sections/endo--pkg-marshal-readme--frozen-objects-only.md) | endo packages/marshal/README.md | Marshal requires harden()ed values; refuses unfrozen objects. |
| [endo--pkg-marshal-readme--beyond-json](../sections/endo--pkg-marshal-readme--beyond-json.md) | endo packages/marshal/README.md | Smallcaps extensions beyond JSON: undefined, NaN, BigInt, Symbol, Error, capability refs. |
| [endo--pkg-marshal-readme--pass-by-presence-vs-copy](../sections/endo--pkg-marshal-readme--pass-by-presence-vs-copy.md) | endo packages/marshal/README.md | Distinguishing pass-by-copy (data) from pass-by-presence (capability proxy). |
| [endo--pkg-marshal-readme--convert-val-slot](../sections/endo--pkg-marshal-readme--convert-val-slot.md) | endo packages/marshal/README.md | The application-supplied callbacks that bridge slot indexes to capability identity. |
| [endo--pkg-marshal-readme--alternative-to-json](../sections/endo--pkg-marshal-readme--alternative-to-json.md) | endo packages/marshal/README.md | Marshal as a direct JSON replacement for arbitrary frozen values. |

## See also

- [`marshal`](marshal.md): the package implementing pass-style serialization (same surface).
- [`captp`](captp.md): consumer of marshal for capability transport.
- [`capability-security`](capability-security.md): why the pass-by-presence/copy distinction matters for ocap discipline.
