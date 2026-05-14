# Topic: patterns

> Abstract: The @endo/patterns language: declarative shape matchers used as method guards in Exo, as data-validation shapes in patterns, and as composition primitives across the Endo ecosystem. Distinct from `marshal` and `pass-style`: patterns describes shapes for matching, not for transport. The M.* namespace is the canonical syntactic surface (M.string(), M.recordOf(), M.callWhen(), etc.).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--pkg-exo-readme--async-methods-callwhen](../sections/endo--pkg-exo-readme--async-methods-callwhen.md) | endo packages/exo/README.md | M.callWhen() lets a method declare arg shapes against resolved values rather than promises. |
| [endo--pkg-exo-readme--introspection-interface-guard](../sections/endo--pkg-exo-readme--introspection-interface-guard.md) | endo packages/exo/README.md | GET_INTERFACE_GUARD returns an exo's methodsGuard pattern for introspection. |
| [endo--pkg-patterns-readme--overview](../sections/endo--pkg-patterns-readme--overview.md) | endo packages/patterns/README.md | The patterns package frame: M namespace, shape-matching for passable values. |
| [endo--pkg-patterns-readme--quick-start](../sections/endo--pkg-patterns-readme--quick-start.md) | endo packages/patterns/README.md | Minimal usage: import M, build patterns, validate with matches/mustMatch. |
| [endo--pkg-patterns-readme--m-namespace](../sections/endo--pkg-patterns-readme--m-namespace.md) | endo packages/patterns/README.md | The M.* pattern constructors: primitive, container, structured, logical, comparison, special. |
| [endo--pkg-patterns-readme--pattern-matching](../sections/endo--pkg-patterns-readme--pattern-matching.md) | endo packages/patterns/README.md | matches() (boolean) and mustMatch() (throwing) entry points. |
| [endo--pkg-patterns-readme--copy-collections](../sections/endo--pkg-patterns-readme--copy-collections.md) | endo packages/patterns/README.md | CopySet, CopyBag, CopyMap data types with consistent cross-realm ordering. |
| [endo--pkg-patterns-readme--interface-guards](../sections/endo--pkg-patterns-readme--interface-guards.md) | endo packages/patterns/README.md | Interface guards: methodsGuard structure used by Exo. |
| [endo--pkg-patterns-readme--key-comparison](../sections/endo--pkg-patterns-readme--key-comparison.md) | endo packages/patterns/README.md | keyEQ and compareKeys for total-order key comparison. |
| [endo--pkg-patterns-readme--key-pattern-passable-hierarchy](../sections/endo--pkg-patterns-readme--key-pattern-passable-hierarchy.md) | endo packages/patterns/README.md | The Key < Pattern < Passable inclusion hierarchy. |
| [endo--pkg-patterns-readme--integration-with-endo](../sections/endo--pkg-patterns-readme--integration-with-endo.md) | endo packages/patterns/README.md | How patterns relates to pass-style, marshal, exo, captp. |
| [endo--pkg-patterns-readme--deep-dives](../sections/endo--pkg-patterns-readme--deep-dives.md) | endo packages/patterns/README.md | Pointer to packages/patterns/docs/marshal-vs-patterns-level.md. |
| [endo--docs-message-passing--validation-describing-what-you-accept](../sections/endo--docs-message-passing--validation-describing-what-you-accept.md) | endo docs/message-passing.md | Tutorial use of M.* matchers for receiver validation. |
| [endo--docs-message-passing--defensive-receive-protected-objects](../sections/endo--docs-message-passing--defensive-receive-protected-objects.md) | endo docs/message-passing.md | Method guards in defensive-receive patterns. |
| [endo--docs-message-passing--design-patterns-and-best-practices](../sections/endo--docs-message-passing--design-patterns-and-best-practices.md) | endo docs/message-passing.md | Idioms for using pattern guards in capability-bearing code. |
| [endo--docs-message-passing--common-pitfalls](../sections/endo--docs-message-passing--common-pitfalls.md) | endo docs/message-passing.md | Pattern-mismatch bugs in method guards. |

## See also

- [`exo`](exo.md): exo's method guards are written in the patterns language.
- [`marshal`](marshal.md), [`pass-style`](pass-style.md): adjacent (shape vs serialization), distinct.
