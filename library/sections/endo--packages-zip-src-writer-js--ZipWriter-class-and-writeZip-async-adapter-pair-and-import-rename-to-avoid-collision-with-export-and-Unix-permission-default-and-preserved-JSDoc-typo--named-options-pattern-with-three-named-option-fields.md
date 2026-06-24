---
title: §Named options pattern with three named option fields
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

Lines 28-29:
```js
write(name, content, options = {}) {
  const { mode = 0o644, date = undefined, comment = '' } = options;
```

§Three-named-options-with-named-defaults:
- **`mode = 0o644`** — Unix-style file-permission default.
- **`date = undefined`** — explicit undefined-as-default.
- **`comment = ''`** — empty-string-as-default.

§First-explicit-observation in library: **§the-`0o644`-permission-default-as-named-Unix-convention — §`0o644`-IS-`-rw-r--r--`-(owner-read-write-+-group-read-+-other-read) + §the-default-IS-the-canonical-Unix-file-permission-for-non-executable-content + §the-zip-format-honors-the-Unix-permission-model**.

§Sibling-pattern to many Unix-aware libraries (tar + chmod + mkdir); §the-`0o644`-IS-the-named-canonical-default-for-regular-files; §the-discipline-IS-explicit-permission-defaults-in-the-options-object.

§The-`date = undefined`-explicit-undefined-as-default — §the-default-IS-explicit-undefined-not-omitted; §sibling-pattern to functional-programming conventions where the default IS named even when it IS the absence; §first-explicit-observation in library of §the-explicit-undefined-as-default-pattern-when-the-absence-IS-meaningful.
