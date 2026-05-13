# Topic: exo

> Abstract: Exo (Exposed Object) is endo's class API for defining remotable objects (Far-like) with declarative method guards (patterns) and per-instance state. Three forms: `makeExo` (no state, single facet), `defineExoClass` (state via `init()`, single facet), `defineExoClassKit` (state via `init()`, multiple facets sharing the cohort).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--agents--exo-this-context](../sections/endo--agents--exo-this-context.md) | endo AGENTS.md | `this.self` vs `this.facets`; never mix `self` and `facets` in one `ThisType<>`. |

## See also

- [`patterns`](patterns.md): the method-guard pattern language used in Exo declarations.
- [`marshal`](marshal.md): the pass-style system Exo's remotables flow through.
- [`capability-security`](capability-security.md): why exo's encapsulation matters.
