---
title: node16 and nodenext resolution
source: packages/documentation/copy/en/modules-reference/Reference.md
source_repo: microsoft/TypeScript-Website
source_commit: c8170c35bda4811c9516cbb69c39241ae4beb6d9
source_date: 2026-07-06
source_authors: [typescript-automation[bot]]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, typescript-conventions]
status: current
---

> Abstract: `node16` and `nodenext` model Node's dual ESM/CJS resolver: the eventual emitted operation selects `import` or `require` export conditions, ESM imports require explicit relative extensions, and each mode must be paired with a Node-aware `module` setting.

These modes reflect Node 12-and-later behavior. For each specifier, TypeScript determines the importing file's module format and the operation that will be emitted, then resolves with either the `import` or `require` algorithm. Thus an `import` statement in a CommonJS-detected `.ts` file can resolve through the `require` condition; dynamic `import()` always uses the import algorithm. The `verbatimModuleSyntax` option can prohibit source `import` syntax that would become `require`.

Both modes match `types`, `node`, and the operation-specific `import` or `require` conditions in `exports` and `imports`. `node16` and `nodenext` require `module` to be `node16`, `node18`, `node20`, or `nodenext`. Their key Node fidelity difference from bundler resolution is that extensionless relative paths and directory modules work for `require` but not ESM `import`.

Source: [packages/documentation/copy/en/modules-reference/Reference.md](https://github.com/microsoft/TypeScript-Website/blob/c8170c35bda4811c9516cbb69c39241ae4beb6d9/packages/documentation/copy/en/modules-reference/Reference.md) at commit `c8170c35`.
