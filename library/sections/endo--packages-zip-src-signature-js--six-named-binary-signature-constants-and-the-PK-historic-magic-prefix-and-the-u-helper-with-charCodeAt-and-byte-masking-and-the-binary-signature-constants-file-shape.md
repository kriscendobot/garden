---
title: "@endo/zip/src/signature.js — six named binary signature constants + the 'PK' historic magic prefix + the u() helper with charCodeAt and byte masking + the binary-signature-constants file shape"
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
---

# `@endo/zip/src/signature.js` — six named ZIP binary-signature constants with the historic 'PK' magic prefix

A 22-line file that exports **six binary-signature constants** representing the ZIP file format's section markers. Each constant is a `Uint8Array` produced by a local `u(string)` helper. **The smallest file ingested that exports six named constants.**

§First-explicit-observation in library: **§the-binary-signature-constants-file-shape — §a-file-whose-sole-purpose-IS-exporting-binary-constants-with-descriptive-names + §the-shape-IS-canonical-for-format-parsers + §the-cluster-has-a-named-file-shape-for-format-magic-bytes**.

## §The 'PK' historic magic prefix — Phil Katz as the named source

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

## §The `u(string)` local helper — string-to-Uint8Array with explicit byte masking

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

## §The `/* eslint no-bitwise: ["off"] */` directive — named ESLint disable for bitwise

Line 2: `/* eslint no-bitwise: ["off"] */` — disables the project's `no-bitwise` ESLint rule for this file.

§First-explicit-observation in library: **§the-`no-bitwise: ["off"]`-ESLint-directive-as-named-acknowledgment — §the-project-defaults-to-no-bitwise-because-bitwise-IS-rarely-the-right-tool + §when-binary-format-parsing-needs-bitwise, §the-file-explicitly-opts-out + §the-directive-IS-the-named-acknowledgment-of-the-exception**.

§Four-cycles-with-named-eslint-directive-as-acknowledged-platform-binding-or-bitwise (245 panic + 254 no-shim + 276 source-map-node + 278 zip-signature); §the-discipline-IS-now-canonical-across-four-cycles.

§First-explicit-observation in library: **§four-cycles-with-named-eslint-directive-as-acknowledged-exception (245 + 254 + 276 + 278)** — the-`no-bitwise`-IS-the-fourth-named-rule-disabled-explicitly-in-the-cluster (after `no-unused-vars`-style cycles 245 + 254 and `global process` cycle 276).

## §The `/* eslint ... ["off"] */` shape vs `// eslint-disable-next-line`

The cycle 278 directive `/* eslint no-bitwise: ["off"] */` is a **file-scope** disable, distinct from cycle 245's **line-scope** `// eslint-disable-next-line` shape:

- **File-scope** (cycle 278): `/* eslint no-bitwise: ["off"] */` at the top of the file disables the rule for the whole file.
- **Line-scope** (cycle 245): `// eslint-disable-next-line ...` disables the rule for the next line only.

§First-explicit-observation in library: **§two-named-ESLint-disable-shapes (file-scope + line-scope) — §the-file-scope-shape-IS-used-when-the-rule-IS-violated-throughout-the-file (e.g., bitwise in a binary-parser) + §the-line-scope-shape-IS-used-when-the-rule-IS-violated-at-one-line + §the-choice-IS-the-named-discipline**.

## §The `// @ts-check` directive — the canonical typescript-check-enable

Line 1: `// @ts-check` — opt-in to TypeScript checking of this JavaScript file.

