---
title: "@endo/zip/src/buffer-reader.js — windowed reader over Uint8Array+DataView pair; richer API surface than buffer-writer; can/assertCan/X triad; IE10 historical-ghost comment; findLast reverse-search for zip trailing markers"
source-slug: endo--packages-zip-src-buffer-reader-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/buffer-reader.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/buffer-reader.js
total-lines: 274
ingest-cycle: 292
ingest-date: 2026-06-11
lane: chat
---

# `@endo/zip/src/buffer-reader.js`

A 274-line windowed reader over a Uint8Array + DataView pair. Symmetric counterpart to cycle 290's buffer-writer (188 lines), but with **richer API surface** (~1.5× lines) reflecting task-asymmetry: parsers need richer inspection primitives than emitters. Per-file deep ingest extending cycle 191's cluster-scope coverage.

## Key moves

- **§the-`q = JSON.stringify`-alias-as-named-error-formatting-helper** — `const q = JSON.stringify;` at line 4; sibling-pattern to `@endo/errors`'s exported `q` helper.
- **§the-`privateFieldsGet = privateFields.get.bind(privateFields)`-pattern** — bound version of `get` instead of cycle 290's `getPrivateFields(self)` named-helper-function; two named shapes for the same purpose in the same cluster.
- **§the-named-policy-asymmetry-in-the-cluster** — cycle 290's writer throws on missing-instance; cycle 292's reader returns undefined and casts-it-away; less defensive private-state access.
- **§the-`@typedef`-named-state-shape** (`BufferReaderState`) vs cycle 290's inline-anonymous-type on the WeakMap; §two-named-shapes-for-WeakMap-private-state-typing-in-the-cluster.
- **§the-six-field-private-record** — `{ bytes, data, length, index, offset }`; the **`offset`** IS the logical-start-within-buffer (not in writer).
- **§the-named-window-into-the-underlying-buffer** — offset + length define the logical view; methods translate via `fields.offset + fields.index`.
- **§the-`set offset(offset)` with-length-recomputation** — setter validates + recomputes derived state.
- **§the-`can`/`assertCan`/X-triad-for-each-operation** — three named methods (predicate + assertion + do-it) for each pre-conditional operation; richer than cycle 290's binary pair (`ensureCanX` + `X`).
- **§the-named-task-asymmetry-shape** — parsers need richer inspection primitives than emitters; reader-API-IS-richer-than-the-writer-API.
- **§the-`read = peek + advance`-discipline** — consume operation IS inspect + cursor-advance; named composability.
- **§the-named-two-shapes-of-reading** — peek (look-without-advancing) + read (look-and-advance).
- **§the-peek-clamp-discipline** — `size = Math.max(0, Math.min(fields.length - fields.index, size))`; peek-IS-lenient vs read-IS-strict.
- **§the-IE10-historical-ghost-comment** — `// in IE10, when using subarray(idx, idx), we get the array [0x00] instead of []`; named historical-defense for now-dead browser; the-comment-IS-the-named-warning-against-modern-simplification.
- **§the-`matchAt`-vs-`expect`-distinction** — matchAt (non-advancing, arbitrary index) + expect (current-index, advance-if-match).
- **§the-named-three-shapes-of-pattern-match** — matchAt (peek-match) + expect (read-match-or-not) + assert (read-match-or-throw).
- **§the-`assert(expected)` throws-with-detailed-error** — names both expected and actual; the `q(expected)` alias pays off here.
- **§the-`findLast(expected)`-reverse-search-pattern** — used for zip's end-of-central-directory record (trailing-marker shape); the-named-zip-specific-need-for-reverse-search.
- **§the-`seek` returns-prior-index** — save-restore protocol via return value; the-named-undo-via-return-value.
- **§the-`offset + index`-for-absolute-position pattern** — two-level indexing (logical + physical).
- **§the-`byteAt(index)` for-direct-bypass-of-cursor** — inspects bytes without disturbing read position.
- **§the-`skip(offset)`-IS-just-`seek(fields.index + offset)`** — named relative-vs-absolute position operations; intent-revealing convenience.
- **§two-named-reader-writer-pairs-in-the-cluster** — high-level reader.js + writer.js (cycles 280 + 284) + low-level buffer-reader.js + buffer-writer.js (cycles 290 + 292).
- **§three-cycles-with-error-message-naming-both-sides** — cycle 284 (file-name + archive-name) + cycle 292 (expected + actual + position).

## Section files

- [§WeakMap-private-fields with bound-get helper + §can/assertCan/X-triad + §IE10 historical-ghost comment + §findLast reverse-search + 41 more first-explicit-observations](../sections/endo--packages-zip-src-buffer-reader-js--WeakMap-private-fields-with-bound-get-helper-and-can-assertCan-do-it-triad-and-IE10-historical-ghost-comment-and-findLast-reverse-search.md) — full 274-line file in scope at cycle 292 per-file deep ingest after cluster-scope in cycle 191.

## Ingest scope

Cycle 292 (chat-lane after cycle 291 designs-lane ses/docs/draft-standalone-spec.md). Full 274-line file in scope. **First-explicit-observations (forty-five)** at per-file deep ingest scope, extending cycle 191's cluster-scope coverage. The zip cluster source-file deep ingest now progresses to 9 of 12 files (signature 278 + writer 280 + types 282 + reader 284 + crc32 286 + deflate+inflate 288 + buffer-writer 290 + buffer-reader 292).
