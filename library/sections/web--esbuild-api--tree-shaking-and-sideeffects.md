---
title: esbuild tree shaking and the sideEffects field
source_kind: web
source_url: https://esbuild.github.io/api/
source_content_sha256: 2c986ac415f99cc403a5af6de4962ef94d76daba20f7b560dec3edfd6b563dfc
source_fetched_via: direct
source_date: 2026-07-17
source_authors: [Evan Wallace]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest]
status: current
---

> Abstract: esbuild performs declaration-level dead-code removal on ESM imports automatically, and additionally respects two side-effect annotations: inline `/* @__PURE__ */` comments and the `package.json` `sideEffects` field (a webpack convention). `sideEffects: false` lets esbuild drop a package's unused imported files entirely; esbuild honors it for any imported file. `--ignore-annotations` disables both annotations while keeping automatic unused-import removal.

esbuild's tree shaking is declaration-level dead-code elimination that relies on ECMAScript module `import`/`export` syntax: unused functions and unused imports are discarded automatically. Its automatic side-effect detection is conservative — only clearly-pure expressions (primitive literals, plain object literals of pure values) are removable; string concatenation, member access, and even a bare global reference are treated as potential side effects (a getter or a `ReferenceError` could run).

Beyond automatic detection, esbuild respects two author annotations:

- **`/* @__PURE__ */`** comments before a call tell esbuild the call may be removed if its result is unused (see the `pure` API option).
- **The `sideEffects` field in `package.json`** — the webpack convention — tells esbuild which files in a package can be removed when all imports from them are unused. `"sideEffects": false` marks the whole package pure, so esbuild will drop bare imports whose file contributes nothing used (it even emits an `ignored-bare-import` warning showing the `"sideEffects": false` line responsible). esbuild respects this for *any* imported file, not just injected ones; the documented pattern for a conditionally-injected file is to put it in a package with `"sideEffects": false`.

esbuild notes the `sideEffects` field is error-prone: because `false` makes every file in the package a dead-code candidate, adding a new side-effectful file and forgetting to list it silently drops it. The `--ignore-annotations` flag makes esbuild stop respecting both `/* @__PURE__ */` and `sideEffects` (a temporary workaround for packages with wrong annotations) while still tree-shaking genuinely-unused imports.

Source: [esbuild API documentation](https://esbuild.github.io/api/) fetched 2026-07-17 (content sha256 `2c986ac`), section *Tree shaking*.
