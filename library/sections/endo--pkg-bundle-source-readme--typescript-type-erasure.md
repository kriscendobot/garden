---
title: TypeScript type erasure
source: packages/bundle-source/README.md
source_repo: endojs/endo
source_commit: 1af1999ec5a7b77f39a1044073ed545ff526c90b
source_date: 2025-08-02
source_authors: [Richard Gibson]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, tooling, typescript-conventions]
status: current
---

> Abstract: How bundle-source strips TypeScript type annotations during bundling. The result is plain JS compatible with the SES runtime.

## TypeScript type erasure

TypeScript modules with the `.ts`, `.mts`, and `.cts` extensions in
packages that are not under a `node_modules` directory are automatically
converted to JavaScript through type erasure using
[`ts-blank-space`](https://bloomberg.github.io/ts-blank-space/).

This will not function for packages that are published as their original
TypeScript sources, as is consistent with `node
--experimental-strip-types`.
This will also not function properly for TypeScript modules that have
[runtime impacting syntax](https://github.com/bloomberg/ts-blank-space/blob/main/docs/unsupported_syntax.md),
such as `enum`.

This also does not support importing a `.ts` file using the corresponding
imaginary, generated module with a `.js` extension.
Use this feature in conjunction with
[`--allowImportingTsExtensions`](https://www.typescriptlang.org/tsconfig/#allowImportingTsExtensions).


Source: [packages/bundle-source/README.md](https://github.com/endojs/endo/blob/1af1999ec5a7b77f39a1044073ed545ff526c90b/packages/bundle-source/README.md) at commit `1af1999e`.
