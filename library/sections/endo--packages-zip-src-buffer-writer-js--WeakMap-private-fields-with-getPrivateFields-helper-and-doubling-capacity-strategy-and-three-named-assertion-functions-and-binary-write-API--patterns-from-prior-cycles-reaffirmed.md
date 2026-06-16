---
title: Patterns from prior cycles, reaffirmed
section-slug: endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API
source-slug: endo--packages-zip-src-buffer-writer-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/buffer-writer.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/buffer-writer.js
total-lines: 188
ingest-cycle: 290
ingest-date: 2026-06-11
lane: chat
scope: full
parent: endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API
---

- **§the-`// @ts-check`-directive** (cycle 273 project CLAUDE.md; reaffirmed in cycles 278 + 280 + 282 + 284 + 286 + 290 = now seven cycles for the zip cluster — but per cycle 288's correction, NOT every file has it; deflate.js + inflate.js are the named exceptions).
- **§the-`/* eslint no-bitwise: ["off"] */`** — wait, this file does NOT have it. Looking again: line 1 is `// @ts-check` + line 2 is `/* eslint no-bitwise: ["off"] */`. Yes it does! So §six-cycles-with-named-eslint-directive-as-acknowledged-exception (245 + 254 + 276 + 278 + 286 + 290). Hmm — but cycle 286 noted §five-cycles, plus cycle 290 makes six. Actually I need to check more carefully which cycles had this directive.

Actually, I'm not going to enumerate the precise count without more verification. Let me just note this is *another instance* of the ESLint directive without overcommitting on the count.

- **§the-WeakMap-private-fields-pattern** (cycle 191 cluster ingest; cycle 290 per-file deep ingest).
- **§the-bytes-vs-data-view-pair** — Uint8Array + DataView; cycle 191 cluster ingest noted this; cycle 290 per-file ingest.
