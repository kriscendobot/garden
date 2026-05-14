# Topic: patterns

> Abstract: The @endo/patterns language: declarative shape matchers used as method guards in Exo, as data-validation shapes in patterns, and as composition primitives across the Endo ecosystem. Distinct from `marshal` and `pass-style`: patterns describes shapes for matching, not for transport. The M.* namespace is the canonical syntactic surface (M.string(), M.recordOf(), M.callWhen(), etc.).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--pkg-exo-readme--async-methods-callwhen](../sections/endo--pkg-exo-readme--async-methods-callwhen.md) | endo packages/exo/README.md | M.callWhen() lets a method declare arg shapes against resolved values rather than promises. |
| [endo--pkg-exo-readme--introspection-interface-guard](../sections/endo--pkg-exo-readme--introspection-interface-guard.md) | endo packages/exo/README.md | GET_INTERFACE_GUARD returns an exo's methodsGuard pattern for introspection. |

## See also

- [`exo`](exo.md): exo's method guards are written in the patterns language.
- [`marshal`](marshal.md), [`pass-style`](pass-style.md): adjacent (shape vs serialization), distinct.
