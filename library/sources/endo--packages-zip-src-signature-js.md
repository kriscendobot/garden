---
title: "@endo/zip/src/signature.js — six named ZIP binary-signature constants with the historic 'PK' magic prefix"
source-slug: endo--packages-zip-src-signature-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/signature.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/signature.js
total-lines: 22
ingest-cycle: 278
ingest-date: 2026-06-10
lane: chat
---

# `@endo/zip/src/signature.js`

A 22-line file that exports **six binary-signature constants** representing the ZIP file format's section markers. Each constant is a `Uint8Array` produced by a local `u(string)` helper. **The smallest file ingested that exports six named constants.**

## Key moves

- **§The binary-signature-constants file shape** — a file whose sole purpose IS exporting binary constants with descriptive names; canonical for format parsers.
- **§The 'PK' historic magic prefix as named format vocabulary** — Phil Katz's initials (PKZIP author); sibling-pattern to many file-format magic bytes.
- **§Six section types named** — LOCAL_FILE_HEADER + CENTRAL_FILE_HEADER + CENTRAL_DIRECTORY_END + ZIP64_CENTRAL_DIRECTORY_LOCATOR + ZIP64_CENTRAL_DIRECTORY_END + DATA_DESCRIPTOR.
- **§The `ZIP64_` prefix as named extended-format marker** in binary-signature constants.
- **§The `charCodeAt(i) & 0xff` pattern** as named defensive byte extraction — mask defends against high-byte characters; truncates rather than corrupts.
- **§Single-letter named helper `u`** for dense constant definition — when a helper is used six times in six lines, a single-letter name IS the canonical form.
- **§The `no-bitwise: ["off"]` ESLint directive** as named acknowledgment — file-scope opt-out when bitwise IS the right tool for binary parsing.
- **§Four cycles with named ESLint directive as acknowledged exception** (245 panic + 254 no-shim + 276 source-map-node + 278 zip-signature).
- **§Two named ESLint disable shapes** — file-scope (`/* eslint X: ["off"] */`) + line-scope (`// eslint-disable-next-line`).
- **§The `// @ts-check` directive IS canonical across the cluster** — per the project CLAUDE.md's discipline.

## Section files

- [§Six named binary signature constants + §the 'PK' historic magic prefix + §the u() helper with charCodeAt and byte masking + §the binary-signature-constants file shape](../sections/endo--packages-zip-src-signature-js--six-named-binary-signature-constants-and-the-PK-historic-magic-prefix-and-the-u-helper-with-charCodeAt-and-byte-masking-and-the-binary-signature-constants-file-shape.md) — full 22-line file in scope.

## Ingest scope

Cycle 278 (chat-lane after cycle 277's designs-lane outliner_drag_and_drop). Full 22-line file ingested. **First-explicit-observations (eight)**: the-binary-signature-constants-file-shape + the-`PK`-historic-magic-prefix-as-named-format-vocabulary + the-`ZIP64_`-prefix-as-named-extended-format-marker + the-`charCodeAt(i) & 0xff`-pattern-as-named-defensive-byte-extraction + single-letter-named-helper-`u`-for-dense-constant-definition + the-`no-bitwise: ["off"]`-ESLint-directive-as-named-acknowledgment + four-cycles-with-named-eslint-directive-as-acknowledged-exception (245 + 254 + 276 + 278) + two-named-ESLint-disable-shapes (file-scope + line-scope).
