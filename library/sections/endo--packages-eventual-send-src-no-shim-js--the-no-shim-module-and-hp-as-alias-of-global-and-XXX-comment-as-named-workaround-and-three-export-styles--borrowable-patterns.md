---
title: §Borrowable patterns
source-slug: endo--packages-eventual-send-src-no-shim-js
source-url: https://github.com/endojs/endo/blob/master/packages/eventual-send/src/no-shim.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/eventual-send/src/no-shim.js
total-lines: 23
ingest-cycle: 254
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-eventual-send-src-no-shim-js--the-no-shim-module-and-hp-as-alias-of-global-and-XXX-comment-as-named-workaround-and-three-export-styles
---

**Tier-1 (highest borrowing value):**

- §The no-shim module as counterpart to the pony-shim — installation responsibility moves to the application.
- §Capture the global at module load — `const hp = HandledPromise;` as snapshot at load time + defense against later global replacement.
- §XXX comment as named workaround prefix — distinct from TODO; XXX = known-suboptimal-but-functional.
- §Three different export styles in one file — `export const`, `export { local as Public }`, `export * from './module'`.
- §`export { local as Public }` form when a module uses a short alias internally but the public API wants the canonical name.
- §File-level API overview via JSDoc on canonical export.
- §makeE(hp) factory — dependency-injection of the platform substrate.
- §Shim-vs-no-shim package entrypoints as named dispatch shape.

**Tier-2 (named comparisons):**

- §Four-cycles-with-platform-bridge-discipline (188 monkey-patch + 242 elevator + 245 pony-shim + 254 no-shim).
- §Three-cycles-with-short-alias-convention-for-long-canonical-name (237 `q` + 245 `optXferBuf2Immu` + 254 `hp`).
- §Three-cycles-with-platform-power-as-factory-argument (242 + 245 + 254).
- §Two-cycles-with-`as`-rename-in-module-boundary (245 import-rename + 254 export-rename).
- §Two-cycles-with-named-eslint-disable-acknowledging-known-conflict (245 + 254).

**Tier-3 (file-shape patterns):**

- §Twenty-three-lines-as-a-complete-no-shim-module.
- §The-JSDoc-IS-the-file's-API-reference (file-level overview attached to canonical export).