§The-`// @ts-check`-directive-IS-canonical-across-the-cluster; §the-CLAUDE.md-spec (per cycle 273's read-through of the project-CLAUDE.md) IS that every JS file should start with this directive; §the-directive-IS-the-named-opt-in-to-type-checking.

§Sibling-pattern to cycle 273's note on the project CLAUDE.md's "Every `.js` source file must start with `// @ts-check`" discipline.

## §Cycle 278 first-explicit-observations roundup (eight)

1. **§the-binary-signature-constants-file-shape** — a file whose sole purpose IS exporting binary constants.
2. **§the-`PK`-historic-magic-prefix-as-named-format-vocabulary** — the inventor's initials as the magic prefix.
3. **§the-`ZIP64_`-prefix-as-named-extended-format-marker-in-binary-signature-constants**.
4. **§the-`charCodeAt(i) & 0xff`-pattern-as-named-defensive-byte-extraction**.
5. **§single-letter-named-helper-`u`-for-dense-constant-definition**.
6. **§the-`no-bitwise: ["off"]`-ESLint-directive-as-named-acknowledgment**.
7. **§four-cycles-with-named-eslint-directive-as-acknowledged-exception** (245 + 254 + 276 + 278).
8. **§two-named-ESLint-disable-shapes** (file-scope + line-scope).

## §Recurring meta-pattern counters bumped at cycle 278

- §**four-cycles-with-named-eslint-directive-as-acknowledged-exception** (245 panic + 254 no-shim + 276 source-map-node + 278 zip-signature).
- §**one-hundred-and-eleventh consecutive designs-chat alternation cycles 166-250 + 252-278** (251 was out-of-band).

## §Synthesis target — slot machine library

§The-binary-signature-constants-file-shape applies to the §game-engine-cluster:

- §**`@game/replay/src/signature.js`** — a file whose sole purpose is exporting binary-signature constants for the game-replay-file-format.
- §**§game-format-magic-prefix** — e.g., `'GS'` for "GameState" — the project-or-inventor's initials as the magic prefix.
- §**§the-`charCodeAt(i) & 0xff`-pattern** — same string-to-Uint8Array conversion idiom for game-format magic bytes.
- §**§single-letter-named-helper** — `u` (or similar) for dense constant definition when used six+ times in a small file.
- §**§the-`/* eslint no-bitwise: ["off"] */`-directive** for files where bitwise IS the right tool.
- §**§named extended-format markers** — `GAME2_*` prefix for extended game-format constants (sibling to ZIP64).

## §Tier-1 borrowing

§the-binary-signature-constants-file-shape + §the-`PK`-historic-magic-prefix-as-named-format-vocabulary + §the-`ZIP64_`-prefix-as-named-extended-format-marker + §the-`charCodeAt(i) & 0xff`-pattern-as-named-defensive-byte-extraction + §single-letter-named-helper-`u`-for-dense-constant-definition + §the-`no-bitwise: ["off"]`-ESLint-directive-as-named-acknowledgment + §two-named-ESLint-disable-shapes (file-scope + line-scope).

## §Tier-2 borrowing

§the-`// @ts-check`-directive-IS-canonical-across-the-cluster + §the-format-magic-prefix-IS-vocabulary-not-just-bytes.

## §Tier-3 borrowing

§four-cycles-with-named-eslint-directive-as-acknowledged-exception (245 + 254 + 276 + 278) + §library-reaches-784-sections at cycle 278 + §one-hundred-and-eleventh consecutive designs-chat alternation cycles 166-250 + 252-278.

## Pattern summary (tag-prefixed)

§the-binary-signature-constants-file-shape + §the-`PK`-historic-magic-prefix-as-named-format-vocabulary (Phil Katz initials) + §six-section-types-named (LOCAL_FILE_HEADER + CENTRAL_FILE_HEADER + CENTRAL_DIRECTORY_END + ZIP64_CENTRAL_DIRECTORY_LOCATOR + ZIP64_CENTRAL_DIRECTORY_END + DATA_DESCRIPTOR) + §the-`ZIP64_`-prefix-as-named-extended-format-marker + §the-`u()`-local-helper-with-`charCodeAt(i) & 0xff`-pattern + §the-`charCodeAt(i) & 0xff`-pattern-as-named-defensive-byte-extraction + §single-letter-named-helper-`u`-for-dense-constant-definition + §the-`no-bitwise: ["off"]`-ESLint-directive-as-named-acknowledgment + §four-cycles-with-named-eslint-directive-as-acknowledged-exception (245 panic + 254 no-shim + 276 source-map-node + 278 zip-signature) + §two-named-ESLint-disable-shapes (file-scope `/* eslint X: ["off"] */` + line-scope `// eslint-disable-next-line`) + §the-`// @ts-check`-directive-IS-canonical-across-the-cluster.
