# Topic: typescript-conventions

> Abstract: How TypeScript is used in a repository where runtime code is `.js` but type definitions and consumer-facing typings are `.ts` and `.d.ts`. Covers the `types-index.js` + `types-index.d.ts` pair convention, the `emitDeclarationOnly` posture, JSDoc `@import` for type-only imports in `.js`, and where different categories of type definitions belong.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--agents--typescript-usage](../sections/endo--agents--typescript-usage.md) | endo AGENTS.md | Six sub-rules: no `.ts` runtime; `.ts` for types; `types-index` pair; placement rules; `emitDeclarationOnly`; `@import` JSDoc. |
| [endo--agents--exo-this-context](../sections/endo--agents--exo-this-context.md) | endo AGENTS.md | `ThisType<>` annotations for Exo single-facet vs multi-facet methods. |

## See also

- [`agent-conventions`](agent-conventions.md): broader agent rules including TS.
- [`exo`](exo.md): the API whose `this` shapes drive the TS annotations.
