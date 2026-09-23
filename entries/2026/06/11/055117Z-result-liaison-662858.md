---
ts: 2026-06-11T05:51:17Z
kind: result
role: liaison
dispatch: 662858
host: endolin
model: opus-4-7-1m
---

# librarian cycle 296 — chat-lane — `@endo/zip/src/format-reader.js` — THE ZIP CLUSTER SOURCE-FILE DEEP INGEST COMPLETES

Cycle 296 (chat-lane after cycle 295 designs-lane @endo/ses/docs/ses-0.7.md). One source ingested: `@endo/zip/src/format-reader.js` (479 lines; the cluster's largest file at ~1.8× the writer's line count). **The zip cluster source-file deep ingest completes at 11 of 12 files** (only the 4-line `compression.js` remains; trivially-covered by cycle 191's cluster-scope ingest).

## Library state

- **808 sections** (up from 807 at cycle 295).
- 346 source documents (up from 345).
- §one-hundred-and-twenty-ninth consecutive designs-chat alternation cycles 166-250 + 252-296 (251 was out-of-band).
- **§the-zip-cluster-source-file-deep-ingest-COMPLETES at 11 of 12 files** (the 12th IS the 4-line `compression.js` trivial exception).

## Files written

- `library/sections/endo--packages-zip-src-format-reader-js--symmetric-reverse-pipeline-and-Zip64-rejection-with-security-rationale-and-findLast-deliberately-not-used-and-named-strike-a-compromise.md` (new section file; 479-line file in full scope).
- `library/sources/endo--packages-zip-src-format-reader-js.md` (new source page).
- `library/sections/README.md` (Total bumped 807 → 808; sources 345 → 346; new entry added).
- `library/sources/README.md` (new row inserted).
- `library/keywords.md` (new keyword entries + 48 first-explicit-observations + new counter rows; THE ZIP CLUSTER SOURCE-FILE DEEP INGEST COMPLETES).
- `inboxes/endolin/scholar.md` (drain marker bumped `pending-cycle-295` → `pending-cycle-296`).

## First-explicit-observations (forty-eight)

Major: §the-symmetric-reverse-pipeline (recordToFile → decompressFile → decodeFile reverses cycle 294) + §the-reverse-DOS-date-time-bit-extraction + §the-Zip64-rejection-with-named-security-rationale (six named MAX_VALUE trigger fields) + §the-explicit-comment-against-`reader.findLast` (§the-named-tool-IS-available-but-deliberately-not-used; §two-cycles-with-named-tool-vs-deliberate-non-use 292 + 296) + §the-named-`Agoric is not comfortable supporting`-as-named-organizational-trust-claim + §the-named-Windows-vs-spec-filename-quirk with §the-named-spoofing-attack-reference (named-CVE-style-link-as-named-vulnerability-anchor: seclists.org) + §the-named-strike-a-compromise-discipline + §the-`MAX_VALUE_16BITS`/`32BITS`-named-constants + §the-`textDecoder = new TextDecoder()` module-scope-singleton (§two-cycles-with-named-module-scope-Text-Encoder-Decoder-singletons: 294 + 296) + §the-named-locale-warning-comment + §the-named-internal-`check(value, message)`-closure-helper + §six-named-integrity-checks (bitFlag + compressionMethod + crc32 + compressedLength + uncompressedLength + content-checksum; the-recomputed-content-crc32-IS-the-named-belt-and-suspenders-discipline) + §the-`isEncrypted(bitFlag)` + named-rejection-of-encrypted-zip + §the-named-directory-entry-bit (0x0010) + §the-`max-lines: ["off"]`-second-eslint-rule (acknowledged 479-line violation of cycle 295's 300-line discipline) + §four-named-`@import`-declarations + §two-named-imports-styles-in-the-zip-cluster + §the-named-four-typedef-block-at-the-top + §the-named-spec-aware-rejection.

## Multi-cycle pattern recognition

- **§two-cycles-with-named-tool-vs-deliberate-non-use** (cycle 292 declared findLast for zip + cycle 296 declines to use for security).
- **§two-cycles-with-DOS-date-time-bit-handling** (294 packing + 296 extraction).
- **§two-cycles-with-named-module-scope-Text-Encoder-Decoder-singletons** (294 + 296).
- **§two-cycles-with-`q`-alias-in-error-messages-in-the-zip-cluster** (292 buffer-reader + 296 format-reader).
- **§two-cycles-with-the-named-typedef-block-at-the-top in the zip cluster** (294 + 296).
- **§two-named-imports-styles-in-the-zip-cluster** (cycle 284's reader.js inline + cycle 296's `@import`).
- **§the-zip-cluster-source-file-deep-ingest-COMPLETES at 11 of 12** (signature 278 + writer 280 + types 282 + reader 284 + crc32 286 + deflate+inflate 288 + buffer-writer 290 + buffer-reader 292 + format-writer 294 + format-reader 296; compression.js IS the 4-line trivial exception).

## Synthesis target

Slot machine library `@game/replay/src/format-reader.js`: symmetric-reverse-pipeline (recordToFile → decompressFile → decodeFile); inverse bit-extraction with `>> N & 0xMM` per field; named six-named-format-extension-trigger-fields with named-rejection; explicit-comment-against-the-spec-prescribed-method with named-security-rationale + named-tool-IS-available-but-deliberately-not-used discipline; named-organization-attribution in security comment; named platform-deviation-in-the-wild; named-CVE-style-link as named-vulnerability-anchor; named-strike-a-compromise with bounded tolerance; MAX_VALUE_NBITS named constants in decimal; module-scope TextDecoder singleton; named-locale-warning-comment; named-internal-closure-helper; named six-named-integrity-checks; named-feature-detection-via-bit-flag with named-feature-rejection; named-incomplete-directory-support TODO; named `max-lines: ["off"]` acknowledged-deviation; named four-typedef-block at the top; named-canonical-`@import`-form.

## Single most structurally interesting move

**§the-explicit-comment-against-`reader.findLast(signature.CENTRAL_DIRECTORY_END)`** with **§the-named-tool-IS-available-but-deliberately-not-used** — cycle 292's buffer-reader.js EXPOSES `findLast` as a method explicitly named "for zip's end-of-central-directory record". But cycle 296's format-reader.js **deliberately doesn't use it**, naming three justifications:

1. **The spec-prescribed method** (named via the comment as the convention).
2. **The named threat-model** ("undesirable, attackable ambiguities").
3. **The named organizational position** ("Agoric is not comfortable supporting").

The result: cycle 292's tool exists but cycle 296's code declines to use it. **§the-named-tool-IS-available-but-the-named-implementation-IS-narrower-than-the-tool-permits**. The discipline IS to *provide a tool* (cycle 292) AND *deliberately not use it for security reasons* (cycle 296) — and to *document the choice in the consuming code*, not just in the tool's docs.

§the-named-decoupling-of-tool-from-policy: the tool (findLast) IS general; the policy (don't use it for finding end-of-central-directory record because of attack ambiguities) IS specific to this file. The cycle 292 buffer-reader.js doesn't need to know that cycle 296 format-reader.js declines to use one of its methods; the declination IS documented at the consumer.

§the-named-meta-discipline: cycles 292 and 296 together form a *named pedagogy* about *when to use library tools and when not to*. The reader IS expected to recognize that "the library provides X, but we don't always use it" — a more nuanced posture than "the library IS the API".

## The zip cluster source-file deep ingest IS now complete

Twelve files in `@endo/zip/src/`, ten per-file deeply ingested (the 11th is buffer-reader.js + buffer-writer.js paired across two cycles; the 12th IS the 4-line trivial compression.js):

| Cycle | File | Lines |
|---|---|---|
| 191 (cluster) | (all 11 files in one cluster ingest) | 1482 |
| 278 | signature.js | 22 |
| 280 | writer.js | 64 |
| 282 | types.js | 76 |
| 284 | reader.js | 60 |
| 286 | crc32.js | 48 |
| 288 | {deflate,inflate}.js | 58 (31+27) |
| 290 | buffer-writer.js | 188 |
| 292 | buffer-reader.js | 274 |
| 294 | format-writer.js | 264 |
| 296 | format-reader.js | 479 |
| 191 (only) | compression.js | 4 |

**§the-named-cluster-IS-now-deeply-mapped**: every non-trivial source file in the @endo/zip package has been ingested at per-file deep scope, with multi-cycle pattern observations linking the cluster's internal disciplines.

## Next cycle

Cycle 297 — designs-lane next.
