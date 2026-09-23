---
id: dual-package-hazard
aliases: [dual package hazard, dual-package hazard, dual CommonJS/ES module, dual ESM/CJS, ESM CJS dual publishing, two module instances, singleton duplication]
topics: [package-manifest, module-loader]
---

# dual-package-hazard

The failure mode that arises when a single package ships both a CommonJS build (reached via the `"require"` condition) and an ES module build (reached via the `"import"` condition), and a process reaches the package through both paths. Node then loads **two separate module instances** of the same package. Any package-level state (caches, registries, singletons, symbol registries) then exists twice, and `instanceof` checks against a class exported by one instance fail for objects created by the other. It is called a "hazard" rather than a bug because the manifest is valid and the duplication is silent until state or identity comparison misbehaves at runtime. Mitigations include isolating all stateful internals in one CommonJS module both builds wrap, shipping ESM-only with a synchronous `module-sync` entry that `require()` can load, or shipping CommonJS-only. The hazard is inherent to the `import`/`require` conditions selecting by load method rather than file format (see [[conditional-exports]]).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [node--doc-api-packages--self-referencing-and-dual-package](../sections/node--doc-api-packages--self-referencing-and-dual-package.md) | The dual CommonJS/ES module hazard the `import`/`require` conditions create and its mitigations. |
| [node--doc-api-packages--conditional-exports](../sections/node--doc-api-packages--conditional-exports.md) | The `import` and `require` conditions that select the two builds, and the note that using them "can lead to some hazards". |

## See also

- [[conditional-exports]] - the `import`/`require` conditions that create the hazard.
- [[package-type-field]] - `"type"` and `.cjs`/`.mjs` extensions decide which build a file belongs to.
