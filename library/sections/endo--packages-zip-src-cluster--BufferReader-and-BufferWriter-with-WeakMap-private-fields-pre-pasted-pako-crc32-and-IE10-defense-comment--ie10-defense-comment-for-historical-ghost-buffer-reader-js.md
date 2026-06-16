---
source: packages/zip/src/{buffer-reader,buffer-writer,crc32,signature,compression,reader,writer}.js + index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/zip/src
source_path: packages/zip/index.js, packages/zip/src/buffer-reader.js, packages/zip/src/buffer-writer.js, packages/zip/src/crc32.js, packages/zip/src/signature.js, packages/zip/src/compression.js, packages/zip/src/reader.js, packages/zip/src/writer.js
section_kind: source
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - bundles
  - tooling
genre: §endo-source-comment-fragment §canonical-byte-format-package
cycle: 191
lane: chat
status: current
title: §IE10-defense-comment-for-historical-ghost (buffer-reader.js)
parent: endo--packages-zip-src-cluster--BufferReader-and-BufferWriter-with-WeakMap-private-fields-pre-pasted-pako-crc32-and-IE10-defense-comment
---

```js
peek(size) {
  const fields = privateFieldsGet(this);
  // Clamp size.
  size = Math.max(0, Math.min(fields.length - fields.index, size));
  if (size === 0) {
    // in IE10, when using subarray(idx, idx), we get the array [0x00] instead of [].
    return new Uint8Array(0);
  }
  // ...
}
```

§The-§IE10-defense-comment names a §historical-ghost: IE10
(released 2012; killed-by-Microsoft 2016) had a bug where
`Uint8Array.subarray(N, N)` returned `[0x00]` instead of an
empty array.

§The-defense: detect size==0 and return `new Uint8Array(0)`
explicitly.

§Why-the-comment-survives: §the-code-handles-a-platform-that-
no-one-supports-anymore. §A-future-contributor-might-be-
tempted-to-remove-the-special-case ("IE10 is dead"). §The-
comment-prevents-that — it names the platform-bug + the
historical-fix + lets the reader decide.

§Compare-to-cycle-181-base64's §legacy-XS-tier (`globalThis
.Base64.encode` for older Moddable/XS builds). §Both-are-
§historical-ghost-supports kept §with-named-rationale-in-
source. §Cycle-181's-XS-tier is still relevant (some Agoric
chains still run those builds); §cycle-191's-IE10-defense is
arguably stale, but the comment-block is the §audit-trail
that lets the next maintainer decide.

§Tier-1-borrowing: §historical-ghost-defense-with-named-
rationale-in-source. §Don't-silently-remove-defenses-for-
dead-platforms; §name-them-and-let-the-next-reader-decide.
