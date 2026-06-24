---
title: Single most structurally interesting move
section-slug: endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API
source-slug: endo--packages-zip-src-buffer-writer-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/buffer-writer.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/buffer-writer.js
total-lines: 188
ingest-cycle: 290
ingest-date: 2026-06-11
lane: chat
scope: full
parent: endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API
---

**§the-named-shell-and-state shape with §the-`getPrivateFields(this)`-bridge** — every public method on `BufferWriter` IS a thin wrapper that:

1. Calls `getPrivateFields(this)` to get the private state.
2. Mutates that state in some named way.
3. Updates the watermark via `Math.max(fields.index, fields.length)`.

The WeakMap IS the state-storage; the class IS the API-surface; `getPrivateFields(this)` IS the named bridge between them. **§the-class-IS-a-named-protocol-not-a-data-container** — the state lives off-instance (in the WeakMap), and the instance IS just the *capability handle* for accessing that state.

This pattern predates ECMAScript's `#`-prefix private fields by years, and it has a property that `#`-fields don't: **the private state IS not even on the instance's own structural form**, so any code that observes the instance (e.g., via `Object.getOwnPropertyNames` or `Object.entries`) sees nothing private. The instance IS truly opaque from a structural-inspection standpoint.

§the-WeakMap-private-fields-IS-structurally-opaque, not just access-restricted. The named pattern still has currency despite `#`-fields being available; `#`-fields are *enforced-at-the-syntax-level* and bind to the lexical class; the WeakMap pattern IS *enforced-at-the-runtime-level* and survives lexical operations like `class.prototype` introspection.
