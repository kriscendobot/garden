---
title: §The 'PK' historic magic prefix — Phil Katz as the named source
source-slug: endo--packages-zip-src-signature-js
section-slug: six-named-binary-signature-constants-and-the-PK-historic-magic-prefix-and-the-u-helper-with-charCodeAt-and-byte-masking-and-the-binary-signature-constants-file-shape
source-url: https://github.com/endojs/endo/blob/master/packages/zip/src/signature.js
source-repo: endojs/endo
source-path: packages/zip/src/signature.js
source-author: Endo project (collective)
total-lines: 22
ingest-cycle: 278
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-zip-src-signature-js--six-named-binary-signature-constants-and-the-PK-historic-magic-prefix-and-the-u-helper-with-charCodeAt-and-byte-masking-and-the-binary-signature-constants-file-shape
---

All six signatures start with the two ASCII bytes `'PK'` — Phil Katz's initials, the inventor of the ZIP format in 1989:

```js
export const LOCAL_FILE_HEADER = u('PK\x03\x04');
export const CENTRAL_FILE_HEADER = u('PK\x01\x02');
export const CENTRAL_DIRECTORY_END = u('PK\x05\x06');
export const ZIP64_CENTRAL_DIRECTORY_LOCATOR = u('PK\x06\x07');
export const ZIP64_CENTRAL_DIRECTORY_END = u('PK\x06\x06');
export const DATA_DESCRIPTOR = u('PK\x07\x08');
```

§First-explicit-observation in library: **§the-`PK`-historic-magic-prefix-as-named-format-vocabulary — §every-ZIP-section-starts-with-`PK` + §the-name-IS-the-inventor's-initials (Phil Katz, PKZIP author) + §the-format-vocabulary-IS-historic + §sibling-pattern to many file-format magic bytes (`%PDF-`, `\x89PNG\r\n`, `GIF89a`)**.

§The-format-magic-prefix-IS-vocabulary-not-just-bytes — §the-bytes-IS-the-named-anchor + §the-historic-name-IS-the-cultural-anchor + §the-two-coexist-in-one-prefix.

§Six-section-types-named:
1. **`LOCAL_FILE_HEADER`** = `PK\x03\x04` — start of a file entry.
2. **`CENTRAL_FILE_HEADER`** = `PK\x01\x02` — central directory entry.
3. **`CENTRAL_DIRECTORY_END`** = `PK\x05\x06` — end-of-central-directory record.
4. **`ZIP64_CENTRAL_DIRECTORY_LOCATOR`** = `PK\x06\x07` — ZIP64 locator (extended format).
5. **`ZIP64_CENTRAL_DIRECTORY_END`** = `PK\x06\x06` — ZIP64 end record.
6. **`DATA_DESCRIPTOR`** = `PK\x07\x08` — optional data descriptor.

§Two-cycles-with-ZIP64-naming-convention (zip-related work in cycle 275 didn't enumerate signatures; cycle 278 IS the first to enumerate them); §the-`ZIP64_`-prefix-IS-the-extended-format-marker; §three-ZIP64-variants of-three-base-variants (`ZIP64_CENTRAL_DIRECTORY_END` + `ZIP64_CENTRAL_DIRECTORY_LOCATOR` are extensions of `CENTRAL_DIRECTORY_END`).

§First-explicit-observation in library: **§the-`ZIP64_`-prefix-as-named-extended-format-marker-in-binary-signature-constants**.
