---
title: "@endo/eventual-send/src/no-shim.js — the no-shim module assuming HandledPromise global is installed"
source-slug: endo--packages-eventual-send-src-no-shim-js
url: https://github.com/endojs/endo/blob/master/packages/eventual-send/src/no-shim.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/eventual-send/src/no-shim.js
total-lines: 23
status: published
ingest-cycle: 254
ingest-date: 2026-06-10
lane: chat
---

# @endo/eventual-send/src/no-shim.js

A 23-line file that captures the platform's already-installed `HandledPromise` global, factories the `E` proxy from it via `makeE(hp)`, and re-exports under the canonical name plus `export *` from `./exports.js`. The counterpart to a shim — when the platform already has the global installed, the no-shim consumes it without installing.

## Key design moves

- **§The no-shim module** as counterpart to the pony-shim — installation responsibility moves to the application.
- **§Four-cycles-with-platform-bridge-discipline** (188 monkey-patch + 242 elevator + 245 pony-shim + 254 no-shim).
- **§Capture the global at module load** — `const hp = HandledPromise;` as snapshot at load time + defense against later global replacement.
- **§XXX comment as named workaround prefix** — distinct from TODO; XXX = known-suboptimal-but-functional.
- **§Three different export styles in one file** — `export const`, `export { local as Public }`, `export * from './module'`.
- **§`export { local as Public }` form** when the module uses a short alias internally but the public API wants the canonical name.
- **§File-level API overview via JSDoc on canonical export**.
- **§makeE(hp) factory** — dependency-injection of the platform substrate.
- **§Shim-vs-no-shim package entrypoints** as named dispatch shape.
- **§The `hp` local name** — two-letter acronym short-alias for `HandledPromise`.

## Section files

- [§the-no-shim-module + §hp-as-alias-of-global + §XXX-comment-as-named-workaround + §three-export-styles](../sections/endo--packages-eventual-send-src-no-shim-js--the-no-shim-module-and-hp-as-alias-of-global-and-XXX-comment-as-named-workaround-and-three-export-styles.md) — full 23-line module ingest.

## Ingest scope

Cycle 254 (chat-lane, after cycle 253's designs-lane): full 23-line module ingest. §Seventh-direct-ingest from `@endo/eventual-send/src/`. §First-explicit-observation of six patterns: §the-no-shim-module-as-counterpart-to-the-pony-shim + §capture-the-global-at-module-load-as-defense-against-later-global-replacement + §XXX-comment-as-named-workaround-prefix-as-distinct-from-TODO + §three-different-export-styles-in-one-file-as-named-shape + §file-level-API-overview-via-JSDoc-on-canonical-export + §shim-vs-no-shim-package-entrypoints-as-named-dispatch-shape.
