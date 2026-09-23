---
title: §The `if (!content) throw Error(...)` validation
source-slug: endo--packages-zip-src-writer-js
section-slug: ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo
source-url: https://github.com/endojs/endo/blob/master/packages/zip/src/writer.js
source-repo: endojs/endo
source-path: packages/zip/src/writer.js
source-author: Endo project (collective)
total-lines: 64
ingest-cycle: 280
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo
---

Lines 30-32:
```js
if (!content) {
  throw Error(`ZipWriter write requires content for ${name}`);
}
```

§First-explicit-observation in library: **§the-`Error(...)`-without-`new`-shorthand — §JS-allows-Error()-as-function-call-not-just-constructor + §the-result-IS-the-same-Error-instance + §the-shorthand-saves-the-`new`-keyword + §sibling-pattern to many @endo/* conventions where Error() IS called without `new`**.

§The-error-message-includes-the-`name`-parameter — §named-context-in-the-error; §the-message-IS-helpful-because-it-names-which-file-was-being-written-when-the-error-fired; §sibling-pattern to many @endo/* conventions for context-rich error messages.

§The-`if (!content)`-truthy-check — §rejects-null-undefined-empty-string-zero-NaN-empty-Uint8Array; §the-zero-byte-Uint8Array-IS-truthy (Uint8Array instances are objects); §the-check-rejects-the-three-falsy-values-that-make-no-sense-for-content (null + undefined + empty string).
