---
title: Conditional exports (conditions, order, nested, user and community conditions)
source: doc/api/packages.md
source_repo: nodejs/node
source_commit: cc37ad592f347b7ff40c4629956f2278d3ec3451
source_date: 2026-06-23
source_authors: [Joyee Cheung, Geoffrey Booth, Antoine du Hamel]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, module-loader]
status: current
---

Abstract: Conditional exports map to different paths depending on conditions, for both CommonJS and ESM. Node.js implements a fixed set, listed from most-specific to least-specific because **key order is significant**: earlier entries win. The core conditions are `"node-addons"`, `"node"`, `"import"`, `"require"`, `"module-sync"`, and `"default"` (which always matches and must come last). `"import"` and `"require"` are always mutually exclusive and select by how the package was loaded, regardless of the target file's actual format; misusing them is the root of the dual-package hazard. Conditions nest like nested `if` statements: a nested condition object that fails to match continues checking the parent's remaining conditions. User conditions are added with `--conditions=NAME` (repeatable); unknown conditions are ignored by default. The doc also standardizes community conditions (`"types"` first, `"browser"`, `"development"`/`"production"` mutually exclusive) whose definitions live in the docs rather than in Node core.

## The core conditions and their order

A package providing different exports for `require()` and `import`:

```json
{ "exports": { "import": "./index-module.js", "require": "./index-require.cjs" }, "type": "module" }
```

Node.js implements these conditions, most specific to least specific:

- `"node-addons"` - like `"node"`, for a native C++ addon entry point. Can be disabled with `--no-addons`; treat `"default"` as an enhancement (for example WebAssembly).
- `"node"` - any Node.js environment (CommonJS or ESM). Usually not necessary to call out explicitly.
- `"import"` - matches when loaded via `import`/`import()` or any top-level import or resolve by the ESM loader. Applies regardless of the target file's module format. Always mutually exclusive with `"require"`.
- `"require"` - matches when loaded via `require()`. Matches regardless of the target's format; expected formats include CommonJS, JSON, native addons, and ES modules. Always mutually exclusive with `"import"`.
- `"module-sync"` - matches whether loaded via `import`, `import()`, or `require()`. Expected to be ES modules with no top-level await in the graph; a `require()` of an async graph throws `ERR_REQUIRE_ASYNC_MODULE`.
- `"default"` - generic fallback that always matches; can be CommonJS or ESM. Always comes last.

**Within `"exports"`, key order is significant.** During condition matching, earlier entries have higher priority. The general rule: conditions from most specific to least specific in object order. Using `"import"` and `"require"` can lead to the hazards described under the dual CommonJS/ES module packages section.

Conditions extend to subpaths too, so `require('pkg/feature.js')` and `import 'pkg/feature.js'` can provide different implementations. When using environment branches, always include a `"default"` so unknown JS environments get a universal implementation instead of pretending to be an existing environment; prefer `"node"` + `"default"` over `"node"` + `"browser"`.

## Nested conditions

Node supports nested condition objects; conditions are matched in order as with flat conditions. If a nested condition has no matching mapping, matching continues with the parent's remaining conditions, analogous to nested JavaScript `if` statements:

```json
{ "exports": { "node": { "import": "./feature-node.mjs", "require": "./feature-node.cjs" }, "default": "./feature.mjs" } }
```

## Resolving user conditions

Custom conditions are added at runtime with `--conditions=NAME` (repeatable; short flag `-C`), resolved alongside the built-in `node`, `node-addons`, `default`, `import`, and `require`. Typical conditions use only alphanumerics with `:`, `-`, or `=` separators. Node's own restrictions: at least one character; cannot start with `.`; cannot contain `,`; cannot be integer-like keys such as `"10"`.

## Community conditions definitions

Condition strings other than the core set are ignored by default; user conditions must be enabled via `--conditions`/`-C`. Because custom conditions need clear definitions, the Node docs curate a list to aid ecosystem coordination:

- `"types"` - used by typing systems to resolve the typing file for an export. Should always be included first.
- `"browser"` - any web browser environment.
- `"development"` - a development-only entry point (for example better error messages). Always mutually exclusive with `"production"`.
- `"production"` - a production entry point. Always mutually exclusive with `"development"`.

For other runtimes, platform-specific condition keys are maintained by the WinterCG in the Runtime Keys proposal.

Source: [doc/api/packages.md](https://github.com/nodejs/node/blob/cc37ad592f347b7ff40c4629956f2278d3ec3451/doc/api/packages.md) at commit `cc37ad5`.
