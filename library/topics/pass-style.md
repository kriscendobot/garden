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
| [endo--pkg-pass-style-readme--overview](../sections/endo--pkg-pass-style-readme--overview.md) | endo packages/pass-style/README.md | The @endo/pass-style package frame: type discipline marshal uses. |
| [endo--pkg-pass-style-readme--pass-styles](../sections/endo--pkg-pass-style-readme--pass-styles.md) | endo packages/pass-style/README.md | Enumeration of pass styles: primitive, container, error, promise, remotable. |
| [endo--pkg-pass-style-readme--passstyleof](../sections/endo--pkg-pass-style-readme--passstyleof.md) | endo packages/pass-style/README.md | passStyleOf(value): returns the pass-style or throws. |
| [endo--pkg-pass-style-readme--ispassable](../sections/endo--pkg-pass-style-readme--ispassable.md) | endo packages/pass-style/README.md | isPassable(value): non-throwing variant of passStyleOf. |
| [endo--pkg-pass-style-readme--far](../sections/endo--pkg-pass-style-readme--far.md) | endo packages/pass-style/README.md | Far(iface, methods): construct a remotable. |
| [endo--pkg-pass-style-readme--maketagged](../sections/endo--pkg-pass-style-readme--maketagged.md) | endo packages/pass-style/README.md | makeTagged(tag, payload): construct a tagged value. |
| [endo--pkg-pass-style-readme--passable-values](../sections/endo--pkg-pass-style-readme--passable-values.md) | endo packages/pass-style/README.md | Which JS values are passable and which are not. |
| [endo--pkg-pass-style-readme--pass-by-copy-vs-presence](../sections/endo--pkg-pass-style-readme--pass-by-copy-vs-presence.md) | endo packages/pass-style/README.md | The high-level pass-by-copy vs pass-by-presence distinction. |
| [endo--pkg-pass-style-readme--type-guards](../sections/endo--pkg-pass-style-readme--type-guards.md) | endo packages/pass-style/README.md | TypeScript type guards: passable, pure-data variants. |
| [endo--pkg-pass-style-readme--integration-with-endo](../sections/endo--pkg-pass-style-readme--integration-with-endo.md) | endo packages/pass-style/README.md | How pass-style relates to other Endo packages. |
| [endo--pkg-pass-style-readme--deep-dives](../sections/endo--pkg-pass-style-readme--deep-dives.md) | endo packages/pass-style/README.md | Pointers to deeper doc/ subdirectory: copyArray-guarantees, copyRecord-guarantees, etc. |
| [endo--pkg-patterns-readme--copy-collections](../sections/endo--pkg-patterns-readme--copy-collections.md) | endo packages/patterns/README.md | CopySet, CopyBag, CopyMap are taggeds built atop pass-style primitives. |
| [endo--pkg-patterns-readme--key-pattern-passable-hierarchy](../sections/endo--pkg-patterns-readme--key-pattern-passable-hierarchy.md) | endo packages/patterns/README.md | The Key/Pattern/Passable inclusion hierarchy. |
| [endo--docs-message-passing--foundation-what-can-be-passed](../sections/endo--docs-message-passing--foundation-what-can-be-passed.md) | endo docs/message-passing.md | Tutorial-paced coverage of the pass-style classification. |
| [endo--pkg-marshal-docs-smallcaps-cheatsheet--overview](../sections/endo--pkg-marshal-docs-smallcaps-cheatsheet--overview.md) | endo packages/marshal/docs/smallcaps-cheatsheet.md | Quick-reference card for smallcaps encodings. |
| [endo--pkg-pass-style-doc-copyarray-guarantees--overview](../sections/endo--pkg-pass-style-doc-copyarray-guarantees--overview.md) | endo packages/pass-style/doc/copyArray-guarantees.md | copyArray invariants: dense, frozen, no-extra-props. |
| [endo--pkg-pass-style-doc-copyrecord-guarantees--overview](../sections/endo--pkg-pass-style-doc-copyrecord-guarantees--overview.md) | endo packages/pass-style/doc/copyRecord-guarantees.md | copyRecord invariants: own-props-only, string-keyed, frozen. |
| [endo--pkg-pass-style-doc-enumerating-properties--overview](../sections/endo--pkg-pass-style-doc-enumerating-properties--overview.md) | endo packages/pass-style/doc/enumerating-properties.md | Property enumeration semantics in pass-style. |
| [endo--pkg-patterns-docs-marshal-vs-patterns-level--overview](../sections/endo--pkg-patterns-docs-marshal-vs-patterns-level--overview.md) | endo packages/patterns/docs/marshal-vs-patterns-level.md | Two-level type system: pass-style (transport) vs kindOf (shape). |
| [endo--pkg-patterns-docs-marshal-vs-patterns-level--ocapn-vs-passstyleof-vs-typeof](../sections/endo--pkg-patterns-docs-marshal-vs-patterns-level--ocapn-vs-passstyleof-vs-typeof.md) | endo packages/patterns/docs/marshal-vs-patterns-level.md | Three abstraction levels: typeof / passStyleOf / OCapN kinds. |
| [endo--pkg-patterns-docs-marshal-vs-patterns-level--kindof-vs-passstyleof](../sections/endo--pkg-patterns-docs-marshal-vs-patterns-level--kindof-vs-passstyleof.md) | endo packages/patterns/docs/marshal-vs-patterns-level.md | kindOf adds finer classification on top of passStyleOf. |

## See also

- [`marshal`](marshal.md): the package implementing pass-style serialization (same surface).
- [`captp`](captp.md): consumer of marshal for capability transport.
- [`capability-security`](capability-security.md): why the pass-by-presence/copy distinction matters for ocap discipline.
