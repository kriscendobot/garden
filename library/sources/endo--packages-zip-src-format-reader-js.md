---
title: "@endo/zip/src/format-reader.js — symmetric reverse pipeline; Zip64 rejection with named security rationale; findLast deliberately not used despite being available; named-strike-a-compromise for Windows filename quirk"
source-slug: endo--packages-zip-src-format-reader-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/format-reader.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/format-reader.js
total-lines: 479
ingest-cycle: 296
ingest-date: 2026-06-11
lane: chat
---

# `@endo/zip/src/format-reader.js`

A 479-line file implementing the symmetric reverse counterpart to cycle 294's format-writer.js (264 lines). **The cluster's largest file** at ~1.8× the writer's line count — parser task-asymmetry shows up at the format level too. Completes the zip cluster source-file deep ingest at 11 of 12 files (the remaining `compression.js` IS a 4-line constant declaration trivially covered by cycle 191's cluster-scope ingest).

## Key moves

- **§the-symmetric-reverse-pipeline** — recordToFile → decompressFile → decodeFile reverses cycle 294's encodeFile → compress → makeRecord; the-named-pipeline-IS-bidirectional-with-named-inverses.
- **§the-reverse-DOS-date-time-bit-extraction** — `>> N & 0xMM` per field with trailing comments; bit mask widths match bit field widths; §two-cycles-with-DOS-date-time-bit-handling (294 packing + 296 extraction).
- **§the-Zip64-rejection-with-named-security-rationale** — six named MAX_VALUE checks across two named locations; the-named-MAX_VALUE-IS-the-Zip64-sentinel; the-named-feature-rejection-with-named-reason.
- **§the-explicit-comment-against-`reader.findLast(signature.CENTRAL_DIRECTORY_END)`** — cycle 292's tool IS available but deliberately not used; the-named-attackable-ambiguity-IS-the-named-design-driver; the-named-strict-implementation-IS-narrower-than-the-spec-permits.
- **§two-cycles-with-named-tool-vs-deliberate-non-use** (cycle 292 declared findLast for zip + cycle 296 declines to use for security).
- **§the-named-`Agoric is not comfortable supporting`-as-named-organizational-trust-claim** — the-named-attribution-of-the-design-judgment.
- **§the-named-Windows-vs-spec-filename-quirk** — the-named-spec-deviation-in-the-wild; the-named-search-string-IS-the-named-googleable-shorthand.
- **§the-named-spoofing-attack-reference** — `http://seclists.org/fulldisclosure/2009/Sep/394` as named-CVE-style-link-anchor; the-named-prior-vulnerability-IS-named-explicitly.
- **§the-named-strike-a-compromise-discipline** — "We strike a compromise: the central directory name may vary from the local name exactly and only by different slashes"; the-narrow-tolerance-IS-the-named-balance.
- **§the-`MAX_VALUE_16BITS` + `MAX_VALUE_32BITS`-named-constants** — explicit decimal values (not hex); the-named-bit-width-IS-the-named-suffix.
- **§the-`textDecoder = new TextDecoder()` module-scope-singleton** (cycle 294 textEncoder + cycle 296 textDecoder; §two-cycles-with-named-module-scope-Text-Encoder-Decoder-singletons).
- **§the-named-locale-warning-comment** — encoding depends on system locale (Linux UTF-8 vs Windows codepage); the-named-cross-platform-encoding-ambiguity; the-named-acknowledged-but-not-yet-solved-limitation.
- **§the-named-internal-`check(value, message)`-closure-helper** — closes over localName + archiveName; the-named-context-closure-IS-the-named-DRY-discipline.
- **§six-named-integrity-checks** — bitFlag + compressionMethod + crc32 + compressedLength + uncompressedLength + content-checksum; the-recomputed-content-crc32-IS-the-named-belt-and-suspenders-discipline.
- **§the-`isEncrypted(bitFlag)`-named-helper** + the rejection of encrypted zip; the-named-feature-detection-via-bit-flag (bit 0 IS the encryption flag).
- **§the-named-directory-entry-bit** — `(externalFileAttributes & 0x0010) !== 0`; the-named-DOS-directory-attribute-bit; the-named-incomplete-directory-support.
- **§the-`max-lines: ["off"]`-second-eslint-rule** — line 2 has TWO ESLint directives; the file IS 479 lines, exceeding cycle 295's named 300-line discipline; the-named-acknowledged-violation.
- **§four-named-`@import`-declarations-for-four-imported-typedefs** — uses canonical `@import` form (cycle 284's reader.js used inline `import(...)` form); §two-named-imports-styles-in-the-zip-cluster; the-cluster-uses-both-forms.
- **§the-`import './types.js'` (without binding)** — side-effect import of the §`export {};`-typedef-only file.
- **§the-named-four-typedef-block-at-the-top** (CentralFileRecord + LocalFileRecord + CentralDirectoryLocator + BufferReader); the-named-block-IS-richer-in-the-reader-than-the-writer.
- **§the-named-spec-aware-rejection** — comment cites the spec's prescribed method AND the reason for deviating.
- **§the-zip-cluster-source-file-deep-ingest-COMPLETES at 11 of 12 (compression.js IS the 4-line trivial exception)**.

## Section files

- [§symmetric-reverse-pipeline + §Zip64-rejection-with-security-rationale + §findLast-deliberately-not-used + §the-named-strike-a-compromise + 44 more first-explicit-observations](../sections/endo--packages-zip-src-format-reader-js--symmetric-reverse-pipeline-and-Zip64-rejection-with-security-rationale-and-findLast-deliberately-not-used-and-named-strike-a-compromise.md) — full 479-line file in scope at cycle 296 per-file deep ingest after cluster-scope in cycle 191.

## Ingest scope

Cycle 296 (chat-lane after cycle 295 designs-lane @endo/ses/docs/ses-0.7.md). Full 479-line file in scope. **First-explicit-observations (forty-eight)** at per-file deep ingest scope, extending cycle 191's cluster-scope coverage. The zip cluster source-file deep ingest now progresses to 11 of 12 files (only the 4-line `compression.js` remains; trivially-covered by cycle 191).
