---
title: "@endo/syrups package: grammar, API, and naming rationale"
source: designs/ocapn-tcp-syrups-framing.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: a4978698b19bbea5fcb8049e5cb7944ac8f2485a
source_date: 2026-05-06
source_authors: [Kris Kowal]
ingested: 2026-06-22
ingested_by: librarian
topics: [streams, ocapn]
status: current
---

> Abstract: The `@endo/syrups` package specification. Grammar: `frame = length ":" payload` (decimal ASCII digits, colon, exactly `length` octets of payload; no trailing comma). Differences from Netstring: no `,` separator; the encoding of an empty payload is `0:` (two octets). Leading zeros prohibited except for literal `0`. The package mirrors `@endo/netstring` module-for-module: `reader.js` exports `makeSyrupsReader`; `writer.js` exports `makeSyrupsWriter`; `index.js` re-exports both. The migration from `@endo/netstring` is a mechanical rename at call sites. No legacy aliases are carried forward (no `netstringReader`/`netstringWriter` equivalents — the package is new with no legacy callers). The `chunked` zero-copy writer mode is preserved unchanged. Naming rationale: `@endo/syrups` (plural-of-format convention shared with `@endo/cbors`) was chosen over `@endo/syrup-frame` (earlier recommendation) because "plural of the format being framed" is the cohort pattern; the README documents the grammar's independence from any Syrup dependency but does not pretend the naming is neutral.

**Grammar specification (lines 153-178):**

```
frame   = length ":" payload
length  = 1*DIGIT
DIGIT   = "0" / "1" / ... / "9"
payload = length * OCTET
```

Byte-level comparison:

| Payload | Netstring | Syrups |
|---------|-----------|--------|
| empty | `0:,` (3 bytes) | `0:` (2 bytes) |
| `A` | `1:A,` (4 bytes) | `1:A` (3 bytes) |
| `hello` | `5:hello,` (8 bytes) | `5:hello` (7 bytes) |

**Reader (lines 218-253):**
`makeSyrupsReader(input, opts)` — derived from `packages/netstring/reader.js` with exactly one behavioral change: after reading `remainingDataLength` bytes into `dataBuffer`, the reader yields the frame and immediately resets to `lengthBuffer = []` without looking for a `,` separator. The `COMMA` check at `packages/netstring/reader.js` line 104-110 is removed entirely. All "waiting for length" logic (digit accumulation, prefix-too-long detection, chunk-boundary handling inside the length prefix) is unchanged. The `name` and `maxMessageLength` options retain their netstring semantics.

**Writer (lines 255-291):**
`makeSyrupsWriter(output, { chunked = false })` — derived from `packages/netstring/writer.js` with two changes: (1) `COMMA_BUFFER` constant removed; (2) every write sequence loses its terminal `output.next(COMMA_BUFFER)` call. The `chunked` zero-copy mode is preserved verbatim.

**Naming rationale (lines 115-151):**
Candidates considered: `@endo/byte-string` (too generic), `@endo/syrups` (plural-of-format, cohort with `@endo/cbors`), `@endo/syrup-frame` (earlier recommendation), `@endo/length-prefixed` (too generic), `@endo/netstring-lite` (implies lesser), `@endo/tethered-string` (obscure). Winner: `@endo/syrups`. The cohort pattern of "plural of format being framed" (shared with `@endo/cbors`) won over the literal accuracy of `@endo/byte-string`. PR 86's review chain confirmed the cohort-consistency rationale.
