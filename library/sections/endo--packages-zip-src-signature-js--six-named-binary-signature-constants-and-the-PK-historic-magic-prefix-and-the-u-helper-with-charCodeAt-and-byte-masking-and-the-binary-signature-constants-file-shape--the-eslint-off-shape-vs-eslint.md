---
title: §The `/* eslint ... ["off"] */` shape vs `// eslint-disable-next-line`
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

The cycle 278 directive `/* eslint no-bitwise: ["off"] */` is a **file-scope** disable, distinct from cycle 245's **line-scope** `// eslint-disable-next-line` shape:

- **File-scope** (cycle 278): `/* eslint no-bitwise: ["off"] */` at the top of the file disables the rule for the whole file.
- **Line-scope** (cycle 245): `// eslint-disable-next-line ...` disables the rule for the next line only.

§First-explicit-observation in library: **§two-named-ESLint-disable-shapes (file-scope + line-scope) — §the-file-scope-shape-IS-used-when-the-rule-IS-violated-throughout-the-file (e.g., bitwise in a binary-parser) + §the-line-scope-shape-IS-used-when-the-rule-IS-violated-at-one-line + §the-choice-IS-the-named-discipline**.
