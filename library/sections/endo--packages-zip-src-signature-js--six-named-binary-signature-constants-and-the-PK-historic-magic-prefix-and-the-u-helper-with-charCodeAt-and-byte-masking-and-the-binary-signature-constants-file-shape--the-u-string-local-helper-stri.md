---
title: §The `u(string)` local helper — string-to-Uint8Array with explicit byte masking
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

Lines 8-14:
```js
function u(string) {
  const array = new Uint8Array(string.length);
  for (let i = 0; i < string.length; i += 1) {
    array[i] = string.charCodeAt(i) & 0xff;
  }
  return array;
}
```

§The-helper-converts-a-string-to-a-`Uint8Array` byte-by-byte:
1. Allocate a `Uint8Array` of the same length as the string.
2. For each character, take its UTF-16 code unit via `charCodeAt(i)`.
3. Mask to the low byte via `& 0xff`.
4. Store at the corresponding index.

§First-explicit-observation in library: **§the-`charCodeAt(i) & 0xff`-pattern-as-named-defensive-byte-extraction — §the-mask-IS-defensive-against-high-byte-characters + §when-the-string-IS-only-ASCII-and-control-bytes, §the-mask-IS-a-no-op + §when-the-string-contains-non-ASCII, §the-mask-truncates-rather-than-corrupts**.

§Sibling-pattern to many low-level binary-manipulation libraries that use this idiom; §the-`& 0xff`-mask-IS-the-canonical-defensive-truncation.

§The-helper-name-`u` — §single-letter-named-helper for §dense-constant-definition; §the-name-IS-mnemonic ('u' for Uint8Array or "unsigned"); §sibling-pattern to many low-level code conventions where helper-name-IS-shorter-when-used-many-times.

§First-explicit-observation in library: **§single-letter-named-helper-`u`-for-dense-constant-definition — §when-a-helper-IS-used-six-times-in-six-lines, §a-single-letter-name-IS-the-canonical-form + §the-helper-IS-private-to-the-module + §the-readability-comes-from-the-constants-being-named-descriptively-not-from-the-helper-being-verbose**.
