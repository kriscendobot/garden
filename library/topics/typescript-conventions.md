# Topic: typescript-conventions

> Abstract: How TypeScript is used in a repository where runtime code is `.js` but type definitions and consumer-facing typings are `.ts` and `.d.ts`. Covers the `types-index.js` + `types-index.d.ts` pair convention, the `emitDeclarationOnly` posture, JSDoc `@import` for type-only imports in `.js`, and where different categories of type definitions belong.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [endo--agents--typescript-usage](../sections/endo--agents--typescript-usage.md) | endo AGENTS.md | Six sub-rules: no `.ts` runtime; `.ts` for types; `types-index` pair; placement rules; `emitDeclarationOnly`; `@import` JSDoc. |
| [endo--agents--exo-this-context](../sections/endo--agents--exo-this-context.md) | endo AGENTS.md | `ThisType<>` annotations for Exo single-facet vs multi-facet methods. |
| [endo--pkg-bundle-source-readme--typescript-type-erasure](../sections/endo--pkg-bundle-source-readme--typescript-type-erasure.md) | endo packages/bundle-source/README.md | TS type-erasure pipeline as bundle-source's TS handling. |
| [endo--pkg-exo-docs-types--overview](../sections/endo--pkg-exo-docs-types--overview.md) | endo packages/exo/docs/types.md | TS types for the Exo API surface. |
| [agoric-sdk--docs-typescript--overview](../sections/agoric-sdk--docs-typescript--overview.md) | agoric-sdk docs/typescript.md | agoric-sdk's frame for TS in JS-runtime + TS-consumer monorepo. |
| [agoric-sdk--docs-typescript--build](../sections/agoric-sdk--docs-typescript--build.md) | agoric-sdk docs/typescript.md | TS build configuration: emitDeclarationOnly, allowJs, project references. |
| [agoric-sdk--docs-typescript--best-practices](../sections/agoric-sdk--docs-typescript--best-practices.md) | agoric-sdk docs/typescript.md | agoric-sdk-specific TS best practices. |
| [agoric-sdk--docs-typescript--entrypoint](../sections/agoric-sdk--docs-typescript--entrypoint.md) | agoric-sdk docs/typescript.md | Entrypoint conventions for TS-consumed packages. |
| [agoric-sdk--docs-typescript--ts-modules](../sections/agoric-sdk--docs-typescript--ts-modules.md) | agoric-sdk docs/typescript.md | When and how to author `.ts` modules in agoric-sdk. |
| [agoric-sdk--docs-typescript--dts-modules](../sections/agoric-sdk--docs-typescript--dts-modules.md) | agoric-sdk docs/typescript.md | `.d.ts` modules: when to author them by hand vs emit. |
| [agoric-sdk--docs-typescript--api-docs](../sections/agoric-sdk--docs-typescript--api-docs.md) | agoric-sdk docs/typescript.md | TS-derived API docs in agoric-sdk. |
| [agoric-sdk--agents--coding-style-and-naming-conventions](../sections/agoric-sdk--agents--coding-style-and-naming-conventions.md) | agoric-sdk AGENTS.md | ESM + TS targeting Node ^20.9/^22.11; dprint enforced; `@agoric/*` vs `@aglocal/*`. |

## See also

- [`agent-conventions`](agent-conventions.md): broader agent rules including TS.
- [`exo`](exo.md): the API whose `this` shapes drive the TS annotations.
